//
//  ZcashRustBackendTests.swift
//  ZcashLightClientKitTests
//
//  Created by Jack Grigg on 28/06/2019.
//  Copyright © 2019 Electric Coin Company. All rights reserved.
//

import XCTest
@testable import ZcashLightClientKit

class ZcashRustBackendTests: XCTestCase {
    var dbData: URL!
    
    override func setUp() {
        dbData = try! __dataDbURL()
        
    }
    
    override func tearDown() {
        
        try? FileManager.default.removeItem(at: dbData!)
        
    }
    
    func testInitAndGetAddress() {
        let seed = "seed"
        
        XCTAssertNoThrow(try ZcashRustBackend.initDataDb(dbData: dbData!))
        
        let _ = ZcashRustBackend.initAccountsTable(dbData: dbData!, seed: Array(seed.utf8), accounts: 1)
        XCTAssertEqual(ZcashRustBackend.getLastError(), nil)
        
        let addr = ZcashRustBackend.getAddress(dbData: dbData!, account: 0)
        XCTAssertEqual(ZcashRustBackend.getLastError(), nil)
        XCTAssertEqual(addr, Optional("ztestsapling1meqz0cd598fw0jlq2htkuarg8gqv36fam83yxmu5mu3wgkx4khlttqhqaxvwf57urm3rqsq9t07"))
        
        // Test invalid account
        let addr2 = ZcashRustBackend.getAddress(dbData: dbData!, account: 1)
        XCTAssert(ZcashRustBackend.getLastError() != nil)
        XCTAssertEqual(addr2, nil)
    }
    
    func testInitAndScanBlocks() {
        guard  let cacheDb = Bundle(for: Self.self).url(forResource: "cache", withExtension: "db") else {
            XCTFail("pre populated Db not present")
            return
        }
        let seed = "testreferencealice"
        XCTAssertNoThrow(try ZcashRustBackend.initDataDb(dbData: dbData!))
        XCTAssertEqual(ZcashRustBackend.getLastError(), nil)
        
        XCTAssertNotNil(ZcashRustBackend.initAccountsTable(dbData: dbData!, seed: Array(seed.utf8), accounts: 1))
        XCTAssertEqual(ZcashRustBackend.getLastError(), nil)
        
        let addr = ZcashRustBackend.getAddress(dbData: dbData!, account: 0)
        XCTAssertEqual(ZcashRustBackend.getLastError(), nil)
        XCTAssertEqual(addr, Optional("ztestsapling12pxv67r0kdw58q8tcn8kxhfy9n4vgaa7q8vp0dg24aueuz2mpgv2x7mw95yetcc37efc6q3hewn"))
        
        XCTAssertTrue(ZcashRustBackend.scanBlocks(dbCache: cacheDb, dbData: dbData))
        
    }
}