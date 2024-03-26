//
//  AddGarmentViewModel.swift
//  GarmentManager
//
//  Created by Sneha Kalariya on 2024-03-21.
//

import Foundation
import Combine

protocol AddGarmentViewModelProtocol{
    func saveNewGarment(name:String) async
}
class AddGarmentViewModel : ObservableObject{
    
    private var newGarment: Garment?
    private let dataManager: DataManager
    
    init(dataManager: DataManager = DataManager.shared) {
        self.dataManager = dataManager
    }
    
    private func createNewGarment(name:String) -> Garment{
        Garment(name: name,timestamp: Date())
    }
    
    func saveNewGarment(name:String) async{
        dataManager.updateAndSave(garment: self.createNewGarment(name: name))
    }
    
    
}
