//
//  ViewController.swift
//  UKDWPay
//
//  Created by Yoel Tanujaya on 27/5/17.
//  Copyright © 2017 Yoel Tanujaya. All rights reserved.
//

import UIKit
import SQLite

class ViewController: UIViewController {
    
    //Buka koneksi ke database, file sqlite ada di folder project
    let db = try! Connection("/Users/yoeltan/Desktop/iOS Project/UKDWPay/db.sqlite3")
    
    //Menyimpan index untuk menampilkan nama dan saldo dari user yag login di view selanjutnya
    var idnum:String = ""
    
    //var barang = Items()
    
    let users = Table("users")
    let id = Expression<Int>("id")
    let idnumber = Expression<String>("idnumber")
    let username = Expression<String>("username")
    let userpwd = Expression<String>("userpwd")
    let name = Expression<String?>("name")
    let email = Expression<String>("email")
    let phone = Expression<String>("phone")
    let balance = Expression<Int>("balance")
    
    let pulsa = Table("pulsa")
    let pulsaId = Expression<Int>("idPulsa")
    let pulsaNom = Expression<Int>("pulsa")
    let pulsaPrice = Expression<Double>("price")
    let pulsaActive = Expression<Int>("active")
    
    let data = Table("data")
    let dataId = Expression<Int>("idData")
    let dataQuota = Expression<Int>("quota")
    let dataPrice = Expression<Double>("price")
    let dataActive = Expression<Int>("active")
    
    let opt = Table("operator")
    let idOpt = Expression<Int>("idOpt")
    let optPulsaId = Expression<Int>("idPulsa")
    let optDataId = Expression<Int>("idData")
    let nameOpt = Expression<String>("name")
    let prefixNumber = Expression<String>("prefixNumber")
    let img = Expression<String>("imgPath")
    
    var userDict:[String:String] = [:]
    
