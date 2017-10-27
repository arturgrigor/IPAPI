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
import OHHTTPStubs

//
//  # Class
//

class IPAPI_Tests: XCTestCase
{
    
    // MARK: - XCTestCase Methods -
    
    override func tearDown()
    {
        super.tearDown()
        OHHTTPStubs.removeAllStubs()
    }
    
    func testCurrentIPAddress()
    {
        OHHTTPStubs.stubRequests(passingTest: { request in
            request.url?.path == "/json"
        }) { _ in
            return OHHTTPStubsResponse(fileAtPath: OHPathForFile("currentIp.json", type(of: self))!, statusCode: 200, headers: [:])
        }
        
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
        OHHTTPStubs.stubRequests(passingTest: { request in
            request.url?.path == "/json/apple.com"
        }) { _ in
            return OHHTTPStubsResponse(fileAtPath: OHPathForFile("apple.json", type(of: self))!, statusCode: 200, headers: [:])
        }
        
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
        OHHTTPStubs.stubRequests(passingTest: { request in
            request.url?.path == "/json/apple.com"
        }) { _ in
            return OHHTTPStubsResponse(fileAtPath: OHPathForFile("appleWithAllFields.json", type(of: self))!, statusCode: 200, headers: [:])
        }
        
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
        OHHTTPStubs.stubRequests(passingTest: { request in
            request.url?.path == "/json/apple.com"
        }) { _ in
            return OHHTTPStubsResponse(fileAtPath: OHPathForFile("appleWithAllFieldsInSpanish.json", type(of: self))!, statusCode: 200, headers: [:])
        }
        
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
    
    func testBatch()
    {
        OHHTTPStubs.stubRequests(passingTest: { request in
            request.url?.path == "/batch"
        }) { _ in
            return OHHTTPStubsResponse(fileAtPath: OHPathForFile("batch.json", type(of: self))!, statusCode: 200, headers: [:])
        }
        
        var result: [Service.Result]?
        var error: Error?
        let responseArrived = self.expectation(description: "Response of async request has arrived")
        
        Service.default.batch([Service.Request(query: "208.80.152.201",
                                               fields: [.countryName, .countryCode, .latitude, .longitude, .organization, .ip]),
                               Service.Request(query: "91.198.174.192", language: "es")]) { r, e in
            result = r
            error = e
            responseArrived.fulfill()
        }
        
        self.waitForExpectations(timeout: 15) { inError in
            XCTAssertNotNil(result, "Result should not be nil.")
            XCTAssertNil(error, "Error should be nil.")
            
            XCTAssertTrue(result?.count == 2)
            
            let firstResult = result?[0]
            let secondResult = result?[1]
            
            XCTAssertEqual(firstResult?.countryName, "United States")
            XCTAssertEqual(firstResult?.countryCode, "US")
            XCTAssertEqual(firstResult?.latitude, 37.7898)
            XCTAssertEqual(firstResult?.longitude, -122.3942)
            XCTAssertEqual(firstResult?.organization, "Wikimedia Foundation")
            XCTAssertEqual(firstResult?.ip, "208.80.152.201")
            
            XCTAssertEqual(secondResult?.as, "AS43821 WIKIMEDIA-EU")
            XCTAssertEqual(secondResult?.city, "Amsterdam")
            XCTAssertEqual(secondResult?.countryName, "Holanda")
            XCTAssertEqual(secondResult?.countryCode, "NL")
            XCTAssertEqual(secondResult?.isp, "Wikimedia-eu")
            XCTAssertEqual(secondResult?.latitude, 52.3702)
            XCTAssertEqual(secondResult?.longitude, 4.89517)
            XCTAssertEqual(secondResult?.organization, "Wikimedia-eu")
            XCTAssertEqual(secondResult?.ip, "91.198.174.192")
            XCTAssertEqual(secondResult?.regionCode, "NH")
            XCTAssertEqual(secondResult?.regionName, "Holanda Septentrional")
            XCTAssertEqual(secondResult?.status, .success)
            XCTAssertEqual(secondResult?.timezone, "Europe/Amsterdam")
            XCTAssertEqual(secondResult?.zipCode, "")
        }
    }
    
    func testFailed()
    {
        OHHTTPStubs.stubRequests(passingTest: { request in
            request.url?.path == "/json/failed.lookup"
        }) { _ in
            return OHHTTPStubsResponse(fileAtPath: OHPathForFile("failed.json", type(of: self))!, statusCode: 200, headers: [:])
        }
        
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
