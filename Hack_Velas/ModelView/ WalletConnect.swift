//
//   WalletConnect.swift
//  Hack_Velas
//
//  Created by Dosi Dimitrov on 3.09.22.
//

import Foundation
import WalletConnectSwift
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseFirestoreSwiftTarget
import Network
import simd

protocol WalletConnectDelegate {
    func failedToConnect()
    func didConnect()
    func didDisconnect()
}

class WalletConnect : ObservableObject{
    
 //   static let shared = WalletConnect()
    @Published      var walletAccount: String  = ""
    @Published      var reconect     : Bool    = false
    @Published      var colorOn      : Bool    = false
    @Published      var hash        : String  = ""
    @Published      var tottal : Double = 0
    @Published      var numberice   : Double = 0
    @Published      var numberdrink : Double = 0
    @Published      var numbercoffe : Double = 0
    @Published      var textQR      : String = ""
    @Published      var  personInfo    : PersonInfo = PersonInfo(name: "", lastName: "", email: "", metaMaskID: "", blockName: .ethereum)
    @Published      var  recipientInfo : PersonInfo = PersonInfo(name: "", lastName: "", email: "", metaMaskID: "", blockName: .ethereum)
    @Published      var  co2To   : Double = 0
    @Published      var  co2From : Double = 0
    @Published      var sumaTrans : String = ""
    @Published      var  gasTrans : String = ""
    @Published      var  isOnbutonSent : Bool = true {
        didSet {
            if isOnbutonSent {
                transModel.removeAll()
                loadFrom()
              
            }else{
                transModel.removeAll()
                loadTo()
               
            }
        }
    }
    @Published      var  isOnbuttonReceived : Bool = false
    
    @Published var transModel = [TransModel]()
    @Published var mara = [Mara]()
    let db = Firestore.firestore()
    
    var dateString : String {
        let today = Date.now
        let formatter1 = DateFormatter()
        formatter1.dateStyle = .short
        print(formatter1.string(from: today))
        return formatter1.string(from: today)
    }
 
    var client: Client!

    var session: Session!{
        didSet{
            walletAccount = session.walletInfo!.accounts[0]
        }
    }
 
 //   var delegate: WalletConnectDelegate

    let sessionKey = "dakata_7b"

