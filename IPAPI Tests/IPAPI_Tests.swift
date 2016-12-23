//
//  IPAPI_Tests.swift
//  IPAPI Tests
//
//  Created by Artur Grigor on 23.12.2016.
//  Copyright © 2016 Artur Grigor. All rights reserved.
//

//
//  # Imports
//

import XCTest
import Mockingjay

//
//  # Class
//

class IPAPI_Tests: XCTestCase
{
    
    // MARK: - XCTestCase Methods -
    
    override func tearDown()
    {
        super.tearDown()
        self.removeAllStubs()
    }
    
    func testCurrentIPAddress()
    {
        self.stub(urlString: "/json", jsonFileName: "currentIp")
        
        var result: Service.Result?
        var error: Error?
        let responseArrived = self.expectation(description: "Response of async request has arrived")
        
        Service.default.fetch { r, e in
            result = r
            error = e
            responseArrived.fulfill()
        }
        
        self.waitForExpectations(timeout: 15) { inError in
            XCTAssertNotNil(result, "Result should not be nil.")
            XCTAssertNil(error, "Error should be nil.")
            
            XCTAssertEqual(result?.as, "AS15169 Google Inc.")
            XCTAssertEqual(result?.city, "Mountain View")
            XCTAssertEqual(result?.countryName, "United States")
            XCTAssertEqual(result?.countryCode, "US")
            XCTAssertEqual(result?.isp, "Google")
            XCTAssertEqual(result?.latitude, 37.4192)
            XCTAssertEqual(result?.longitude, -122.0574)
            XCTAssertEqual(result?.organization, "Google")
            XCTAssertEqual(result?.ip, "216.58.214.206")
            XCTAssertEqual(result?.regionCode, "CA")
            XCTAssertEqual(result?.regionName, "California")
            XCTAssertEqual(result?.status, .success)
            XCTAssertEqual(result?.timezone, "America/Los_Angeles")
            XCTAssertEqual(result?.zipCode, "94043")
        }
    }
    
    func testApple()
    {
        self.stub(urlString: "/json/apple.com", jsonFileName: "apple")
        
        var result: Service.Result?
        var error: Error?
        let responseArrived = self.expectation(description: "Response of async request has arrived")
        
        Service.default.fetch(query: "apple.com") { r, e in
            result = r
            error = e
            responseArrived.fulfill()
        }
        
        self.waitForExpectations(timeout: 15) { inError in
            XCTAssertNotNil(result, "Result should not be nil.")
            XCTAssertNil(error, "Error should be nil.")
            
            XCTAssertEqual(result?.as, "AS714 Apple Inc.")
            XCTAssertEqual(result?.city, "Cupertino")
            XCTAssertEqual(result?.countryName, "United States")
            XCTAssertEqual(result?.countryCode, "US")
            XCTAssertEqual(result?.isp, "Apple")
            XCTAssertEqual(result?.latitude, 37.323)
            XCTAssertEqual(result?.longitude, -122.0322)
            XCTAssertEqual(result?.organization, "Apple")
            XCTAssertEqual(result?.ip, "17.178.96.59")
            XCTAssertEqual(result?.regionCode, "CA")
            XCTAssertEqual(result?.regionName, "California")
            XCTAssertEqual(result?.status, .success)
            XCTAssertEqual(result?.timezone, "America/Los_Angeles")
            XCTAssertEqual(result?.zipCode, "95014")
        }
    }
    
    func testAppleWithAllFields()
    {
        self.stub(urlString: "/json/apple.com{?fields}", jsonFileName: "appleWithAllFields")
        
        var result: Service.Result?
        var error: Error?
        let responseArrived = self.expectation(description: "Response of async request has arrived")
        
        Service.default.fetch(query: "apple.com", fields: Service.Field.all) { r, e in
            result = r
            error = e
            responseArrived.fulfill()
        }
        
        self.waitForExpectations(timeout: 15) { inError in
            XCTAssertNotNil(result, "Result should not be nil.")
            XCTAssertNil(error, "Error should be nil.")
            
            XCTAssertEqual(result?.as, "AS714 Apple Inc.")
            XCTAssertEqual(result?.city, "Cupertino")
            XCTAssertEqual(result?.countryName, "United States")
            XCTAssertEqual(result?.countryCode, "US")
            XCTAssertEqual(result?.isp, "Apple")
            XCTAssertEqual(result?.latitude, 37.323)
            XCTAssertEqual(result?.longitude, -122.0322)
            XCTAssertEqual(result?.mobile, false)
            XCTAssertEqual(result?.organization, "Apple")
            XCTAssertEqual(result?.proxy, false)
            XCTAssertEqual(result?.ip, "17.142.160.59")
            XCTAssertEqual(result?.regionCode, "CA")
            XCTAssertEqual(result?.regionName, "California")
            XCTAssertEqual(result?.reverse, "apple.com")
            XCTAssertEqual(result?.status, .success)
            XCTAssertEqual(result?.timezone, "America/Los_Angeles")
            XCTAssertEqual(result?.zipCode, "95014")
        }
    }
    
    func testAppleWithAllFieldsInSpanish()
    {
        self.stub(urlString: "/json/apple.com{?fields&lang}", jsonFileName: "appleWithAllFieldsInSpanish")
        
        var result: Service.Result?
        var error: Error?
        let responseArrived = self.expectation(description: "Response of async request has arrived")
        
        Service.default.fetch(query: "apple.com", fields: Service.Field.all, language: "es") { r, e in
            result = r
            error = e
            responseArrived.fulfill()
        }
        
        self.waitForExpectations(timeout: 15) { inError in
            XCTAssertNotNil(result, "Result should not be nil.")
            XCTAssertNil(error, "Error should be nil.")
            
            XCTAssertEqual(result?.as, "AS714 Apple Inc.")
            XCTAssertEqual(result?.city, "Cupertino")
            XCTAssertEqual(result?.countryName, "Estados Unidos")
            XCTAssertEqual(result?.countryCode, "US")
            XCTAssertEqual(result?.isp, "Apple")
            XCTAssertEqual(result?.latitude, 37.323)
            XCTAssertEqual(result?.longitude, -122.0322)
            XCTAssertEqual(result?.mobile, false)
            XCTAssertEqual(result?.organization, "Apple")
            XCTAssertEqual(result?.proxy, false)
            XCTAssertEqual(result?.ip, "17.172.224.47")
            XCTAssertEqual(result?.regionCode, "CA")
            XCTAssertEqual(result?.regionName, "California")
            XCTAssertEqual(result?.reverse, "applecare.cc")
            XCTAssertEqual(result?.status, .success)
            XCTAssertEqual(result?.timezone, "America/Los_Angeles")
            XCTAssertEqual(result?.zipCode, "95014")
        }
    }
    
    func testFailed()
    {
        self.stub(urlString: "/json/failed.lookup", jsonFileName: "failed")
        
        var result: Service.Result?
        var error: Error?
        let responseArrived = self.expectation(description: "Response of async request has arrived")
        
        Service.default.fetch(query: "failed.lookup") { r, e in
            result = r
            error = e
            responseArrived.fulfill()
        }
        
        self.waitForExpectations(timeout: 15) { inError in
            XCTAssertNotNil(result, "Result should not be nil.")
            XCTAssertNil(error, "Error should be nil.")
            
            XCTAssertEqual(result?.message, "invalid query")
            XCTAssertEqual(result?.ip, "failed.lookup")
            XCTAssertEqual(result?.status, .fail)
        }
    }
    
}
