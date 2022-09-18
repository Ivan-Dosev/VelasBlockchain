//
//  ContentView.swift
//  Hack_Velas
//
//  Created by Dosi Dimitrov on 3.09.22.
//

import SwiftUI
import web3swift


var contract:ProjectContract?

var web3:web3?
var network:Network = .rinkeby
var wallet:Wallet?
var password = "dakata_7b" // leave empty string for ganache

struct ContentView: View {

    @State private var buttonView : ButtonView?
    @EnvironmentObject  var walletConnect: WalletConnect
    
    var body: some View {
        ZStack (alignment: .bottom){
            Color("ColorBG").ignoresSafeArea()
            VStack( spacing: 15){
                VStack( spacing: 15){
                    
                    Text(walletConnect.personInfo.blockName.rawValue)
                        .padding(.top, 10)
                    
                    if walletConnect.textQR.isEmpty {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color("ColorButton"))
                            .overlay(     QREmpty())
                            .padding(.top, 10)
                    }else{
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color("ColorButton"))
                            .overlay(   QRCodeView(url: walletConnect.textQR))
                            .padding(.top, 10)
                    }
                    
                    Text("QR code information about you")
                        .font(.caption2)
                        .padding(.bottom, 12)
                    
                }
                .modifier(ArdaButton())
                .frame(width: widthButton * 1.7  , height: widthButton * 1.7  )
                .padding(.top, 35)
              
 
                Spacer()
                rollexView()
                buttonInfo()
                buttonList()
                buttonSend()
                gasCalculator()

            }.padding(.bottom, 35)
                .sheet(item: $buttonView) { item in
                    switch item {
                    case .buttonList: ListView()
                    case .buttonSend: SendView()
                    case .buttonInfo: InfoView()
                    case .gasCalculator: GasView()
                    case .rollex: RollexView()
                    }
                }
                .onAppear(){
                    guard let walletString  = UserDefaults.standard.object(forKey: "wallet") else { return }
                    let decoder = JSONDecoder()
                    guard let loadData = try? decoder.decode(PersonInfo.self, from: walletString as! Data ) else { return }
                    walletConnect.personInfo = loadData
                    walletConnect.textQR =  walletConnect.personInfo.metaMaskID + "/" +  walletConnect.personInfo.name + "/" +  walletConnect.personInfo.lastName + "/" +  walletConnect.personInfo.email + "/" + walletConnect.personInfo.blockName.rawValue + "/" + "99"
                    print("\(  walletConnect.textQR)")
                    print("aa =\(loadData)")
                }
        }.ignoresSafeArea()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

//MARK: - Buttons
extension ContentView {
    
    func buttonInfo() -> some View {
        Button("Info") {
      
            buttonView = .buttonInfo
        }
        .padding(.vertical, 20)
        .frame(width: widthButton)
        .modifier(CircleButton())
    }
    
    func buttonSend() -> some View {
        Button("Send") {
            
            buttonView = .buttonSend
            
        }
        .padding(.vertical, 20)
        .frame(width: widthButton)
        .modifier(CircleButton())
    }
    
    func buttonList() -> some View {
        Button("List") {
            
            buttonView = .buttonList
            
        }
        .padding(.vertical, 20)
        .frame(width: widthButton)
        .modifier(CircleButton())
    }
    func gasCalculator() -> some View {
        Button("Gas calculator") {
            
            buttonView = .gasCalculator
            
        }
        .padding(.vertical, 20)
        .frame(width: widthButton)
        .modifier(CircleButton())
    }
    func rollexView() -> some View {
        Button("Verify") {
            
            buttonView = .rollex
            
        }
        .padding(.vertical, 20)
        .frame(width: widthButton)
        .modifier(CircleButton())
    }
}




