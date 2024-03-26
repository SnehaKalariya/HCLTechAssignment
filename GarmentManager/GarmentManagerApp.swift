//
//  GarmentManagerApp.swift
//  GarmentManager
//
//  Created by Sneha Kalariya on 2024-03-21.
//

import SwiftUI

@main
struct GarmentManagerApp: App {
    let persistenceController = PersistenceController.shared
    let viewModel = GarmentListViewModel()
    
    var body: some Scene {
        WindowGroup {
            GarmentListView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(viewModel)
        }
    }
}
