//
//  GasView.swift
//  Hack_Velas
//
//  Created by Dosi Dimitrov on 8.09.22.
//

import SwiftUI
import CoreML

struct GasView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject  var walletConnect: WalletConnect
    @Environment(\.openURL) var openURL
    
    @State var choos : BlockName = .velas
    @State var UsedGas : Double = 0
    @State var numberContracts : Int = 0
    @State var stringKG : String = ""
    @State var newNamber : String = ""
    
    @State var contactadress : String = ""
    @State var adress        : String = ""
    @State var alertOn : Bool = false
    @State var alertBlockOn : Bool = false
    @State var progressView : Bool = false
    @State var buttonCO2    : Bool = false
    @State var walletIdentity : String = ""
    @State var  tokenName : String = ""
    @State var  tokenSymbol: String = ""
    @State var co2 : Double = 0
    
    @State private var qrcodeString = ""
    
    var body: some View {
        ZStack (alignment: .bottom){
            Color("ColorBG").opacity(0.7).ignoresSafeArea()
            VStack(alignment: .center, spacing: 0){
                HStack {
                    backInfo()
                        .padding(.leading, 20)
                        .padding(.top, 20)
                        .padding(.bottom, 20)
                    
                    
                    Spacer()
                }
                VStack(alignment: .center, spacing: 10){
                    ZStack {
                        TextField("Contract Address", text: $contactadress)
                            .textFieldStyle(RoundedBorderTextFieldStyle())

                        Button("☒") {
                            contactadress = ""
                        }
                        .font(.system(size: 28))
                        .background(RoundedRectangle(cornerRadius: 5).fill(Color.white))
                        .offset(x: 150)
                    }
                    ZStack {
                        TextField("Wallet Address", text: $adress)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                     
                        Button("☒") {
                            adress = ""
                        }
                        .font(.system(size: 28))
                        .background(RoundedRectangle(cornerRadius: 5).fill(Color.white))
                        .offset(x: 150)
                    }
                }
                .padding()
                .frame(width: widthButton * 2)
                .modifier(ArdaButton())
                
                Picker("This Title Is Localized", selection: $choos) {
                    ForEach(BlockName.allCases) { value in
                        Text(value.rawValue)
                            .tag(value)

                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                .onChange(of: choos) { _ in
                    self.buttonCO2 = false
                }
                
                Spacer()
              
                

                        VStack( spacing: 0) {
                            VStack{
                                HStack{
                                    Text("Gas: ")
                                    Spacer()
                                    Text("[  \(UsedGas  , specifier: "%.0f") ]")
                                        .onChange(of: UsedGas) { kg in
                                            if kg > 0 {

                                              //  self.stringKG = String(Int(UsedGas * 0.00024) )
                                                self.buttonCO2 = true
                                                self.alertOn = true
                                                self.walletIdentity = walletConnect.walletAccount
                                                walletIdentity.remove(at: walletIdentity.startIndex)
                                                walletIdentity.remove(at: walletIdentity.startIndex)
                                                if choos.rawValue == "Ethereum" {
                                                    change()
                                                }else{
                                                    change_new()
                                                }
                                               
                                            }
                                        }
                                }.padding(.horizontal , 20)

                                HStack{
                                    Text("Transactions: ")
                                    Spacer()
                                    Text("\(numberContracts)")
                                }
                                .padding(.horizontal , 20)
                                HStack{
                                    Text("Name: ")
                                    Spacer()
                                    Text("\(tokenName)")
                                } .padding(.horizontal , 20)
                             
                                HStack{
                                    Text("Symbol:")
                                    Spacer()
                                    Text("\(tokenSymbol)")
                                } .padding(.horizontal , 20)
                              
                            }
                            .foregroundColor(.white)
                           
                            .padding(.vertical, 5)
                            .frame(width: 350)
                            .modifier(miniButton())
                            .opacity(self.buttonCO2 ? 1 : 0)
                          //  Text(stringKG)
                            ZStack {
                                Image("CO2")
                                    .resizable()
                                    .frame(width: widthButton , height: widthButton )
                                
                                Text("\(UsedGas)")
                                    .opacity(0)
                                    .onChange(of: UsedGas) { value in
                                        if choos.rawValue == "Ethereum" {
                                            co2 = choos.doubleGas(value: Int(UsedGas))
                                            stringKG = String(co2)
                                        }else{
                                            
                                           
                                            co2 = choos.doubleGas(value: numberContracts)
                                            stringKG = GasView.valueFormatter.string(from: co2 as NSNumber)!

                                            print("stringKG = \(stringKG)")
                                        }
                                        
                                    }
                                
                                
                                if choos.rawValue == "Ethereum" {
                                    Text("\(co2, specifier: "%.0f") kg")
                                        .foregroundColor(.white)
                                        .opacity(self.buttonCO2 ? 1 : 0)
                                }else{
                                    VStack{
                                        Text("\(co2, specifier: "%.8f") KG")
                                           
                                     
                                    }
                                  
                                    
                                        .foregroundColor(.white)
                                        .opacity(self.buttonCO2 ? 1 : 0)
                                }

                                Circle()
                                   
                                    .stroke(self.buttonCO2 ?  Color.white : Color.gray, lineWidth: 7)
                                    .frame(width: 220 , height: 220 , alignment: .center)
                                    .opacity(self.buttonCO2 ? 1 : 0.5)

                            }.padding()

                        }
                    

                if progressView{ ProgressView().scaleEffect(3).offset(y: -300)}
                
             //   Spacer()
           
                if !self.buttonCO2 {
                    Button("Calculate") {
                        
                      
                        self.progressView = true
                        let aa = choos.contract_Address(addres: contactadress)
                        let bb = choos.address_(addres: adress)
                        if  let cc = choos.HTTP_String(contractAddress: aa, address: bb) {
                            connectNow(url: cc)
                        }else{
                            self.alertOn = true
                        }
                      
                    }
                    .disabled(self.buttonCO2)
                    .opacity(self.buttonCO2 ? 0 : 1)
                    .padding(.vertical, 25)
                    .frame(width: widthButton * 2)
                    .modifier(CircleButton())
                    .padding(.bottom, 25)
                }else{
                    
                    buttonNFT(kg: newNamber, walletId: walletIdentity)
                }

                
            }
        }
        .onAppear(){
            connectToMetaMask()
        }
        .alert(isPresented: $alertBlockOn) {
            Alert(
                title: Text("Confirm"),
                message: Text("MetaMask"),
                dismissButton: .default(Text("Close")){
                    self.alertBlockOn = false
                }
            )
        }
        
        
    }
    func connectToMetaMask() {
        let connectionUrl = walletConnect.connect()

        let deepLinkUrl = "wc://wc?uri=\(connectionUrl)"
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            if let url = URL(string: deepLinkUrl) {
              
                openURL(url) { accepted in
 
                }
            }
        }
    }
    
    func change() {
                newNamber = ""
        if self.stringKG == "" {
            
        }else{
            let arrayTo = Array(self.stringKG)
            newNamber.append(contentsOf: "\(self.stringKG.count)")
            for i in arrayTo{
                newNamber.append(contentsOf: "3\(i)")
            }
            let ardaArray = Array( newNamber)
            for _ in 1 ... ( 65 - ardaArray.count) {
                newNamber.append(contentsOf: "\(0)")
            }
        }

        print(newNamber)
    }
    
    func change_new() {
                newNamber = ""
        if self.stringKG == "" {
            
        }else{
            var qqq = self.stringKG
            qqq.remove(at: qqq.startIndex)
            qqq.remove(at: qqq.startIndex)
            let arrayTo = Array( qqq)
            newNamber.append(contentsOf: "\(self.stringKG.count)")
            newNamber.append(contentsOf: "302e")
            for i  in arrayTo{
             
                    newNamber.append(contentsOf: "3\(i)")
         
               
            }
            let ardaArray = Array( newNamber)
            for _ in 1 ... ( 65 - ardaArray.count) {
                newNamber.append(contentsOf: "\(0)")
            }
        }

        print("change_new = \(newNamber)")
    }
    
    private static var valueFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 10
        return formatter
    }()
}

