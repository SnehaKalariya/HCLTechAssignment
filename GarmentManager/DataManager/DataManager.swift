//
//  DataManager.swift
//  HCLTakeHome
//
//  Created by Sneha Kalariya on 2024-03-21.
//

import Foundation
import CoreData
import Combine

enum DataManagerType {
    case normal, testing
}

class DataManager : NSObject, ObservableObject{
    static let shared = DataManager(type: .normal)
    static let testing = DataManager(type: .testing)
    var garmentSubject = PassthroughSubject<[Garment],Never>()
        
    fileprivate var managedObjectContext: NSManagedObjectContext
    private let garmentsFRC: NSFetchedResultsController<GarmentMO>
    
    private init(type: DataManagerType) {
        switch type {
        case .normal:
            let persistentStore = PersistenceController.shared
            self.managedObjectContext = persistentStore.container.viewContext
        
        case .testing:
            let persistentStore = PersistenceController(inMemory: true)
            self.managedObjectContext = persistentStore.container.viewContext
        }
        
        let garmentFR: NSFetchRequest<GarmentMO> = GarmentMO.fetchRequest()
        garmentFR.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        garmentsFRC = NSFetchedResultsController(fetchRequest: garmentFR,
                                              managedObjectContext: managedObjectContext,
                                              sectionNameKeyPath: nil,
                                              cacheName: nil)
        
        super.init()
        
        garmentsFRC.delegate = self

    }
    
    func saveData() {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch let error as NSError {
                NSLog("Unresolved error saving context: \(error), \(error.userInfo)")
            }
        }
    }
    
}

//MARK: NSFetchedResultsController Delegate Methods
extension DataManager : NSFetchedResultsControllerDelegate{
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        if let newGarments = controller.fetchedObjects as? [GarmentMO] {
            self.garmentSubject.send(newGarments.map{Garment(garmentMO: $0)})
        }
    }
    
    private func fetchFirst<T: NSManagedObject>(_ objectType: T.Type, predicate: NSPredicate?) -> Result<T?, Error> {
        let request = objectType.fetchRequest()
        request.predicate = predicate
        request.fetchLimit = 1
        do {
            let result = try managedObjectContext.fetch(request) as? [T]
            return .success(result?.first)
        } catch {
            return .failure(error)
        }
    }
    
    func fetchGarments(predicate: NSPredicate? = nil, sortDescriptors: [NSSortDescriptor]? = nil){
        if let predicate = predicate {
            garmentsFRC.fetchRequest.predicate = predicate
        }
        if let sortDescriptors = sortDescriptors {
            garmentsFRC.fetchRequest.sortDescriptors = sortDescriptors
        }
        try? garmentsFRC.performFetch()

        if let newGarments = garmentsFRC.fetchedObjects {
            let sortedList = newGarments.map { mo in
                Garment(garmentMO: mo)
            }
            self.garmentSubject.send(sortedList)
        }
    }
    
}
extension DataManager {
    
    func updateAndSave(garment: Garment) {
        let predicate = NSPredicate(format: "id = %@", garment.id as CVarArg)
        let result = fetchFirst(GarmentMO.self, predicate: predicate)
        switch result {
        case .success(let managedObject):
            if let garmentMO = managedObject {
                update(garmentMO: garmentMO, from: garment)
            } else {
                garmentMo(from: garment)
            }
        case .failure(_):
            print("Couldn't fetch Data to save")
        }
        saveData()
    }
    private func garmentMo(from garment: Garment) {
        let garmentMO = GarmentMO(context: managedObjectContext)
        garmentMO.id = garment.id
        update(garmentMO: garmentMO, from: garment)
    }
    
    private func update(garmentMO: GarmentMO, from garment: Garment) {
        garmentMO.name = garment.name
        garmentMO.timestamp = garment.timestamp
    }
    
}
