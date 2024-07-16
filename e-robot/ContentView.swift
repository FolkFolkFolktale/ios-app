//
//  ContentView.swift
//  e-robot
//
//  Created by 박성민 on 7/15/24.
//

import SwiftUI

struct ContentView: View {

    var body: some View {
        Text("이로봇")
            .font(.system(size: 30))
            .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
            .foregroundStyle(.purple)
        Button{
            
        }label:{
            Text("시작하기")
        }
    }
}

#Preview {
    ContentView()
}