    @IBAction func infoButton(_ sender: UIButton) {
        let alert = UIAlertController(title: "Final Project iOS", message: "©️Yoel Tanujaya - 71150014", preferredStyle: .alert)
        let btnOK = UIAlertAction(title: "Done", style: .cancel, handler: nil)
        alert.addAction(btnOK)
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBOutlet weak var usrLoginTextField: UITextField!
    
    @IBOutlet weak var pwLoginTextField: UITextField!
    
    @IBAction func loginButton(_ sender: UIButton) {
        for user in try! db.prepare(users.select(username,userpwd)) {
            userDict.updateValue(user[username], forKey: user[userpwd])
        }
        for (username,userpwd) in userDict {
            if (username != usrLoginTextField.text!) {
                let alert = UIAlertController(title: "Wrong Username or Password", message: "Please Try Again", preferredStyle: .alert)
                let btnOK = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alert.addAction(btnOK)
                self.present(alert, animated: true, completion: nil)
                pwLoginTextField.textColor = UIColor.red
                usrLoginTextField.textColor = UIColor.red
            }
            else {
                if (userpwd != pwLoginTextField.text!) {
                    let alert = UIAlertController(title: "Wrong Username or Password", message: "Please Try Again", preferredStyle: .alert)
                    let btnOK = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alert.addAction(btnOK)
                    self.present(alert, animated: true, completion: nil)
                    pwLoginTextField.textColor = UIColor.red
                    usrLoginTextField.textColor = UIColor.red
                    
                }
                else {
                    idnum = username
                    self.performSegue(withIdentifier: "loginSegue", sender: self)
                }
            }
            break
        }
    }
    
    @IBAction func passEnterTrigger(_ sender: Any) {
        for user in try! db.prepare(users.select(username,userpwd)) {
            userDict.updateValue(user[username], forKey: user[userpwd])
        }
        for (username,userpwd) in userDict {
            if (username != usrLoginTextField.text!) {
                let alert = UIAlertController(title: "Wrong Username or Password", message: "Please Try Again", preferredStyle: .alert)
                let btnOK = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alert.addAction(btnOK)
                self.present(alert, animated: true, completion: nil)
                pwLoginTextField.textColor = UIColor.red
                usrLoginTextField.textColor = UIColor.red
            }
            else {
                if (userpwd != pwLoginTextField.text!) {
                    let alert = UIAlertController(title: "Wrong Username or Password", message: "Please Try Again", preferredStyle: .alert)
                    let btnOK = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alert.addAction(btnOK)
                    self.present(alert, animated: true, completion: nil)
                    pwLoginTextField.textColor = UIColor.red
                    usrLoginTextField.textColor = UIColor.red
                    
                }
                else {
                    idnum = username
                    self.performSegue(withIdentifier: "loginSegue", sender: self)
                }
            }
            break
        }
    }
    
    @IBOutlet weak var nameSignupTextField: UITextField!
    
    @IBOutlet weak var usernameSignupTextField: UITextField!
    
    @IBOutlet weak var emailSignupTextField: UITextField!
    
    @IBOutlet weak var pwSignupTextField: UITextField!
    
    @IBOutlet weak var pw2SignupTextField: UITextField!
    
    @IBOutlet weak var phoneSignupTextField: UITextField!
    
    @IBOutlet weak var idSignupTextField: UITextField!
    
    @IBAction func signupButton(_ sender: UIButton) {
        if (passValid() && emailValid()) {
            let insert = users.insert(userpwd <- pwSignupTextField.text!, idnumber <- idSignupTextField.text!, username <- usernameSignupTextField.text!, name <- nameSignupTextField.text!, phone <- phoneSignupTextField.text!, email <- emailSignupTextField.text!, balance <- 0)
            try! db.run(insert)
            let alert = UIAlertController(title: "Registration Success", message: "Congratulations, user registered successfully. Please Login to start using", preferredStyle: .alert)
            let btnOK = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alert.addAction(btnOK)
            self.present(alert, animated: true, completion: nil)
            clearText()
        }
        else {
            if (!passValid()) {
                let alert = UIAlertController(title: "Password Not Match", message: "The password you entered doesn't match, please try again", preferredStyle: .alert)
                let btnOK = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alert.addAction(btnOK)
                self.present(alert, animated: true, completion: nil)
                pwSignupTextField.textColor = UIColor.red
                pw2SignupTextField.textColor = UIColor.red
                if (emailValid()){
                    emailSignupTextField.textColor = UIColor.black
                }
            }
            else if (!emailValid()) {
                let alert = UIAlertController(title: "Invalid Email", message: "Email address you entered is not valid, please try again", preferredStyle: .alert)
                let btnOK = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alert.addAction(btnOK)
                self.present(alert, animated: true, completion: nil)
                emailSignupTextField.textColor = UIColor.red
                if (passValid()) {
                    pwSignupTextField.textColor = UIColor.black
                    pw2SignupTextField.textColor = UIColor.black
                }
            }
            else {
                let alert = UIAlertController(title: "Invalid Email and Password", message: "Email address you entered is not valid, and password you entered doesn't match, please try again", preferredStyle: .alert)
                let btnOK = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alert.addAction(btnOK)
                self.present(alert, animated: true, completion: nil)
                pwSignupTextField.textColor = UIColor.red
                pw2SignupTextField.textColor = UIColor.red
                emailSignupTextField.textColor = UIColor.red
            }
        }
    }
    @IBAction func finalFieldEnterTrigger(_ sender: Any) {
        if (passValid() && emailValid()) {
            let insert = users.insert(userpwd <- pwSignupTextField.text!, idnumber <- idSignupTextField.text!, username <- usernameSignupTextField.text!, name <- nameSignupTextField.text!, phone <- phoneSignupTextField.text!, email <- emailSignupTextField.text!, balance <- 0)
            try! db.run(insert)
            let alert = UIAlertController(title: "Registration Success", message: "Congratulations, user registered successfully. Please Login to start using", preferredStyle: .alert)
            let btnOK = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alert.addAction(btnOK)
            self.present(alert, animated: true, completion: nil)
            clearText()
        }
        else {
            if (!passValid()) {
                let alert = UIAlertController(title: "Password Not Match", message: "The password you entered doesn't match, please try again", preferredStyle: .alert)
                let btnOK = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alert.addAction(btnOK)
                self.present(alert, animated: true, completion: nil)
                pwSignupTextField.textColor = UIColor.red
                pw2SignupTextField.textColor = UIColor.red
                if (emailValid()){
                    emailSignupTextField.textColor = UIColor.black
                }
            }
            else if (!emailValid()) {
                let alert = UIAlertController(title: "Invalid Email", message: "Email address you entered is not valid, please try again", preferredStyle: .alert)
                let btnOK = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alert.addAction(btnOK)
                self.present(alert, animated: true, completion: nil)
                emailSignupTextField.textColor = UIColor.red
                if (passValid()) {
                    pwSignupTextField.textColor = UIColor.black
                    pw2SignupTextField.textColor = UIColor.black
                }
            }
            else {
                let alert = UIAlertController(title: "Invalid Email and Password", message: "Email address you entered is not valid, and password you entered doesn't match, please try again", preferredStyle: .alert)
                let btnOK = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alert.addAction(btnOK)
                self.present(alert, animated: true, completion: nil)
                pwSignupTextField.textColor = UIColor.red
                pw2SignupTextField.textColor = UIColor.red
                emailSignupTextField.textColor = UIColor.red
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    func passValid() -> Bool {
        if (pwSignupTextField.text == pw2SignupTextField.text) {
            return true
        }
        else {
            return false
        }
    }
    
    func emailValid() -> Bool{
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        let testEmail = true
        if (testEmail==emailTest.evaluate(with: emailSignupTextField.text!)) {
            return true
        }
        else {
            return false
        }
    }
    
    func clearText() {
        nameSignupTextField.text = ""
        usernameSignupTextField.text = ""
        pwSignupTextField.text = ""
        pw2SignupTextField.text = ""
        idSignupTextField.text = ""
        phoneSignupTextField.text = ""
        pwLoginTextField.text = ""
        usrLoginTextField.text = ""
        emailSignupTextField.text = ""
        pwSignupTextField.textColor = UIColor.black
        pw2SignupTextField.textColor = UIColor.black
        emailSignupTextField.textColor = UIColor.black
        pwLoginTextField.textColor = UIColor.black
        usrLoginTextField.textColor = UIColor.black
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let dest = segue.destination as! MenuViewController
        dest.indexUser = idnum
        
    }

}

