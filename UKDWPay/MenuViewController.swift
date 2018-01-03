//
//  MenuViewController.swift
//  UKDWPay
//
//  Created by Yoel Tanujaya on 27/5/17.
//  Copyright © 2017 Yoel Tanujaya. All rights reserved.
//

import UIKit
import SQLite

class MenuViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    let users = Table("users")
    let id = Expression<Int>("id")
    let idnumber = Expression<String>("idnumber")
    let username = Expression<String>("username")
    let userpwd = Expression<String>("userpwd")
    let name = Expression<String?>("name")
    let email = Expression<String>("email")
    let phone = Expression<String>("phone")
    let balance = Expression<Int>("balance")
    
    let pulsaTable = Table("pulsa")
    let pulsaId = Expression<Int>("idPulsa")
    let pulsaNom = Expression<Int>("pulsaNom")
    let pulsaPrice = Expression<Double>("price")
    let pulsaActive = Expression<Int>("active")
    
    let data = Table("data")
    let dataId = Expression<Int>("idData")
    let dataQuota = Expression<Int>("quota")
    let dataPrice = Expression<Double>("price")
    let dataActive = Expression<Int>("active")
    let dataIndices = Expression<Int>("index")
    
    let optr = Table("operator")
    let idOpt = Expression<Int>("idOpt")
    let nameOpt = Expression<String>("name")
    let img = Expression<String>("imgPath")
    
    let prefix = Table("prefix")
    let idPrefix = Expression<Int>("id")
    let numPrefix = Expression<String>("number")
    


    
    var db = try! Connection("/Users/yoeltan/Desktop/iOS Project/UKDWPay/db.sqlite3")
    var indexUser:String = ""
    var item = Items()
    var newTotal:Int = 0
    
    
    var indexoperator:Int = 0
    
    @IBOutlet weak var namaText: UILabel!
    @IBOutlet weak var saldoText: UILabel!
    @IBOutlet weak var priceText: UILabel!
    @IBOutlet weak var totalText: UILabel!
    @IBOutlet weak var bottomMenuView: UIView!
    @IBOutlet weak var payText: UIButton!
    
    @IBOutlet weak var pulsaCollectionView: UICollectionView!
    
    @IBAction func addBalanceButton(_ sender: UIButton) {
        
        let alertController = UIAlertController(title: "Add Balance?", message: "To add balance, please input your password and amount of balance you want to add (min. Rp.10000)", preferredStyle: .alert)
        let saveAction = UIAlertAction(title: "Save", style: .default, handler: {
            alert -> Void in
            
            _ = alertController.textFields![0] as UITextField
            _ = alertController.textFields![1] as UITextField
            
            for user in try! self.db.prepare(self.users.select(self.userpwd,self.balance).filter(self.username == self.indexUser)) {
                if (alertController.textFields?[0].text == user[self.userpwd]) {
                    if ((Int((alertController.textFields?[1].text)!))! < 10000) {
                        let alertBal = UIAlertController(title: "Add Balance Failed", message: "Below Rp.10000", preferredStyle: .alert)
                        let btnOK = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                        alertBal.addAction(btnOK)
                        self.present(alertBal, animated: true, completion: nil)
                    }
                    else {
                        try! self.db.run(self.users.update(self.balance <- self.balance + Int((alertController.textFields?[1].text)!)!))
                        for user in try! self.db.prepare(self.users.select(self.balance).filter(self.username == self.indexUser)) {
                            let alert = UIAlertController(title: "\(alertController.textFields![1].text!) Balance Successfully Added", message: "Your Balance is now \(String(Int(user[self.balance])))", preferredStyle: .alert)
                            let btnOK = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                            alert.addAction(btnOK)
                            self.present(alert, animated: true, completion: nil)
                            self.saldoText.text! = String(Int(user[self.balance]))
                            self.priceText.text = "0"
                            self.totalText.text = "0"
                            self.payText.isEnabled = false
                            self.payText.isOpaque = true
                            self.pulsaDataSegment.selectedSegmentIndex = -1
                            self.nomorTextField.text = ""
                            self.prefixTextField.text = ""
                            self.voucherTextField.text = ""
                            self.pulsaCollectionView.reloadData()
                        }
                    }
                }
                else {
                    let alert = UIAlertController(title: "Add Balance Failed", message: "Password invalid", preferredStyle: .alert)
                    let btnOK = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alert.addAction(btnOK)
                    self.present(alert, animated: true, completion: nil)
                }
            }
            
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: {
            (action : UIAlertAction!) -> Void in
            
        })
        
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Password"
            textField.isSecureTextEntry = true
        }
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Balance"
            textField.keyboardType = UIKeyboardType.numberPad
        }
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
        for user in try! db.prepare(users.select(balance).filter(username == indexUser)) {
            saldoText.text! = String(Int(user[balance]))
        }

    }

    @IBOutlet weak var pulsaDataSegment: UISegmentedControl!
    

    @IBOutlet weak var nomorTextField: UITextField!
    
    @IBOutlet weak var voucherTextField: UITextField!
    
    @IBOutlet weak var prefixTextField: UITextField!
    
    
    @IBAction func useVoucherButton(_ sender: UIButton) {
        if (Int(voucherTextField.text!) == 12345678) {
            newTotal = Int(totalText.text!)! - (Int(totalText.text!)!/10)
            totalText.text = String(newTotal)
            let alert = UIAlertController(title: "Voucher Valid", message: "", preferredStyle: .alert)
            let btnOK = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alert.addAction(btnOK)
            self.present(alert, animated: true, completion: nil)
        }
        if (Int(saldoText.text!)! < newTotal) {
            payText.isEnabled = false
            payText.alpha = 0.5
        }
        else {
            payText.isEnabled = true
            payText.alpha = 1.0
        }
    }
    @IBAction func payButton(_ sender: UIButton) {
        if (nomorTextField.text?.isEmpty == false) {
                let alertController = UIAlertController(title: "Verify your Identity", message: "To continue purchase, please input your username and password", preferredStyle: .alert)
                let saveAction = UIAlertAction(title: "Confirm", style: .default, handler: {
                    alert -> Void in
                    
                    let usrnm = alertController.textFields![0] as UITextField
                    let usrpw = alertController.textFields![1] as UITextField
                    
                    for user in try! self.db.prepare(self.users.select(self.username,self.userpwd,self.balance).filter(self.username == self.indexUser)) {
                        if (usrnm.text == user[self.username]) {
                            if (usrpw.text != user[self.userpwd]) {
                                
                            }
                            else {
                                if (user[self.balance] < self.newTotal) {
                                    let alert = UIAlertController(title: "Transaction Failed", message: "Balance insufficient", preferredStyle: .alert)
                                    let btnOK = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                                    alert.addAction(btnOK)
                                    self.present(alert, animated: true, completion: nil)
                                }
                                else {
                                    try! self.db.run(self.users.update(self.balance <- self.balance - self.newTotal))
                                    for user in try! self.db.prepare(self.users.select(self.balance).filter(self.username == self.indexUser)) {
                                        let alert = UIAlertController(title: "Transaction Success!", message: "Your Balance is now \(String(Int(user[self.balance])))", preferredStyle: .alert)
                                        let btnOK = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                                        alert.addAction(btnOK)
                                        self.present(alert, animated: true, completion: nil)
                                        self.saldoText.text! = String(Int(user[self.balance]))
                                        self.priceText.text = "0"
                                        self.totalText.text = "0"
                                        self.payText.isEnabled = false
                                        self.payText.isOpaque = true
                                        self.pulsaDataSegment.selectedSegmentIndex = -1
                                        self.nomorTextField.text = ""
                                        self.prefixTextField.text = ""
                                        self.voucherTextField.text = ""
                                        self.pulsaCollectionView.reloadData()
                                    }
                                }
                            }
                        }
                        else {
                            let alert = UIAlertController(title: "Transaction Failed", message: "Username and/or password invalid", preferredStyle: .alert)
                            let btnOK = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                            alert.addAction(btnOK)
                            self.present(alert, animated: true, completion: nil)
                        }
                    }
                    
                })
                
                alertController.addTextField { (textField : UITextField!) -> Void in
                    textField.placeholder = "Username"
                }
                alertController.addTextField { (textField : UITextField!) -> Void in
                    textField.placeholder = "Password"
                    textField.isSecureTextEntry = true
                }
                
                alertController.addAction(saveAction)
                
                self.present(alertController, animated: true, completion: nil)
                for user in try! db.prepare(users.select(balance).filter(username == indexUser)) {
                    saldoText.text! = String(Int(user[balance]))
                }
        }
        else {
            let alert = UIAlertController(title: "Phone Number Empty", message: "Please entar your phone number correctly", preferredStyle: .alert)
            let btnOK = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alert.addAction(btnOK)
            self.present(alert, animated: true, completion: nil)
        }
    }
    @IBAction func searchNumberPrimaryActionTrigerred(_ sender: Any) {
        
    }
    @IBAction func prefixReturnTrigger(_ sender: Any) {
        searchOperator()
        pulsaCollectionView.reloadData()
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "pulsaNib", for: indexPath) as? VoucherCollectionViewCell {
            let data = item.opt[indexoperator]
            debugPrint("image path : \(data.logo)")
            switch pulsaDataSegment.selectedSegmentIndex {
            case 0:
                cell.logoImage.image = UIImage(named: data.logo)
                cell.nominalText.text! = "Rp. \(data.listPulsa[indexPath.row].nom)"
                cell.activeText.text! = data.listPulsa[indexPath.row].masaAktif
            case 1:
                cell.logoImage.image = UIImage(named: data.logo)
                cell.nominalText.text = "\(String(data.listData[indexPath.row].kuota)) GB"
                cell.activeText.text = ""
            default:
                cell.nominalText.text = ""
                cell.activeText.text = ""
                cell.logoImage.image = nil
            }
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let data = item.opt[indexoperator]
        switch pulsaDataSegment.selectedSegmentIndex {
        case 0:
            priceText.text = String(data.listPulsa[indexPath.row].harga)
            bottomMenuView.isHidden = false
            totalText.text = String(data.listPulsa[indexPath.row].harga)
            newTotal = data.listPulsa[indexPath.row].harga
            if (Int(saldoText.text!)! < data.listPulsa[indexPath.row].harga) {
                payText.isEnabled = false
                payText.alpha = 0.5
            }
            else {
                payText.isEnabled = true
                payText.alpha = 1.0
            }
        case 1:
            priceText.text = String(data.listData[indexPath.row].harga)
            bottomMenuView.isHidden = false
            totalText.text = String(data.listData[indexPath.row].harga)
            newTotal = data.listData[indexPath.row].harga
            if (Int(saldoText.text!)! < data.listPulsa[indexPath.row].harga) {
                payText.isEnabled = false
                payText.alpha = 0.5
            }
            else {
                payText.isEnabled = true
                payText.alpha = 1.0
            }
        default:
            break
        }
        debugPrint(newTotal)
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        for user in try! db.prepare(users.select(name,balance).filter(username == indexUser)) {
            namaText.text! = user[name]!
            saldoText.text! = String(Int(user[balance]))
        }
        priceText.text = "0"
        totalText.text = "0"
        payText.isEnabled = false
        payText.alpha = 0.5
        let nib = UINib(nibName: "VoucherCollectionViewCell", bundle: nil)
        pulsaCollectionView.register(nib, forCellWithReuseIdentifier: "pulsaNib")
    }
    
    
    func searchOperator() {
        switch prefixTextField.text {
        case "0817"?,"0818"?,"0819"?,"0877"?,"0878"?,"0859"?:
            indexoperator = 0
        case "0811"?,"0812"?,"0813"?,"0821"?,"0822"?,"0823"?,"0851"?,"0852"?,"0853"?:
            indexoperator = 1
        case "0814"?,"0815"?,"0816"?,"0855"?,"0856"?,"0857"?,"0858"?:
            indexoperator = 2
        case "0881"?,"0882"?,"0883"?,"0884"?,"0885"?,"0886"?,"0887"?,"0888"?,"0889"?:
            indexoperator = 3
        case "0895"?,"0896"?,"0897"?,"0898"?,"0899"?:
            indexoperator = 4
        default:
            break
        }
    }



    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