struct GasView_Previews: PreviewProvider {
    static var previews: some View {
        GasView()
    }
}


extension GasView {
    func backInfo() -> some View {
        Button(" ⏎ ") {
            walletConnect.disconnect()
            presentationMode.wrappedValue.dismiss()
           
        }
        .padding(.vertical, 5)
        .frame(width: 50)
        .modifier(ArdaButton())
    }
    
    func buttonNFT(kg: String, walletId : String) -> some View {
        Button("Generate NFT") {

                
            walletConnect.eth_sendTransaction(cont: choos.cont_To(), dataNew: "0xd3fc9864000000000000000000000000\(walletId)00000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000060000000000000000000000000000000000000000000000000000000000000000\(kg)", valueNew: "0x0", gas: "0x7A120")

            self.alertBlockOn = true
            self.buttonCO2 = false
           
        }
        .foregroundColor(.white)
        .padding(.vertical, 25)
        .frame(width: widthButton * 2)
        .modifier(CircleButton())
        .padding(.bottom, 25)

    }
}

extension GasView{
    func connectNow(url : URL?){
        
        let config = MLModelConfiguration()
        
        self.alertOn  = false
         guard let url =  url else{ return        }

         var request = URLRequest(url: url)
         request.httpMethod = "POST"
        
      
         request.setValue("application/json", forHTTPHeaderField: "Content-Type")
         URLSession.shared.dataTask(with: request){
             (data, response, error) in
      
             guard let data = data else{
                 return
             }
             print(data)
             do {
                 if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any], let result = json["result"] {
                     // Parse JSON
                     print(result)
                     let posts = result as? [[String: Any]] ?? []
                     print(posts.count)
                     if posts.count == 0 {
                         self.alertOn = true
                         self.contactadress = ""
                         self.adress = ""
                     }
                 //    print(posts[0]["gasUsed"])
                 //    print(posts[1]["gasUsed"])
                     var gasUsed : Double = 0
                     posts.forEach {  age in
                         print("is \(age["gasUsed"]!) ")
                         gasUsed += (age["gasUsed"]! as AnyObject).doubleValue!
                         self.tokenName = age["tokenName"]! as! String
                         self.tokenSymbol = age["tokenSymbol"]! as! String
                     }
                 
                     self.UsedGas =  gasUsed
                     self.numberContracts = posts.count
                     self.progressView = false
                     print(UsedGas)
                     print("numberContracts = \(numberContracts)")
                 }
             } catch let parseError {
                 print("parsing error: \(parseError)")
                 let responseString = String(data: data, encoding: .utf8)
                     print("raw response: \(responseString)")
                     self.alertOn  = true
                 }
             
          

         //   let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
         //   print("-----1> responseJSON: \(responseJSON)")
         //   if let responseJSON = responseJSON as? [String : Any] {
         //       print("-----2> responseJSON: \(responseJSON)")
         //  }
      
         }.resume()
     
         }
}

