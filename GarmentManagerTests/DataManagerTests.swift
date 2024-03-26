//
//  DataManagerTests.swift
//  GarmentManagerTests
//
//  Created by Sneha Kalariya on 2024-03-21.
//

import XCTest
import Combine

@testable import GarmentManager

final class DataManagerTests: XCTestCase {
    var dataManager: DataManager!
    
    override func setUp() {
        dataManager = DataManager.testing
        
    }

    override func tearDown(){
        super.tearDown()
        dataManager = nil
    }
    
    func test_Fetch_Garments_Initialy_Empty(){

        let sut = getFetchGarments()
        
        XCTAssertEqual(sut.count,0)
        
    }
    func test_Update_And_Save_And_Fetch_Not_Empty(){
        let testGarment = Garment(name: "Pant")
        dataManager.updateAndSave(garment: testGarment)
        
        let sut = getFetchGarments()
        
        XCTAssertNotNil(sut)
        
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
