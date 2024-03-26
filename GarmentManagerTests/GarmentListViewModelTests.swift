//
//  GarmentListViewModelTests.swift
//  GarmentManagerTests
//
//  Created by Sneha Kalariya on 2024-03-21.
//

import XCTest
import Combine
@testable import GarmentManager

final class GarmentListViewModelTests: XCTestCase {

    var dataManager: DataManager!
    
    override func setUp() {
        dataManager = DataManager.testing
    }

    override func tearDown(){
        super.tearDown()
        dataManager = nil
    }

    func test_FetchData_With_Category_Alpha() {
        let testViewModel = GarmentListViewModel(dataManager: dataManager)

        let testGarment2 = Garment(name: "Shirts")
        dataManager.updateAndSave(garment: testGarment2)
        
        let testGarment1 = Garment(name: "Pant")
        dataManager.updateAndSave(garment: testGarment1)

        testViewModel.didSelectCategory()
        
        XCTAssertEqual(testViewModel.garments[0].name,"Pant")
        
    }
    
    func test_FetchData_With_Category_CreationTime() {
        let testViewModel = GarmentListViewModel(dataManager: dataManager)

        let testGarment2 = Garment(name: "Shirts")
        dataManager.updateAndSave(garment: testGarment2)
        
        let testGarment1 = Garment(name: "Pant")
        dataManager.updateAndSave(garment: testGarment1)

        testViewModel.didSelectCategory(sortBy: .creationTime)
        
        XCTAssertEqual(testViewModel.garments[0].name,"Shirts")
        
    }


}
