//
//  Modifier.swift
//  Hack_Velas
//
//  Created by Dosi Dimitrov on 3.09.22.
//

import SwiftUI

struct CircleButton: ViewModifier {

    func body(content: Content) -> some View {
        content
            .background(
                ZStack {
            
                    Color.blue
                    RoundedRectangle(cornerRadius: 45)
                        .fill(Color("ColorButton"))
                        .foregroundColor(.white)
                        .blur(radius: 4.0)
                        .offset(x: -4.0, y: -4.0) })

       
            .foregroundColor(.gray)
            .clipShape(  RoundedRectangle(cornerRadius: 45))
            .shadow(color:Color.yellow, radius: 2, x: 2.0  , y:  2.0)
   

    }
}

struct ArdaButton: ViewModifier {

    func body(content: Content) -> some View {
        content
            .background(
                ZStack {
            
                    Color.blue
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color("ColorButton"))
                        .foregroundColor(.white)
                        .blur(radius: 4.0)
                        .offset(x: -4.0, y: -4.0)
                    
                })

       
            .foregroundColor(.gray)
            .clipShape(  RoundedRectangle(cornerRadius: 20))
            .shadow(color:Color.yellow, radius: 2, x: 2.0  , y:  2.0)
   

    }
}
struct NFTButton: ViewModifier {

    func body(content: Content) -> some View {
        content
        
            .background(
                ZStack {
            
                    Color.blue
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color("ColorButton"))
                        .foregroundColor(.white)
                        .blur(radius: 4.0)
                        .offset(x: -4.0, y: -4.0)
                    
                })

           
            .foregroundColor(.gray)
            .clipShape(  RoundedRectangle(cornerRadius: 20))
            .shadow(color:Color.yellow, radius: 2, x: 2.0  , y:  2.0)
   

    }
}

struct miniButton: ViewModifier {

    func body(content: Content) -> some View {
        content
            
            .background(
                ZStack {
            
                    Color.blue
                    RoundedRectangle(cornerRadius: 5)
                        .fill(Color("ColorButton"))
                        .foregroundColor(.white)
                        .blur(radius: 4.0)
                        .offset(x: -4.0, y: -4.0)
                    
                })

       
            .foregroundColor(.gray)
            .clipShape(  RoundedRectangle(cornerRadius: 5))
            .shadow(color:Color.yellow, radius: 2, x: 2.0  , y:  2.0)
   

    }
}

enum NodeScale: Float {
    case BackgroundScale
}

extension NodeScale {
    
    func getValue() -> CGFloat{
        let isPad = UIDevice.current.userInterfaceIdiom == .pad
        
        switch self {
        case .BackgroundScale:
            return isPad ? 1.5 : 1.35
        }
    }
}
// let scaleFactor = NodeScale.BackgroundScale.getValue()
 var widthButton =  CGFloat ((UIScreen.main.bounds.width / 3 ) * NodeScale.BackgroundScale.getValue())
