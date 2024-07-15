//
//  e_robotApp.swift
//  e-robot
//
//  Created by 박성민 on 7/15/24.
//

import SwiftUI

@main
struct e_robotApp: App {
    var body: some Scene {
        DocumentGroup(newDocument: e_robotDocument()) { file in
            ContentView(document: file.$document)
        }
    }
}
