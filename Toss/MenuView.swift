//
//  MenuView.swift
//  Toss
//
//  Created by Sam Herring on 6/23/20.
//  Copyright © 2020 Sam Herring. All rights reserved.
//

import SwiftUI

struct MenuView: View {
    var body: some View {
        
        ZStack {
            
            RoundedRectangle(cornerRadius: 25.0, style: .continuous)
                .foregroundColor(.red)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Text("Toss Menu")
                    .font(.system(size: 42.0))
                    .shadow(radius: 2)
                    .foregroundColor(.white)
                    .padding(.top)
                
                Spacer()
                
                Button("Play solo") {
                    
                }.foregroundColor(.white)
                .font(.system(size: 32.0))
                .padding(.vertical, 20)
                
                Button("With the bros") {
                    print("Poof")
                }.foregroundColor(.white)
                .font(.system(size: 32.0))
                .padding(.vertical, 20)
                
                Button("Settings") {
                    print("Splerf")
                }.foregroundColor(.white)
                .font(.system(size: 32.0))
                .padding(.vertical, 20)
            }
        }
        
        }
        
}

struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView()
    }
}
