//
//  XCTest+Helpers.swift
//  IPAPI
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
//  # Extension
//

extension XCTest
{
    
    @discardableResult public func stub(urlString: String, jsonFileName: String) -> Mockingjay.Stub?
    {
        if let path = Bundle(for: type(of: self)).path(forResource: jsonFileName, ofType: "json"), let data = try? Data(contentsOf: URL(fileURLWithPath: path)) {
            
            return stub(uri(urlString), jsonData(data))
        } else {
            return nil
        }
    }
    
    @discardableResult public func stub(urlString: String, error: NSError) -> Mockingjay.Stub
    {
        return stub(uri(urlString), failure(error))
    }
}
