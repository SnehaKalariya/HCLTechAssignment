//
//  AddGarmentViewModelTests.swift
//  GarmentManagerTests
//
//  Created by Sneha Kalariya on 2024-03-21.
//

import XCTest
import Combine
@testable import GarmentManager

final class AddGarmentViewModelTests: XCTestCase {

    var dataManager: DataManager!
    
    override func setUp() {
        dataManager = DataManager.testing
    }

    override func tearDown(){
        super.tearDown()
        dataManager = nil
    }

    func test_NewGarment_saved() async{
        let testViewModel = AddGarmentViewModel(dataManager: dataManager)
        await testViewModel.saveNewGarment(name: "Dress")
                
        let sut = getFetchGarments()
        
        XCTAssertEqual(sut.count,1)
        
    }
    func getFetchGarments() -> [Garment]{
        var garmentsTestData = [Garment]()
        var anyCancellable = Set<AnyCancellable>()

        self.dataManager.garmentSubject.sink { garments in
            garmentsTestData = garments
        }.store(in: &anyCancellable)
        dataManager.fetchGarments()
        
        return garmentsTestData
    }

}
