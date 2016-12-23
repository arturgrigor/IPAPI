//
//  Service.swift
//  IPAPI
//
//  Created by Artur Grigor on 22.12.2016.
//  Copyright © 2016 Artur Grigor. All rights reserved.
//

//
//  # Imports
//

import Foundation

//
//  # Class
//

/// ip-api.com provides free usage of its Geo IP API through multiple response formats.
///
/// Our system will automatically ban any IP addresses doing over 150 requests per minute. To unban your IP click [here](http://ip-api.com/docs/unban).
/// You are free to use ip-api.com for non-commercial use. **We do not allow commercial use without prior approval**.
open class Service
{
    
    // MARK: - Types -
    
    public enum Error: Swift.Error
    {
        case invalidURL
        case malformedURL
        case invalidData
    }
    
    public enum Status: String
    {
        case fail
        case success
    }
    
    public enum Field: String
    {
        case `as` = "as"
        case city
        case countryCode
        case countryName = "country"
        case ip = "query"
        case isp
        case latitude = "lat"
        case longitude = "lon"
        case message
        case mobile
        case organization = "org"
        case proxy
        case regionCode = "region"
        case regionName
        case reverse
        case status
        case timezone
        case zipCode = "zip"
        
        public static var all: [Field] {
            return [.`as`, .city, .countryCode, .countryName, .ip, .isp, .latitude, .longitude, .message, .mobile,
                    .organization, .proxy, .regionCode, .regionName, .reverse, .status, .timezone, .zipCode]
        }
    }
    
    public struct Result
    {
        /// AS number and name, separated by space. Example: `"AS15169 Google Inc."`
        public var `as`: String?
        
        /// City. Example: `"Mountain View"`
        public var city: String?
        
        /// Country code short. Example: `"US"`
        public var countryCode: String?
        
        /// Country name. Example: `"United States"`
        public var countryName: String?
        
        /// IP used for the query. Example: `"173.194.67.94"`
        public var ip: String?
        
        /// Internet Service Provider name. Example: `"Google"`
        public var isp: String?
        
        /// Latitude. Example: `37.4192`
        public var latitude: Double?
        
        /// Longitude. Example: `-122.0574`
        public var longitude: Double?
        
        /// Error message. Example: `"reserved range"`
        public var message: String?
        
        /// Mobile (cellular) connection. Example: `true`
        public var mobile: Bool?
        
        /// Organization name. Example: `"Google"`
        public var organization: String?
        
        /// Proxy (anonymous). Example: `true`
        public var proxy: Bool?
        
        /// Region/State code short. Example: `"CA"` or `"10"`
        public var regionCode: String?
        
        /// Region/State name. Example: `"California"`
        public var regionName: String?
        
        /// Reverse DNS of the IP. Example: `"wi-in-f94.1e100.net"`
        public var reverse: String?
        
        /// Status. Example: `success`
        public var status: Status?
        
        /// Timezone. Example: `"America/Los_Angeles"`
        public var timezone: String?
        
        /// Zip code. Example: `"94043"`
        public var zipCode: String?
    }
    
    // MARK: - Properties -
    
    /// Returns the timeout interval of the receiver.
    open var timeoutInterval: TimeInterval
    
    /// Returns the session configuration of the receiver.
    open var configuration: URLSessionConfiguration
    
    // MARK: - Initialization -
    
    /// The default instance of `Service` initialized with default values.
    open static let `default` = Service()
    
    /// Initializes the `Service` instance with the given timeout interval.
    ///
    /// - Parameters:
    ///   - timeoutInterval: The timeout interval.
    ///   - configuration: The session configuration.
    ///
    /// - Returns: The new `Service` instance.
    public init(timeoutInterval: TimeInterval = 15,
                configuration: URLSessionConfiguration = URLSessionConfiguration.default)
    {
        self.timeoutInterval = timeoutInterval
        self.configuration = configuration
    }
    
    // MARK: - Methods -
    
