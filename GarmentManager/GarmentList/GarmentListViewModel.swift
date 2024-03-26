//
//  GarmentListViewModel.swift
//  HCLTakeHome
//
//  Created by Sneha Kalariya on 2024-03-21.
//

import Foundation
import Combine

protocol GarmentListViewModelProtocol{
    var garments: [Garment] {get set}
    func didSelectCategory(sortBy:Sort)
}
class GarmentListViewModel : ObservableObject, GarmentListViewModelProtocol {

    private let dataManager: DataManager
    
    @Published var garments = [Garment]()
    private var anyCancellable = Set<AnyCancellable>()
    
    init(dataManager: DataManager = DataManager.shared) {
        self.dataManager = dataManager
        self.listenToGarments()
        
        self.fetchGarments(sortBy: .alpha)
    }
 
    private func fetchGarments(sortBy:Sort) {
        if sortBy == .creationTime{
            dataManager.fetchGarments(sortDescriptors: [NSSortDescriptor(key: sortBy.passValue, ascending: false)])
        }else{
            dataManager.fetchGarments(sortDescriptors: [NSSortDescriptor(key: sortBy.passValue, ascending: true)])
        }
    }
    
    private func listenToGarments(){
        self.dataManager.garmentSubject.sink { garments in
            self.garments.removeAll()
            self.garments = garments
        }.store(in: &self.anyCancellable)
        
    }
    func didSelectCategory(sortBy:Sort = .alpha){
        self.fetchGarments(sortBy: sortBy)
    }
}

enum Sort: String, Equatable, Identifiable {
    case alpha, creationTime
    
    var id: Self { self }
    
    var passValue : String {
        switch self{
        case .alpha:
            return "name"
        case .creationTime:
            return "timestamp"
        }
    }
}