    init(){
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [self] in
            loadFrom()
        }
       // loadData( isSent: isOnbutonSent )
       // loadFrom()
    }
    
    func addGas() -> Double{
        print("addgas")
      
        var value : Double = 0
        transModel.forEach{ item in
            print(value)
            value += Double(item.gas)! * 0.00024
        }
      
        return value
        
    }
    
    func addData() {
        db.collection("Velter").addDocument(data:["peerFromName" : personInfo.name,
                                                  "peerFromLastName" : personInfo.lastName,
                                                  "peerFromEmail" : personInfo.email,
                                                  "peerFromMetaMask" : personInfo.metaMaskID,
                                                  "peerToName" : recipientInfo.name,
                                                  "peerToLastName" : recipientInfo.lastName,
                                                  "peerToEmail" : recipientInfo.email,
                                                  "peerToMetaMask" : recipientInfo.metaMaskID,
                                                  "date" : dateString,
                                                  "suma" : sumaTrans ,
                                                  "gas" : gasTrans ] ) { [self] error in
            if error == nil { loadFrom() }
            
        }
    }

    
    func loadTo() {
        
     //   self.co2To = 0
        db.collection("Velter").whereField("peerToMetaMask", isEqualTo: personInfo.metaMaskID).getDocuments{ snapshot , err in
            if err == nil {
                if let snapshot = snapshot {
                    DispatchQueue.main.async {
                        self.transModel = snapshot.documents.map{ d in
                            return TransModel(id: d.documentID,
                                              peerFromName: (d["peerFromName"] as! String) ,
                                              peerFromLastName: (d["peerFromLastName"] as! String) ,
                                              peerFromEmail: (d["peerFromEmail"] as! String) ,
                                              peerFromMetaMask: (d["peerFromMetaMask"] as! String) ,
                                              peerToName: (d["peerToName"] as! String) ,
                                              peerToLastName: (d["peerToLastName"] as! String) ,
                                              peerToEmail: (d["peerToEmail"] as! String) ,
                                              peerToMetaMask: (d["peerToMetaMask"] as! String) ,
                                              date: (d["date"] as!  String) ,
                                              suma: (d["suma"] as! String) ,
                                              gas: (d["gas"] as! String) )
                                          //    self.co2To += Double((d["gas"] as! String))! * 0.00024
                        }
                    }
                }
            }
        }
    
        DispatchQueue.main.asyncAfter(deadline: .now() + 2){ [self] in
            self.co2To = addGas()
        }
      
        
    }
    
    func loadFrom() {
        
       // self.co2From = 0
        db.collection("Velter").whereField("peerFromMetaMask", isEqualTo: personInfo.metaMaskID).getDocuments{ snapshot , err in
            if err == nil {
                if let snapshot = snapshot {
                    DispatchQueue.main.async {
                        self.transModel = snapshot.documents.map{ d in
                            return TransModel(id: d.documentID,
                                              peerFromName: (d["peerFromName"] as! String) ,
                                              peerFromLastName: (d["peerFromLastName"] as! String) ,
                                              peerFromEmail: (d["peerFromEmail"] as! String) ,
                                              peerFromMetaMask: (d["peerFromMetaMask"] as! String) ,
                                              peerToName: (d["peerToName"] as! String) ,
                                              peerToLastName: (d["peerToLastName"] as! String) ,
                                              peerToEmail: (d["peerToEmail"] as! String) ,
                                              peerToMetaMask: (d["peerToMetaMask"] as! String) ,
                                              date: (d["date"] as!  String) ,
                                              suma: (d["suma"] as! String) ,
                                              gas: (d["gas"] as! String) )
                                         //     self.co2From += Double(d["gas"] as! Substring)! * 0.00024
                        }
                    }
                }
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2){ [self] in
            self.co2From = addGas()
        }
       
        
    }
    
    
    func saveRecipient(item : String) {
        print("item = \(item)")
        let  separator = item.components(separatedBy: "/")
        recipientInfo.metaMaskID = separator[0]
        recipientInfo.name = separator[1]
        recipientInfo.lastName = separator[2]
        recipientInfo.email = separator[3]
        recipientInfo.blockName =  blockSurch(name: separator[4])
        print("sep = \(separator[4])")
        print(recipientInfo.blockName)
    }
    
//case polygon = "Polygon"
//case ethereum = "Ethereum"
//case binance = "Binance"
//case velas
    
    func blockSurch(name : String) -> BlockName {
        if name == "Polygon" {
            return .polygon
        }
        if name == "Ethereum" {
            return .ethereum
        }
        if name == "Binance" {
            return .binance
        }
        return .velas
    }

    func isNotEmptyName() -> Bool {
        
        if !personInfo.name.isEmpty && !personInfo.lastName.isEmpty && !personInfo.email.isEmpty && !personInfo.metaMaskID.isEmpty {
            return true
        }else{
            
            return false
        }
        
       
    }
    
    func disconnect() {
        
        guard let session = session else { return }
        try? client.disconnect(from: session)
        self.colorOn = false
        
    }
    
    private  func close() {
        for session in client.openSessions() {
            try? client.disconnect(from: session)
        }
        self.colorOn = false
    }
    
    private func nonceRequest() -> Request {
        return .eth_getTransactionCount(url: session.url, account: session.walletInfo!.accounts[0])
       
    }

    private func nonce(from response: Response) -> String? {
          return try? response.result(as: String.self)
    }
    
    
    
    func eth_sendTransaction(cont: String ,dataNew: String, valueNew: String, gas : String) {
      //  func eth_sendTransaction(dataNew: String) {

        try? client.send(nonceRequest()) { [weak self] response in
            guard let self = self, let nonce = self.nonce(from: response) else { return }
            print("N = \(nonce)")
            let transaction = Stub.transaction(to: cont, from: self.walletAccount, nonce: nonce, data: dataNew, value: valueNew, gas: gas)
          //  let transaction = Stub.transaction(from: self.walletAccount, nonce: nonce, data: dataNew, value: "0x0")

           
            try? self.client.eth_sendTransaction(url: response.url, transaction: transaction) { [weak self] response in

                
                    if let error = response.error {
              
                        self?.hash = error.localizedDescription
                    }else{
                               do {
                                   let result     = try response.result(as: String.self)
                                       self?.hash = result
                              } catch {
                                       self?.hash = "Error"
                              }
              
                    }
                
            }
        }
        self.reconect = true
    }
    

    func connect() -> String {
        // gnosis wc bridge: https://safe-walletconnect.gnosis.io/
        // test bridge with latest protocol version: https://bridge.walletconnect.org
        let wcUrl =  WCURL(topic: UUID().uuidString,
                           bridgeURL: URL(string: "https://safe-walletconnect.gnosis.io/")!,
                           key: try! randomKey())
    
        
        let clientMeta = Session.ClientMeta(name: "ExampleDApp",
                                            description: "WalletConnectSwift",
                                            icons: [],
                                            url: URL(string: "https://safe.gnosis.io")!)
    
        
        let dAppInfo = Session.DAppInfo(peerId: UUID().uuidString, peerMeta: clientMeta)
        client = Client(delegate: self, dAppInfo: dAppInfo)
        
       

        print("WalletConnect URL: \(wcUrl.absoluteString)")
        print("....................................")

        try! client.connect(to: wcUrl)
     
        return wcUrl.absoluteString
    }

    func reconnectIfNeeded() {
        if let oldSessionObject = UserDefaults.standard.object(forKey: sessionKey) as? Data,
            let session = try? JSONDecoder().decode(Session.self, from: oldSessionObject) {
            client = Client(delegate: self, dAppInfo: session.dAppInfo)
            try? client.reconnect(to: session)
        }
    }

    // https://developer.apple.com/documentation/security/1399291-secrandomcopybytes
    private func randomKey() throws -> String {
        var bytes = [Int8](repeating: 0, count: 32)
        let status = SecRandomCopyBytes(kSecRandomDefault, bytes.count, &bytes)
        if status == errSecSuccess {
            return Data(bytes: bytes, count: 32).toHexString()
        } else {
            // we don't care in the example app
            enum TestError: Error {
                case unknown
            }
            throw TestError.unknown
        }
    }
    
    func onMainThread(_ closure: @escaping () -> Void) {
        if Thread.isMainThread {
            closure()
        } else {
            DispatchQueue.main.async {
                closure()
            }
        }
    }
    
     enum Stub {
        /// https://docs.walletconnect.org/json-rpc-api-methods/ethereum#example-parameters
// let aaa = "0x131a0680\(bbb)"
        /// https://docs.walletconnect.org/json-rpc-api-methods/ethereum#example-parameters-1
         static func transaction(to cont : String, from address: String, nonce: String, data : String, value: String, gas : String) -> Client.Transaction {
            return Client.Transaction(from: address,
                                      to: cont,
                                      data: data,
                                      gas: gas, // 30400  "0x7A120"
                                      gasPrice: "0x77359400", // 100000000000002323
                                      value: value , // 2441406250 16345785D8A0000
                                      nonce: nonce,
                                      type: nil,
                                      accessList: nil,
                                      chainId: nil,
                                      maxPriorityFeePerGas: nil,
                                      maxFeePerGas: nil)
        }

        /// https://docs.walletconnect.org/json-rpc-api-methods/ethereum#example-5
        static let data = "0x131a0680"
    }
}

