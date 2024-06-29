//
//  ViewManipulationDemoApp.swift
//  ViewManipulationDemo
//
//  Created by Itsuki on 2024/06/28.
//

import SwiftUI

@main
struct ViewManipulationDemoApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                ContentView()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            .background(Color.gray.opacity(0.2))
        }
    }
}
