//
//  PulsaData.swift
//  UKDWPay
//
//  Created by Yoel Tanujaya on 28/5/17.
//  Copyright © 2017 Yoel Tanujaya. All rights reserved.
//

import Foundation

class Pulsa {
    var nom:String = ""
    var masaAktif:String = ""
    var harga:Int = 0
    
    init (nom:String, masaAktif:String, harga:Int) {
        self.nom = nom
        self.masaAktif = masaAktif
        self.harga = harga
    }
}

class PaketData {
    var kuota:Int = 0
    var harga:Int = 0
    
    init (kuota:Int, harga:Int) {
        self.kuota = kuota
        self.harga = harga
    }
}

class Operator {
    var nama:String = ""
    var listPulsa:[Pulsa] = []
    var listData:[PaketData] = []
    var logo:String = ""
    var prefixNum:[String] = []
    var id:Int = 0
    
    init (nama:String, listPulsa:[Pulsa], listData:[PaketData], logo:String, prefixNum:[String], id:Int) {
        self.nama = nama
        self.listPulsa = listPulsa
        self.listData = listData
        self.logo = logo
        self.prefixNum = prefixNum
    }
}

class Items {
    var opt = [Operator]()
    
    init() {
        let xlp = [Pulsa(nom: "25000",masaAktif: "30 Hari",harga: 24500), Pulsa(nom: "50000",masaAktif: "30 Hari",harga: 49500), Pulsa(nom: "100000",masaAktif: "45 Hari",harga: 99000), Pulsa(nom: "150000",masaAktif: "45 Hari",harga: 149000), Pulsa(nom: "250000",masaAktif: "60 Hari",harga: 245000), Pulsa(nom: "500000",masaAktif: "90 Hari",harga: 490000)]
        let xld = [PaketData(kuota:5,harga:25000), PaketData(kuota:7,harga:45000), PaketData(kuota:10,harga:95000), PaketData(kuota:15,harga:120000), PaketData(kuota:20,harga:200000), PaketData(kuota:30,harga:140000)]
        let xl = Operator(nama: "XL Axiata", listPulsa: xlp, listData: xld, logo: "XL.png", prefixNum: ["0817","0818","0819","0877","0878","0859"],id: 1)
        opt.append(xl)
        
        let tselp = [Pulsa(nom: "25000",masaAktif: "30 Hari",harga: 24500), Pulsa(nom: "50000",masaAktif: "30 Hari",harga: 49500), Pulsa(nom: "100000",masaAktif: "45 Hari",harga: 99000), Pulsa(nom: "150000",masaAktif: "45 Hari",harga: 149000), Pulsa(nom: "250000",masaAktif: "60 Hari",harga: 245000), Pulsa(nom: "500000",masaAktif: "90 Hari",harga: 490000)]
        let tseld = [PaketData(kuota:5,harga:25000), PaketData(kuota:7,harga:45000), PaketData(kuota:10,harga:95000), PaketData(kuota:15,harga:120000), PaketData(kuota:20,harga:200000), PaketData(kuota:30,harga:140000)]
        let tsel = Operator(nama: "Telkomsel", listPulsa: tselp, listData: tseld, logo: "TSEL.png", prefixNum: ["0811","0812","0813","0821","0822","0823","0851","0852","0853"],id: 2)
        opt.append(tsel)
        
        let isatp = [Pulsa(nom: "25000",masaAktif: "30 Hari",harga: 24500), Pulsa(nom: "50000",masaAktif: "30 Hari",harga: 49500), Pulsa(nom: "100000",masaAktif: "45 Hari",harga: 99000), Pulsa(nom: "150000",masaAktif: "45 Hari",harga: 149000), Pulsa(nom: "250000",masaAktif: "60 Hari",harga: 245000), Pulsa(nom: "500000",masaAktif: "90 Hari",harga: 490000)]
        let isatd = [PaketData(kuota:5,harga:25000), PaketData(kuota:7,harga:45000), PaketData(kuota:10,harga:95000), PaketData(kuota:15,harga:120000), PaketData(kuota:20,harga:200000), PaketData(kuota:30,harga:140000)]
        let isat = Operator(nama: "Indosat Ooredoo", listPulsa: isatp, listData: isatd, logo: "ISAT.png", prefixNum: ["0814","0815","0816","0855","0856","0857","0858"],id: 3)
        opt.append(isat)
        
        let sfp = [Pulsa(nom: "25000",masaAktif: "30 Hari",harga: 24500), Pulsa(nom: "50000",masaAktif: "30 Hari",harga: 49500), Pulsa(nom: "100000",masaAktif: "45 Hari",harga: 99000), Pulsa(nom: "150000",masaAktif: "45 Hari",harga: 149000), Pulsa(nom: "250000",masaAktif: "60 Hari",harga: 245000), Pulsa(nom: "500000",masaAktif: "90 Hari",harga: 490000)]
        let sfd = [PaketData(kuota:5,harga:25000), PaketData(kuota:7,harga:45000), PaketData(kuota:10,harga:95000), PaketData(kuota:15,harga:120000), PaketData(kuota:20,harga:200000), PaketData(kuota:30,harga:140000)]
        let sf = Operator(nama: "SmartFren", listPulsa: sfp, listData: sfd, logo: "SF.png", prefixNum: ["088"],id: 4)
        opt.append(sf)
        
        let trip = [Pulsa(nom: "25000",masaAktif: "30 Hari",harga: 24500), Pulsa(nom: "50000",masaAktif: "30 Hari",harga: 49500), Pulsa(nom: "100000",masaAktif: "45 Hari",harga: 99000), Pulsa(nom: "150000",masaAktif: "45 Hari",harga: 149000), Pulsa(nom: "250000",masaAktif: "60 Hari",harga: 245000), Pulsa(nom: "500000",masaAktif: "90 Hari",harga: 490000)]
        let trid = [PaketData(kuota:5,harga:25000), PaketData(kuota:7,harga:45000), PaketData(kuota:10,harga:95000), PaketData(kuota:15,harga:120000), PaketData(kuota:20,harga:200000), PaketData(kuota:30,harga:140000)]
        let tri = Operator(nama: "Three", listPulsa: trip, listData: trid, logo: "TRI.png", prefixNum: ["0897","0898","0899","0896"],id: 5)
        opt.append(tri)
    }
}
