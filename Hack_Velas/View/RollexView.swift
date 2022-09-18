//
//  RollexView.swift
//  Hack_Velas
//
//  Created by Dosi Dimitrov on 17.09.22.
// Ivan

import SwiftUI

struct RollexView: View {
    
    
    @Environment(\.presentationMode) var presentationMode
    @State private var adressNFT : String = ""
    @State private var adressContract : String = ""
    @State private var urlAdress : URL?
    @State private var Addres_NFT : Bool = false
    @State private var Contract_addres : Bool = false
    @State private var contractCreator : String = ""
    @State private var txHash : String = ""
    @State private var onButton : Bool = false
    
    var body: some View {
        ZStack (alignment: .bottom){
            Color("ColorBG").opacity(0.3).ignoresSafeArea()
            VStack(alignment: .center, spacing: 25) {
                
                HStack {
                    backInfo()
                        .padding(.leading, 20)
                        .padding(.top, 10)


                    Spacer()
                }
                
                VStack{

                Text("NFT Verification")
                        .font(.system(size: 32))
                        .fontWeight(.bold)
                        .padding()
                    
                    ZStack {
                        TextField("Contract Address", text:$adressContract)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.horizontal, 10)
                            .onChange(of: adressContract) { item in
                                if item != "" {
                                    Contract_addres = true
                                }else{
                                    Contract_addres = false
                                }
                            }

                        Button("☒") {
                            self.adressContract = ""
                            self.contractCreator = ""
                            self.txHash = ""

                        }
                        .font(.system(size: 28))
                        .background(RoundedRectangle(cornerRadius: 5).fill(Color.white))
                        .offset(x: 150)
                    }
                
                }
                .frame( height: 200, alignment: .center)
                .padding()
                .modifier(ArdaButton())
                .padding(.horizontal, 20)
                
                if !contractCreator.isEmpty {
                    VStack{
                        VStack(alignment: .leading){
                            HStack{
                                Text("contract Creator:")
                                Spacer()
                                Image(systemName: "doc.on.doc")
                                    .onTapGesture {
                                        UIPasteboard.general.string = contractCreator
                                    }
                            }
                            .onAppear(){
                                self.onButton = false
                            }
                          
                           
                            Text("\(contractCreator)")
                                .lineLimit(5)
                                .foregroundColor(.white)
                        }
                        .padding(.top, 20)
                        Spacer()
                        VStack(alignment: .leading){
                            HStack{
                                Text("txHash:")
                                Spacer()
                                Image(systemName: "doc.on.doc")
                                    .onTapGesture {
                                        UIPasteboard.general.string = txHash
                                    }
                            }
                           
                           
                            Text("\(txHash)")
                                .lineLimit(5)
                                .foregroundColor(.white)
                        }
                        .padding(.bottom, 20)
                        ZStack{
                            Text("🟩")
                                .font(.system(size: 32))
                            Text("✔︎")
                                .foregroundColor(.white)
                                .font(.system(size: 22))
                        }
                     
                        
                    }
                    .frame( height: 200, alignment: .center)
                        .padding()
                        .modifier(ArdaButton())
                        .padding(.horizontal, 20)
                }else{
                    if onButton {
                        ProgressView()
                            .scaleEffect(2)
                    }

                }
                

                
                Spacer()
                if Contract_addres {
                    rollexVerification(adress:  adressContract)
                }
                
            }
            .padding(.top, 20)
          
        }
    }
}

struct RollexView_Previews: PreviewProvider {
    static var previews: some View {
        RollexView()
    }
}


extension RollexView {
    func backInfo() -> some View {
        Button(" ⏎ ") {
            
 
            presentationMode.wrappedValue.dismiss()
     
           
        }
        .padding(.vertical, 5)
        .frame(width: 50)
        .modifier(ArdaButton())
    }
    
    func rollexVerification(adress: String) -> some View {
        Button(" Verify ") {
            self.contractCreator = ""
            self.txHash = ""
            self.onButton = true
   //     https://api.etherscan.io/api?module=contract&action=getcontractcreation&contractaddresses=0xB83c27805aAcA5C7082eB45C868d955Cf04C337F,0x68b3465833fb72A70ecDF485E0e4C7bD8665Fc45,0xe4462eb568E2DFbb5b0cA2D3DbB1A35C9Aa98aad,0xdAC17F958D2ee523a2206206994597C13D831ec7,0xf5b969064b91869fBF676ecAbcCd1c5563F591d0&apikey=2VJIK89PPWWYH129PG45A7BU7KXN9M8E6Q
            
            guard let  urlAdress = URL(string: "https://api.etherscan.io/api?module=contract&action=getcontractcreation&contractaddresses=\(adress)&apikey=2VJIK89PPWWYH129PG45A7BU7KXN9M8E6Q") else { return}
            
            connectNow(url: urlAdress)
           
        }
      
        .padding(.vertical, 20)
        .frame(width: widthButton * 2)
        .modifier(CircleButton())

    }
    
    func connectNow(url : URL?){
        
      //  self.alertOn  = false
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
                     print(posts)

                 
                
                     posts.forEach {  age in
                       //  print("is \(age["gasUsed"]!) ")
                      //   gasUsed += (age["gasUsed"]! as AnyObject).doubleValue!
                      //   self.tokenName = age["tokenName"]! as! String
                      //   self.tokenSymbol = age["tokenSymbol"]! as! String
                         self.txHash = age["txHash"]! as! String
                         self.contractCreator = age["contractCreator"]! as! String
                     }
                 
                  //   self.UsedGas =  gasUsed
                  //   self.numberContracts = posts.count
                  //   self.progressView = false
                  //   print(UsedGas)
                 }
             } catch let parseError {
                 print("parsing error: \(parseError)")
                 let responseString = String(data: data, encoding: .utf8)
                     print("raw response: \(responseString)")
                   //  self.alertOn  = true
                 }
             
             
         //   let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
         //   print("-----1> responseJSON: \(responseJSON)")
         //   if let responseJSON = responseJSON as? [String : Any] {
         //       print("-----2> responseJSON: \(responseJSON)")
         //  }
      
         }.resume()
      
         }
}
