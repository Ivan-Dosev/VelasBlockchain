//
//  Hack_VelasApp.swift
//  Hack_Velas
//
//  Created by Dosi Dimitrov on 3.09.22.
//

import SwiftUI
import Firebase

@main
struct Hack_VelasApp: App {
    
    @StateObject var vm = WalletConnect()
    
    init(){
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(vm)
        }
    }
}