enum BlockName :String, CaseIterable, Identifiable, Encodable, Decodable{
    
    case polygon = "Polygon"
    case ethereum = "Ethereum"
    case binance = "Binance"
    case velas   = "Velas"
    
    var id: String { self.rawValue }
    
  //  Za Plashtane Rinkeby: 0x6B10022E7820b3b8AE984C374a69b4A33f2975DB
    
    func plashtane() -> String {
        switch self {
            
        case .polygon:  return "0x476eE89E22908B28F14400123556B1B8FfdAD439"
        case .ethereum: return "0x6B10022E7820b3b8AE984C374a69b4A33f2975DB"
        case .binance:  return "0x7BdeF9B0232B0ED6bf9423890547e4B03bCDd141"
        case .velas:    return "0x8dC313f09Ba226B418F6bB646CC8096Cb7ff8CCB"
        }
    }
   
    func cont_To () -> String  {
        switch self {
            
        case .polygon: return "0x3BBf61c05231bEDfD603a77aA560B78E19E662d9"
            
        case .ethereum: return "0xc170136D1627bd532109aC006F105346AbA22437"
            
        case .binance: return "0x0390A683238626bb0Cfe324C74ECde821E62C9FE"
            
        case .velas: return "0x2826C42354FE5B816c7E21AD9e3B395Ced512C0C"
            
        }
    }
    
