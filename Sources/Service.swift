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
    
    /// This is the error type returned by IPAPI.
    public enum Error: Swift.Error
    {
        /// Returned when the `URLComponents` structure fails to initialize, most likely because of the `query` parameter.
        case invalidURL
        /// Return when the `URLComponents` structure fails to create a valid `URL`.
        case malformedURL
        /// Returned when the request data is invalid.
        case invalidRequestData
        /// Returned when the server response contained invalid data.
        case invalidResponseData
    }
    
    /// This is the status type returned by IPAPI.
    public enum Status: String, Codable
    {
        /// Returned when the server is unable to process the request.
        case fail
        /// Returned when the request has succeeded.
        case success
    }
    
    /// This is the result type returned by IPAPI.
    public struct Result: Codable
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
        
        /// This is the field type used by the IPAPI service to filter out unnecessary data.
        public enum CodingKeys: String, CodingKey {
            /// AS number and name.
            case `as` = "as"
            /// City.
            case city
            /// Country code short.
            case countryCode
            /// Country name.
            case countryName = "country"
            /// IP.
            case ip = "query"
            /// Internet Service Provider name.
            case isp
            /// Latitude.
            case latitude = "lat"
            /// Longitude.
            case longitude = "lon"
            /// Error message.
            case message
            /// Mobile (cellular) connection.
            case mobile
            /// Organization name.
            case organization = "org"
            /// Proxy (anonymous).
            case proxy
            /// Region/State code short.
            case regionCode = "region"
            /// Region/State name.
            case regionName
            /// Reverse DNS of the IP.
            case reverse
            /// Status.
            case status
            /// Timezone.
            case timezone
            /// Zip code.
            case zipCode = "zip"
            
            /// Returns an `Array` with all the fields.
            public static var all: [CodingKeys] {
                return [.`as`, .city, .countryCode, .countryName, .ip, .isp, .latitude, .longitude, .message, .mobile,
                        .organization, .proxy, .regionCode, .regionName, .reverse, .status, .timezone, .zipCode]
            }
        }
        
        /// This is the typical JSON type used by webservices.
        public typealias Field = CodingKeys
    }
    
    /// This is the request type used by the `batch` method.
    public struct Request
    {
        /// The IP address to lookup. This parameter is required.
        public var query: String
        /// If you don't require all the returned fields use this property to specify which fields to return. *Tip: Disabling* `reverse` *may improve performance*. This parameter is optional.
        public var fields: [Result.Field]? = nil
        /// Localized `city`, `regionName` and `countryName` can be requested by using this property in the `ISO 639` format. This parameter is optional.
        public var language: String? = nil
        
        // MARK: - Initialization -
        
        /// Initializes the `Request` instance with the given parameters.
        ///
        /// - Parameters:
        ///   - query: The IP address to lookup.
        ///   - fields: The fields to return.
        ///   - language: The language to use for the city, region and country names.
        ///
        /// - Returns: The new `Request` instance.
        init(query: String, fields: [Result.Field]? = nil, language: String? = nil) {
            self.query = query
            self.fields = fields
            self.language = language
        }
    }
    
    /// This is the typical JSON type used by webservices.
    public typealias JSON = [String: AnyObject]
    
    // MARK: - Constants -
    
    /// The base URL string for the webservice.
    static let baseURLString = "http://ip-api.com"
    
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
    ///   - fields: If you don't require all the returned fields use this property to specify which fields to return. *Tip: Disabling* `reverse` *may improve performance*.
    ///   - language: Localized `city`, `regionName` and `countryName` can be requested by using this property in the `ISO 639` format.
    ///   - completion: A closure that will be called upon completion.
    /// - Returns: The new `URLSessionDataTask` instance.
    @discardableResult open func fetch(query: String? = nil, fields: [Result.Field]? = nil, language: String? = nil, completion: ((_ result: Result?, _ error: Swift.Error?) -> Void)?) -> URLSessionDataTask?
    {
        var urlString = "\(type(of: self).baseURLString)/json"
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
                let decoder = JSONDecoder()
                if let data = data, let result = try? decoder.decode(Result.self, from: data) {
                    completion?(result, nil)
                } else {
                    completion?(nil, Error.invalidResponseData)
                }
            }
        })
        task.resume()
        
        return task
    }
    
    /// Lookup multiple IP addresses in one request. You can supply up to `100` queries per batch request.
    ///
    /// - Note: This mode does not support hostname/domain or rDNS lookups.
    ///
    /// - Parameters:
    ///   - queries: The requests.
    ///   - completion: A closure that will be called upon completion.
    /// - Returns: The new `URLSessionDataTask` instance.
    @discardableResult open func batch(_ queries: [Request], completion: ((_ result: [Result]?, _ error: Swift.Error?) -> Void)?) -> URLSessionDataTask?
    {
        let urlString = "\(type(of: self).baseURLString)/batch"
        guard let urlComponents = URLComponents(string: urlString) else {
            completion?(nil, Error.invalidURL)
            return nil
        }
        
        guard let url = urlComponents.url else {
            completion?(nil, Error.malformedURL)
            return nil
        }
        
        let body = queries.map { $0.toJSON() }
        guard let jsonBody = try? JSONSerialization.data(withJSONObject: body, options: []) else {
            completion?(nil, Error.invalidRequestData)
            return nil
        }
        
        var request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: self.timeoutInterval)
        request.httpMethod = "POST"
        request.httpBody = jsonBody
        let config = self.configuration
        let session = URLSession(configuration: config)
        
        let task = session.dataTask(with: request, completionHandler: { data, response, error in
            if let error = error {
                completion?(nil, error)
            } else {
                let decoder = JSONDecoder()
                if let data = data, let result = try? decoder.decode([Result].self, from: data) {
                    completion?(result, nil)
                } else {
                    completion?(nil, Error.invalidResponseData)
                }
            }
        })
        task.resume()
        
        return task
    }
    
}

//
//  # Request: JSON Extension
//

public extension Service.Request
{
    
    // MARK: - Types -
    
    fileprivate enum JSONKey: String
    {
        /// Query.
        case query
        /// Fields.
        case fields
        /// Language.
        case language = "lang"
    }
    
    // MARK: - Deserialization -
    
    /// Initializes the `Request` instance with a given JSON object.
    ///
    /// - Parameters:
    ///   - json: The JSON object.
    ///
    /// - Returns: The new `Result` instance.
    init?(json: Service.JSON)
    {
        if let query = json[Service.Request.JSONKey.query.rawValue] as? String {
            self.query      = query
            self.language   = json[Service.Request.JSONKey.language.rawValue] as? String
            
            if let string = json[Service.Request.JSONKey.fields.rawValue] as? String {
                let fields = string.components(separatedBy: ",")
                self.fields = fields.flatMap { Service.Result.Field(rawValue: $0) }
            }
        } else {
            return nil
        }
    }
    
    // MARK: - Serialization -
    
    /// Serializes the object to the IPAPI format.
    func toJSON() -> Service.JSON
    {
        var ret: Service.JSON = [:]
        
        ret[Service.Request.JSONKey.query.rawValue]     = self.query as AnyObject?
        ret[Service.Request.JSONKey.fields.rawValue]    = self.fields?.map { $0.rawValue }.joined(separator: ",") as AnyObject?
        ret[Service.Request.JSONKey.language.rawValue]  = self.language as AnyObject?
        
        return ret
    }
    
}
