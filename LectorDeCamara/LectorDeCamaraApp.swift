//
//  LectorDeCamaraApp.swift
//  LectorDeCamara
//
//  Created by Carlos Caraccia on 10/30/20.
//

import SwiftUI

@main
struct LectorDeCamaraApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            PalletBuilderMainView().environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
