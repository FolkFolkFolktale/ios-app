//
//  ContentView.swift
//  e-robot
//
//  Created by 박성민 on 7/15/24.
//

import SwiftUI

struct ContentView: View {
    @Binding var document: e_robotDocument

    var body: some View {
        TextEditor(text: $document.text)
    }
}

#Preview {
    ContentView(document: .constant(e_robotDocument()))
}
