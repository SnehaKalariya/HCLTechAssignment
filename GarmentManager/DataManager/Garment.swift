//
//  Garment.swift
//  GarmentManager
//
//  Created by Sneha Kalariya on 2024-03-21.
//

import Foundation

/**
 This is the view-facing `Garment` struct. Views should have no idea that this struct is
 backed up by a CoreData Managed Object: `GarmentMO`. The `DataManager`
 handles keeping this in sync via `NSFetchedResultsControllerDelegate`.
 */
struct Garment: Identifiable {
    var id: UUID
    var name: String
    var timestamp: Date
    
    init(name : String = "", timestamp: Date = Date()) {
        self.id = UUID()
        self.name = name
        self.timestamp = timestamp
    }
}
//MARK: - Garment Methods
extension Garment {
    
     init(garmentMO: GarmentMO) {
        self.id = garmentMO.id ?? UUID()
        self.name = garmentMO.name ?? ""
        self.timestamp = garmentMO.timestamp ?? Date()
    }
}
