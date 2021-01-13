//
//  ValidationServiceTests.swift
//  Lector de camara Tests
//
//  Created by Carlos Caraccia on 1/12/21.
//

@testable import Lector_de_camaraExtension
import XCTest

class ValidationServiceTests: XCTestCase {
    
    // reference to validation service
    var fileValidationService: FileValidationService!
    
    // every time I run a test this function will run
    
    override func setUp() {
        super.setUp()
        fileValidationService = FileValidationService()
    }
    
    override func tearDown() {
        fileValidationService = nil
        super.tearDown()
    }
    
    func test_if_the_file_is_valid() throws {
        // must throw no error
        let fileURL = Bundle.main.url(forResource: "Salida de depostada", withExtension: "TXT")!
        
        XCTAssertNoThrow(try fileValidationService.validateInputFile(urlFile: fileURL))
    }
    
}
