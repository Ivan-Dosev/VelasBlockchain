//
//  ListView.swift
//  Hack_Velas
//
//  Created by Dosi Dimitrov on 3.09.22.
//

import SwiftUI

struct ListView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject  var walletConnect: WalletConnect
    @State var color : Bool = false
    @State var sumaCO2 : Double = 0
    @State var choos : BlockName = .ethereum
    @Environment(\.openURL) var openURL
    @State var walletIdentity : String = ""
    @State var alertBlockOn : Bool = false
    @State var newNamber : String = ""
    @State var stringKG : String = ""
    
    
    var body: some View {
        ZStack (alignment: .bottom){
            Color("ColorBG").opacity(0.7).ignoresSafeArea()
            VStack(spacing: 25){
                HStack {
                    backInfo()
                        .padding(.leading, 20)
                        .padding(.top, 10)


                    Spacer()
                }
                HStack( spacing: 20) {
                    
                    butonSent()
                        .scaleEffect(walletConnect.isOnbutonSent ? 0.9 : 1)
                        .disabled(walletConnect.isOnbutonSent)
                    buttonReceived()
                        .scaleEffect(walletConnect.isOnbuttonReceived ? 0.9 : 1)
                        .disabled(walletConnect.isOnbuttonReceived)
                     
                  
                   
                }
                VStack(spacing: 0) {
                    ScrollView(.vertical, showsIndicators: false){
                        ForEach(walletConnect.transModel) { item in
                            
                            
                            VStack( spacing: 5) {
                                HStack {
                                    Text(walletConnect.isOnbutonSent ?  item.peerToName : item.peerFromName)
                                        .foregroundColor(.black)
                                    Spacer()
                                    Text(item.date)
                                        .foregroundColor(.black)
                                        .fontWeight(.bold)
                                }
                                .font(.caption2)
                                HStack {
                                    Text(walletConnect.isOnbutonSent ? item.peerToLastName : item.peerFromLastName)
                                        .foregroundColor(.black)
                                    Spacer()
                                    Text("gas = \(item.gas) wai")
                                        .foregroundColor(.black)
                                        .fontWeight(.bold)
                                }
                                .font(.caption2)
                                HStack {
                                    Text(walletConnect.isOnbutonSent ? item.peerToEmail : item.peerFromEmail)
                                        .foregroundColor(.black)
                                    Spacer()
                                    Text("sum = \(item.suma) eth")
                                        .foregroundColor(.black)
                                        .fontWeight(.bold)
                                }
                                .font(.caption2)
                                
                                HStack {

                                    Spacer()
                                    Text("CO2  = " + String(format: "%.2f", Double(item.gas)! * 0.00024) + " kg")
                                        .foregroundColor(.black)
                                        .fontWeight(.bold)
                                        
                                }
                                .font(.caption2)
                                
                            }
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 10)
                              //  .fill(walletConnect.isOnbutonSent ? .regularMaterial : .ultraThinMaterial)
                                .fill( .regularMaterial )
                                .overlay(RoundedRectangle(cornerRadius: 10)
                                    .strokeBorder(.gray, lineWidth: 2)))

                            
                        }
                    }
                }
                    .padding()
                    .frame(width: widthButton * 2)
                    .modifier(ArdaButton())
                
                VStack(){
                    Text(walletConnect.isOnbutonSent ? "CO2 = " + String(format: "%.0f", Double(walletConnect.co2From)) + "kg Buy NFT  to be Neutral" : "CO2 = " + String(format: "%.0f", Double(walletConnect.co2To)) + " kg ")
                        .font(.system(size: 14))
                        .foregroundColor(.white)
                        .onTapGesture(){
                            stringKG = String(Int(walletConnect.co2From))
                            if walletConnect.isOnbutonSent {
                                connectToMetaMask()
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
                                    self.alertBlockOn = true
                                }
                            }
                            

                        }
                    
                }
                    .padding()
                    .frame(width: widthButton * 2)
                    .modifier(ArdaButton())
                
                Spacer()
            }.padding(.bottom, 15)
        }
        .onAppear(){
            
            if walletConnect.personInfo.metaMaskID == "Polygon" {
                choos = .polygon
            }
            if walletConnect.personInfo.metaMaskID == "Ethereum" {
                choos = .ethereum
            }
            if walletConnect.personInfo.metaMaskID == "Binance" {
                choos = .binance
            }
            if walletConnect.personInfo.metaMaskID == "Velas" {
                choos = .velas
            }
        
            print(choos.rawValue)
        }
        .alert(isPresented: $alertBlockOn) {
          
                Alert(
                    title: Text("Confirm"),
                    message: Text("MetaMask"),
                    primaryButton: .destructive(Text("Send NFT")) {
                        self.walletIdentity = walletConnect.walletAccount
                        walletIdentity.remove(at: walletIdentity.startIndex)
                        walletIdentity.remove(at: walletIdentity.startIndex)
                        print("NFT ........................")
                        change()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            buttonNFT(kg: newNamber, walletId: walletIdentity)
                            
                            
                        }
                    },
                    secondaryButton: .cancel()

                )
        }
    }
}

struct TransView_Previews: PreviewProvider {
    static var previews: some View {
        ListView()
    }
}

extension ListView {
    
    func backInfo() -> some View {
        Button(" ⏎ ") {
            walletConnect.disconnect()
            presentationMode.wrappedValue.dismiss()
           
        }
        .padding(.vertical, 5)
        .frame(width: 50)
        .modifier(ArdaButton())
    }
    
    func buttonReceived() -> some View {
        Button("received") {
            
            walletConnect.isOnbutonSent.toggle()
            walletConnect.isOnbuttonReceived.toggle()
           
        }
        .foregroundColor(walletConnect.isOnbutonSent ? .yellow : .white)
        .font(.system(size: 18))
        .padding(.vertical, 10)
        .frame(width: 100)
        .modifier( miniButton())
    }
    
    func butonSent() -> some View {
        Button("sent") {
            
            walletConnect.isOnbutonSent.toggle()
            walletConnect.isOnbuttonReceived.toggle()
           
        }
        .foregroundColor(walletConnect.isOnbuttonReceived ? .yellow : .white)
        .font(.system(size: 18))
        .padding(.vertical, 10)
        .frame(width: 100)
        .modifier( miniButton())
    }
    func buttonNFT(kg: String, walletId : String) -> some View {
        Button("Generate NFT") {
print("choos = \(choos.cont_To())")
                
            walletConnect.eth_sendTransaction(cont: choos.cont_To(), dataNew: "0xd3fc9864000000000000000000000000\(walletId)00000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000060000000000000000000000000000000000000000000000000000000000000000\(kg)", valueNew: "0x0", gas: "0x7A120")

        //    self.alertBlockOn = true
        //    self.buttonCO2 = false
           
        }
        .padding(.vertical, 5)
        .frame(width: 300)
        .modifier(miniButton())
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

        print("change = \(newNamber)")
    }
}