    /// Lookup an IP address or domain.
    ///
    /// - Parameters:
    ///   - query: The IP address or domain to lookup. Use `nil` to lookup the current IP address.
    ///   - fields: If you don't require all the returned fields use this property to specify which fields to return.
    ///   - language: Localized `city`, `regionName` and `countryName` can be requested by using this property in the `ISO 639` format.
    ///   - completion: A closure that will be called upon completion.
    /// - Returns: The new `URLSessionDataTask` instance.
    @discardableResult open func fetch(query: String? = nil, fields: [Field]? = nil, language: String? = nil, completion: ((_ result: Result?, _ error: Swift.Error?) -> Void)?) -> URLSessionDataTask?
    {
        var urlString = "http://ip-api.com/json"
        if let query = query {
            urlString += "/\(query)"
        }
        
        guard var urlComponents = URLComponents(string: urlString) else {
            completion?(nil, Error.invalidURL)
            return nil
        }
        
        var queryItems: [URLQueryItem] = []
        
        if let fields = fields {
            queryItems.append(URLQueryItem(name: "fields", value: fields.map({ $0.rawValue }).joined(separator: ",")))
        }
        if let language = language {
            queryItems.append(URLQueryItem(name: "lang", value: language))
        }
        
        urlComponents.queryItems = queryItems
        
        guard let url = urlComponents.url else {
            completion?(nil, Error.malformedURL)
            return nil
        }
        
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: self.timeoutInterval)
        let config = self.configuration
        let session = URLSession(configuration: config)
        
        let task = session.dataTask(with: request, completionHandler: { data, response, error in
            if let error = error {
                completion?(nil, error)
            } else {
                if let data = data, let object = try? JSONSerialization.jsonObject(with: data, options: []), let json = object as? Result.JSON {
                    let result = Result(json: json)
                    completion?(result, nil)
                } else {
                    completion?(nil, Error.invalidData)
                }
            }
        })
        task.resume()
        
        return task
    }
    
}

//
//  # JSON Extension
//

public extension Service.Result
{
    
    // MARK: - Types -
    
    typealias JSON = [String: AnyObject]
    
    // MARK: - Deserialization -
    
    init?(json: JSON)
    {
        let statusString = json[Service.Field.status.rawValue] as? String
        
        self.`as`           = json[Service.Field.`as`.rawValue] as? String
        self.city           = json[Service.Field.city.rawValue] as? String
        self.countryCode    = json[Service.Field.countryCode.rawValue] as? String
        self.countryName    = json[Service.Field.countryName.rawValue] as? String
        self.ip             = json[Service.Field.ip.rawValue] as? String
        self.isp            = json[Service.Field.isp.rawValue] as? String
        self.latitude       = json[Service.Field.latitude.rawValue] as? Double
        self.longitude      = json[Service.Field.longitude.rawValue] as? Double
        self.message        = json[Service.Field.message.rawValue] as? String
        self.mobile         = json[Service.Field.mobile.rawValue] as? Bool
        self.organization   = json[Service.Field.organization.rawValue] as? String
        self.proxy          = json[Service.Field.proxy.rawValue] as? Bool
        self.regionCode     = json[Service.Field.regionCode.rawValue] as? String
        self.regionName     = json[Service.Field.regionName.rawValue] as? String
        self.reverse        = json[Service.Field.reverse.rawValue] as? String
        self.timezone       = json[Service.Field.timezone.rawValue] as? String
        self.zipCode        = json[Service.Field.zipCode.rawValue] as? String
        
        if let statusString = statusString {
            self.status = Service.Status(rawValue: statusString)
        }
    }
    
    // MARK: - Serialization -
    
    func toJSON() -> JSON
    {
        var ret: JSON = [:]
        
        ret[Service.Field.`as`.rawValue]            = self.`as` as AnyObject?
        ret[Service.Field.city.rawValue]            = self.city as AnyObject?
        ret[Service.Field.countryCode.rawValue]     = self.countryCode as AnyObject?
        ret[Service.Field.countryName.rawValue]     = self.countryName as AnyObject?
        ret[Service.Field.ip.rawValue]              = self.ip as AnyObject?
        ret[Service.Field.isp.rawValue]             = self.isp as AnyObject?
        ret[Service.Field.latitude.rawValue]        = self.latitude as AnyObject?
        ret[Service.Field.longitude.rawValue]       = self.longitude as AnyObject?
        ret[Service.Field.message.rawValue]         = self.message as AnyObject?
        ret[Service.Field.mobile.rawValue]          = self.mobile as AnyObject?
        ret[Service.Field.organization.rawValue]    = self.organization as AnyObject?
        ret[Service.Field.proxy.rawValue]           = self.proxy as AnyObject?
        ret[Service.Field.regionCode.rawValue]      = self.regionCode as AnyObject?
        ret[Service.Field.regionName.rawValue]      = self.regionName as AnyObject?
        ret[Service.Field.reverse.rawValue]         = self.reverse as AnyObject?
        ret[Service.Field.status.rawValue]          = self.status as AnyObject?
        ret[Service.Field.timezone.rawValue]        = self.timezone as AnyObject?
        ret[Service.Field.zipCode.rawValue]         = self.zipCode as AnyObject?
        
        return ret
    }
    
}

//
//  # Debug Extension
//

public extension Service.Result
{
    
    var description: String {
        return self.toJSON().description
    }
    
}
