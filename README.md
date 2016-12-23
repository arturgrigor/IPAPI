[![CocoaPods Compatible](https://img.shields.io/cocoapods/v/IPAPI.svg)](https://img.shields.io/cocoapods/v/IPAPI.svg)
[![Platform](https://img.shields.io/cocoapods/p/IPAPI.svg?style=flat)](http://cocoadocs.org/docsets/IPAPIIPAPI)
[![Twitter](https://img.shields.io/badge/twitter-@arturgrigor-blue.svg?style=flat)](http://twitter.com/arturgrigor)

# IPAPI

http://ip-api.com Geolocation API client written in Swift.

## Requirements

- iOS 8.0+ / macOS 10.10+ / tvOS 9.0+ / watchOS 2.0+
- Xcode 8.0+
- Swift 3.0+

## Installation

### CocoaPods

[CocoaPods](http://cocoapods.org) is a dependency manager for Cocoa projects. You can install it with the following command:

```bash
$ gem install cocoapods
```

> CocoaPods 1.1.0+ is required.

To integrate IPAPI into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '10.0'
use_frameworks!

target '<Your Target Name>' do
    pod 'IPAPI', '~> 1.0'
end
```

Then, run the following command:

```bash
$ pod install
```

## Usage

### Lookup the current IP address ###

```swift
import IPAPI

IPAPI.Service.default.fetch { result, error in
            if let result = result {
                print("Geo IP result \(result).")
            }
        }
```

### Lookup a domain ###

```swift
import IPAPI

Service.default.fetch(query: "apple.com") { result, error in
            if let result = result {
                print("Geo IP result \(result).")
            }
        }
```

### Ask only for some specific fields ###

```swift
import IPAPI

Service.default.fetch(fields: [.ip, .latitude, .longitude, .organization]) { result, error in
            if let result = result {
                print("Geo IP result \(result).")
            }
        }
```

### Localization ###

```swift
import IPAPI

Service.default.fetch(language: "es") { result, error in
            if let result = result {
                print("Geo IP result \(result).")
            }
        }
```
*Checkout this [page](http://ip-api.com/docs/api:returned_values) for the available languages.

# Contact

- [GitHub](http://github.com/arturgrigor)
- [Twitter](http://twitter.com/arturgrigor)

Let me know if you're using or enjoying this product.