//contract new Now: 0xB90dEFBC9B90DDe20C993879FD5318733E465f32
//    data: "0xd46e8dd67c5d32be8d46e8dd67c5d32be8058bb8eb970870f072445675058bb8eb970870f07244567",
//   value: "0x9184e72a" , // 2441406250


extension WalletConnect: WalletConnectDelegate {
    func failedToConnect() {
    
    }
    
    func didConnect() {

    }
    
    func didDisconnect() {
                        
    }
    
    
}

extension WalletConnect: ClientDelegate {
    func client(_ client: Client, didFailToConnect url: WCURL) {
                 failedToConnect()
    }

    func client(_ client: Client, didConnect url: WCURL) {
        // do nothing
    }

    func client(_ client: Client, didConnect session: Session) {
        self.session = session
        let sessionData = try! JSONEncoder().encode(session)
        UserDefaults.standard.set(sessionData, forKey: sessionKey)
                  didConnect()
    }

    func client(_ client: Client, didDisconnect session: Session) {
        UserDefaults.standard.removeObject(forKey: sessionKey)
                  didDisconnect()
    }

    func client(_ client: Client, didUpdate session: Session) {
        // do nothing
    }
}

extension Request {
    static func eth_getTransactionCount(url: WCURL, account: String) -> Request {
        return try! Request(url: url, method: "eth_getTransactionCount", params: [account, "latest"])
    }

    static func eth_gasPrice(url: WCURL) -> Request {
        return Request(url: url, method: "eth_gasPrice")
    }
}