    func contract_Address(addres: String) -> String {
        switch self {
        case .polygon:
            if addres.isEmpty  {
                return "0x2791bca1f2de4661ed88a30c99a7a9449aa84174"
            }else{
                return addres
            }
          
        case .ethereum:
            if addres.isEmpty {
                return "0x06012c8cf97bead5deae237070f9587f8e7a266d"
            }else{
                return addres
            }
        case .binance:
            if addres.isEmpty {
                return "0x5e74094cd416f55179dbd0e45b1a8ed030e396a1"
            }else{
                return addres
            }
        case .velas:
            if addres.isEmpty {
                return "0x692E9d41Ef4eB7Ad559f4F0ef48EFc3092c7512C"
            }else{
                return addres
            }
        }
    }
    
    func address_(addres: String) -> String {
        switch self {
        case .polygon:
            if addres.isEmpty {
                return "0x5bbe401d11a1db29a21221271d12efe6b9e68d12"
            }else{
                return addres
            }
           
        case .ethereum:
            if addres.isEmpty {
                return "0x6975be450864c02b4613023c2152ee0743572325"
            }else{
                return addres
            }
        case .binance:
            if addres.isEmpty {
                return "0xcd4ee0a77e09afa8d5a6518f7cf8539bef684e6c"
            }else{
                return addres
            }
        case .velas:
            if addres.isEmpty {
                return "0x6Dfd8f88A48B6cbC45a0C9eE6b907595A539C5c3"
            }else{
                return addres
            }
        }
    }
    

    
    func doubleGas(value : Int) -> Double{
        switch self {
            
        case .polygon: return   (Double(value) * 0.001 * 0.39)
        case .ethereum:  return (Double(value) * 0.00024)
        case .binance: return   (Double(value) * 0.0001 * 0.37)
        case .velas: return     (Double(value) * 0.00001 * 0.38)
        }
        
    }
// https://api.etherscan.io/api?module=account&action=addresstokennftbalance&address=0x6b52e83941eb10f9c613c395a834457559a80114&page=1&offset=100&apikey=YourApiKeyToken
    
    func HTTP_String( contractAddress: String, address: String )  -> URL? {
        
        switch self {
        case .polygon:
            guard let url =  URL(string:"https://api.polygonscan.com/api?module=account&action=tokentx&contractaddress=\(contractAddress)&address=\(address)&page=1&offset=100&startblock=0&endblock=99999999&sort=asc&apikey=3EPPM9AX5SW9JXPXRC5X11KRQTJTH8MQIH") else{ return nil }
                return url
            
        case .ethereum:
            guard let url = URL(string: "https://api.etherscan.io/api?module=account&action=tokennfttx&contractaddress=\(contractAddress)&address=\(address)&page=1&offset=100&startblock=0&endblock=99999999&sort=asc&apikey=2VJIK89PPWWYH129PG45A7BU7KXN9M8E6Q") else { return nil }
                 return url
        case .binance:
            guard let url = URL(string: "https://api.bscscan.com/api?module=account&action=tokennfttx&contractaddress=\(contractAddress)&address=\(address)&page=1&offset=100&startblock=0&endblock=999999999&sort=asc&apikey=BMATTE42U2YDWFXMDI8XFMCH1XN2R53VI1") else{ return nil}
            return url
        case .velas:
            guard let url = URL(string: "https://evmexplorer.velas.com/api?module=account&action=tokentx&address=\(address)&contractaddress=\(contractAddress)&sort=asc&startblock=1&endblock=49810479&page=1&offset=10") else{ return nil}
            return url
        }
      //  return nil
    }
}
