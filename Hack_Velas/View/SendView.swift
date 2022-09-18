//
//  SendView.swift
//  Hack_Velas
//
//  Created by Dosi Dimitrov on 3.09.22.
//

import SwiftUI
import CodeScanner

struct SendView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject  var walletConnect: WalletConnect
    @State private var isOnScener : Bool = false
    @State private var scanner : String = ""
    @State private var show : Bool = false
    @State private var showRecipient : Bool = false
    @State private var gasCalculatorOn : Bool = false
    @State private var buttonGas : Bool = false
    @State private var infoOnOffButton : Bool = false
    @State private var animationButton : Bool = false
    @State private var animationButtonTwo: Bool = false
    @Environment(\.openURL) var openURL

    
    var body: some View {
        
        ZStack (alignment: .bottom){
            
            Color("ColorBG").opacity(0.7).ignoresSafeArea()
            
            
            VStack{
                HStack {
                    backInfo()
                        .padding(.leading, 20)
                        .padding(.top, 20)


                    Spacer()
                }
                VStack(alignment: .leading){
                    Text("Sender: /\(walletConnect.personInfo.blockName.rawValue)/")
                        .foregroundColor(.yellow)
                    HStack {
                        Text("First name: ")
                        Spacer()
                        Text("\(walletConnect.personInfo.name)")
                    }
                    HStack {
                        Text("Last name: ")
                        Spacer()
                        Text("\(walletConnect.personInfo.lastName)")
                    }
                    HStack {
                        Text("Email: ")
                        Spacer()
                        Text("\(walletConnect.personInfo.email)")
                    }
                    HStack {
                        Text("Wallet ID: ")
                        Spacer()
                        Text(String(walletConnect.personInfo.metaMaskID.prefix(5)))
                        Text(".....")
                        Text(String(walletConnect.personInfo.metaMaskID.suffix(6)))
                    }
                }
                .foregroundColor(.white)
                .font(.caption)
                .padding()
                .frame(width: widthButton * 2, height: 120)
                .modifier(ArdaButton())
             
                
                if self.showRecipient {
                    VStack(alignment: .leading){
                        Text("Recipient: / \(walletConnect.recipientInfo.blockName.rawValue) /" )
                            .foregroundColor(.yellow)
                        HStack {
                            Text("Fiest name: ")
                            Spacer()
                            Text("\(walletConnect.recipientInfo.name)")
                        }
                        HStack {
                            Text("Last name: ")
                            Spacer()
                            Text("\(walletConnect.recipientInfo.lastName)")
                        }
                        HStack {
                            Text("Email: ")
                            Spacer()
                            Text("\(walletConnect.recipientInfo.email)")
                        }
                        HStack {
                            Text("Wallet ID: ")
                            Spacer()
                            Text(String(walletConnect.recipientInfo.metaMaskID.prefix(5)))
                            Text(".....")
                            Text(String(walletConnect.recipientInfo.metaMaskID.suffix(6)))
                        }
                    }
                    .foregroundColor(.white)
                    .font(.caption)
                    .padding()
                    .frame(width: widthButton * 2, height: 120)
                    .modifier(ArdaButton())
                }

                
                HStack {
                    Spacer()
                    recipient()
                }.padding(.horizontal)
                
               
                VStack {
                    ZStack{
                        
                        TextField("value in eth ", text: $walletConnect.sumaTrans)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .multilineTextAlignment(.trailing)
                        HStack{
                            Text("eth =")
                                .opacity(self.walletConnect.sumaTrans == "" ? 0 : 1)
                                .padding(.leading, 10)
                            Spacer()
                        }
                        
                    }

                    ZStack{
                        
                        TextField("gas in wai", text: $walletConnect.gasTrans)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .opacity(self.gasCalculatorOn ? 1 : 0)
                        .multilineTextAlignment(.trailing)
                        HStack{
                            Text("gas = ")
                                .opacity(self.gasCalculatorOn ? 1 : 0)
                                .padding(.leading, 10)
                            Spacer()
                        }

                        
                        if buttonGas {
                            ProgressView()
                                .scaleEffect(2)
                                .tint(.white)
                               
                        }
                        
                    }

                    
                }
                  .padding()
                  .frame(width: widthButton * 2, height: 120)
                  .modifier(ArdaButton())
                
                HStack {
                    Spacer()
                    gasCalculator()
                }.padding(.horizontal)

                Spacer()
                if  walletConnect.recipientInfo.name != "" && walletConnect.gasTrans != "" && walletConnect.sumaTrans != ""{
                   
                    if walletConnect.personInfo.blockName.rawValue == walletConnect.recipientInfo.blockName.rawValue {
                        
                           sendInfo()
                       
                    }else{
                      
                          brighInfo()
                    }
                }
            }
            .padding(.bottom, 25)
            if infoOnOffButton {
                infoView2()
                
            }

        }   .sheet(isPresented: $isOnScener) { scannerNumberSheet }
            .onAppear(){
                connectToMetaMask()
            }
        
        
    }
}

struct QRView_Previews: PreviewProvider {
    static var previews: some View {
        SendView()
    }
}

extension SendView {
    
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
    
