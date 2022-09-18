//
//  Model.swift
//  Hack_Velas
//
//  Created by Dosi Dimitrov on 3.09.22.
//
import SwiftUI

struct Mara : Identifiable, Codable {
    var id   : String
    var name : String
}

struct TransModel : Identifiable, Codable {
    
    var id : String 
    
    var peerFromName     : String
    var peerFromLastName : String
    var peerFromEmail    : String
    var peerFromMetaMask     : String
    
    var peerToName     : String
    var peerToLastName : String
    var peerToEmail    : String
    var peerToMetaMask     : String
    
    var date : String
    var suma : String
    var gas  : String
    
}

struct PersonInfo : Encodable, Decodable {
    
    var name       : String
    var lastName   : String
    var email      : String
    var metaMaskID : String
    var blockName  : BlockName
    
}


enum ButtonView  : Hashable,  Identifiable{
    
    case buttonInfo
    case buttonSend
    case buttonList
    case gasCalculator
    case rollex
    
    var id: Self { self }
}
