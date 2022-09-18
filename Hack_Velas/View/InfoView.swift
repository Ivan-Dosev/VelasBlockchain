//
//  InfoView.swift
//  Hack_Velas
//
//  Created by Dosi Dimitrov on 3.09.22.
//

import SwiftUI

struct InfoView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject  var walletConnect: WalletConnect
    @Environment(\.openURL) var openURL
    @State var  personInfo : PersonInfo = PersonInfo(name: "", lastName: "", email: "", metaMaskID: "", blockName: .ethereum)
    @State var saveButtonOn : Bool = false
   
    @State private var qrcodeString = ""
    @State private var isOk : Bool = false
    @State private var show : Bool = false
    @State var choos : BlockName = .ethereum
    
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
                
                pickerView()
                    
                VStack{
                   
                   
                    
                    TextField("name...", text: $walletConnect.personInfo.name)
                           .textFieldStyle(RoundedBorderTextFieldStyle())
                    TextField("lastName...", text: $walletConnect.personInfo.lastName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    TextField("email", text: $walletConnect.personInfo.email)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                }
                
                .frame( height: 200, alignment: .center)
                .padding()
                .modifier(ArdaButton())
                .padding()
                if self.saveButtonOn{
                    VStack(alignment: .leading){
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
                            Text("Email : ")
                            Spacer()
                            Text("\(walletConnect.personInfo.email)")
                        }
                        HStack {
                            Text("Wallet ID: ")
                            Spacer()
                            Text(String(walletConnect.walletAccount.prefix(5)))
                            Text(".....")
                            Text(String(walletConnect.walletAccount.suffix(6)))
                       
                        }

                        
                    }
                    .foregroundColor(.white)
                    .font(.system(size: 18))
                    .padding()
                }


                Spacer()
            }
            saveInfo()
                .padding(.bottom,35)
        }
        
        .onAppear(){
            choos = walletConnect.personInfo.blockName
        }
       // .sheet(isPresented: $show) { QRCodeView(url: qrcodeString)}
    }
}

struct InfoView_Previews: PreviewProvider {
    static var previews: some View {
        InfoView()
    }
}


extension InfoView {
    
    func saveInfo() -> some View {
        Button(" Save ") {
            
            connectToMetaMask()
            personInfo.metaMaskID = walletConnect.walletAccount
            walletConnect.personInfo.blockName = choos
            print(walletConnect.personInfo.blockName.rawValue)
            self.saveButtonOn = true
           
        }
        .padding(.vertical, 20)
        .frame(width: widthButton * 2)
        .modifier(CircleButton())
        .disabled(self.saveButtonOn)
        .opacity(self.saveButtonOn ? 0 : 1)
    }
    
    func backInfo() -> some View {
        Button(" ⏎ ") {
            
            walletConnect.personInfo.metaMaskID = walletConnect.walletAccount
           
            if walletConnect.isNotEmptyName() {
                
                var encoder = JSONEncoder()
                let data = try? encoder.encode(walletConnect.personInfo as? PersonInfo)
                UserDefaults.standard.set(  data , forKey: "wallet")
                walletConnect.textQR =  walletConnect.personInfo.metaMaskID + "/" +  walletConnect.personInfo.name + "/" +  walletConnect.personInfo.lastName + "/" +  walletConnect.personInfo.email + "/" + walletConnect.personInfo.blockName.rawValue  + "/" + "99"
            }

            walletConnect.disconnect()
            presentationMode.wrappedValue.dismiss()
            print(walletConnect.textQR)
           
        }
        .padding(.vertical, 5)
        .frame(width: 50)
        .modifier(ArdaButton())
    }
    
    func connectToMetaMask() {
        let connectionUrl = walletConnect.connect()

        let deepLinkUrl = "wc://wc?uri=\(connectionUrl)"
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            if let url = URL(string: deepLinkUrl) {
              
                openURL(url) { accepted in
                    
                        if !accepted{
                            self.qrcodeString = deepLinkUrl
        
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2){
                                self.show.toggle()
                            }
                        }else{
                            self.isOk.toggle()
                        }
                        print(accepted ? "Success" : "Failure")
                    

                }
            }
        }
    }
    
    func pickerView() -> some View {
        
        Picker("This Title Is Localized", selection: $choos) {
            ForEach(BlockName.allCases) { value in
                Text(value.rawValue)
                    .tag(value)

            }
        }
        .pickerStyle(SegmentedPickerStyle())
        .padding()
    }
}