    func backInfo() -> some View {
        Button(" ⏎ ") {
            
            walletConnect.disconnect()
            presentationMode.wrappedValue.dismiss()
           
        }
        .padding(.vertical, 5)
        .frame(width: 50)
        .modifier(ArdaButton())
    }
    
    
    func gasCalculator() -> some View {
        Button("Gas Calculator") {
            
            self.gasCalculatorOn = false
            self.buttonGas.toggle()
            walletConnect.gasTrans = ["42500", "43700", "45100" , "45300"].randomElement()!
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                self.buttonGas.toggle()
                self.gasCalculatorOn  = true
            }
           
        }
        .padding(.vertical, 15)
        .frame(width: widthButton)
        .modifier(CircleButton())
      //  .disabled(self.saveButtonOn)
      //  .opacity(self.saveButtonOn ? 0 : 1)
    }
    
    func recipient() -> some View {
        Button("recipient") {
            
            self.isOnScener = true
           
        }
        .padding(.vertical, 15)
        .frame(width: widthButton)
        .modifier(CircleButton())
      //  .disabled(self.saveButtonOn)
      //  .opacity(self.saveButtonOn ? 0 : 1)
    }
    
    func brighInfo() -> some View {
        
        Button("Brigh Transaction") {
            
            withAnimation(.linear(duration: 0.5)){
                infoOnOffButton = true
                    animationButton.toggle()
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    animationButton.toggle()
                    animationButtonTwo.toggle()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        animationButtonTwo.toggle()
                    }
                }

                
                DispatchQueue.main.asyncAfter(deadline: .now() + 5.5) {
                    
                    infoOnOffButton = false
                }
            }
        }
        .padding(.vertical, 25)
        .frame(width: widthButton * 2)
        .modifier(CircleButton())
      //  .disabled(self.saveButtonOn)
      //  .opacity(self.saveButtonOn ? 0 : 1)
    }
    
    func sendInfo() -> some View {
        
        Button("Send Transaction") {
            
            
            walletConnect.eth_sendTransaction(cont: walletConnect.recipientInfo.metaMaskID, dataNew: "0x0", valueNew: IntToHex(value: (walletConnect.sumaTrans as NSString).doubleValue), gas: "0x\(GasToHex(value: (walletConnect.gasTrans as NSString).doubleValue))" )
            walletConnect.addData()
            
            withAnimation(.linear(duration: 0.5)){
                infoOnOffButton = true
                    animationButton.toggle()
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    animationButton.toggle()
                    animationButtonTwo.toggle()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        animationButtonTwo.toggle()
                    }
                }

                
                DispatchQueue.main.asyncAfter(deadline: .now() + 5.5) {
                    
                    infoOnOffButton = false
                }
            }
        }
        .padding(.vertical, 25)
        .frame(width: widthButton * 2)
        .modifier(CircleButton())
      //  .disabled(self.saveButtonOn)
      //  .opacity(self.saveButtonOn ? 0 : 1)
    }
    

    func infoView2() -> some View {
        ZStack{
            Circle()
                .stroke( animationButtonTwo    ?  Color.gray  : animationButton ?  Color.gray :  Color("ColorButton")   , lineWidth: 30)
                .frame(width: 300, height: 300, alignment: .center)
            Circle()
                .stroke(animationButton ?  Color.gray :  Color("ColorButton")  , lineWidth: 30)
                .frame(width: 170, height: 170, alignment: .center)
            if animationButton {
                ProgressView()
                    .scaleEffect(4)
                    .tint(Color("ColorButton"))
            }
            if animationButtonTwo {
                ProgressView()
                    .scaleEffect(4)
                    .tint(Color("ColorButton"))
            }
            Text("Confirm \nMetamask")
                .foregroundColor(Color("ColorButton"))

        }
       
        .frame(width:( widthButton * 2) - 20, height: widthButton * 2)
        .background(RoundedRectangle(cornerRadius: 25).fill(.regularMaterial))
    }
    
    var scannerNumberSheet: some View {
        CodeScannerView(codeTypes: [.qr] , completion: { result in
            switch result {
            case .success(let res) :
                print("\(res)")
                walletConnect.saveRecipient(item: res.string)
                self.isOnScener = false
                self.showRecipient = true
            case .failure(let err):
                print("\(err)")
                self.isOnScener = false
            }
        })
    }
    var scannerSheet: some View {
        CodeScannerView(codeTypes: [.qr] , completion: { result in
            switch result {
            case .success(let res) :
                print("\(res)")
                self.scanner = res.string
            print("scanner : \(self.scanner)")
                   self.isOnScener = false
                
             //   DispatchQueue.main.async {
             //       arda.loadDataFrom(name: self.scanner)
             //   }
            case .failure(let err):
                print("\(err)")
              //  self.isPresentingScanner = false
            }
        })
    }
    
    

    
    func IntToHex(value: Double) -> String {
        
        let newValue = 1000000000000000000 * value
        let sr = String(format: "%llX", Int(newValue))

        return sr
    }
    
    func GasToHex(value: Double) -> String {
        
      
        let sr = String(format: "%02X", Int(value))

        return sr
    }
    
    
}
