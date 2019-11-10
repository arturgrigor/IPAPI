[![SwiftPM compatible](https://img.shields.io/badge/SPM-compatible-4BC51D.svg?style=flat)](https://swift.org/package-manager)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![Build Status](https://travis-ci.org/arturgrigor/IPAPI.svg?branch=master)](https://travis-ci.org/arturgrigor/IPAPI)
[![CocoaPods Compatible](https://img.shields.io/cocoapods/v/IPAPI.svg)](https://img.shields.io/cocoapods/v/IPAPI.svg)
[![Platform](https://img.shields.io/cocoapods/p/IPAPI.svg?style=flat)](http://cocoadocs.org/docsets/IPAPIIPAPI)
[![Twitter](https://img.shields.io/badge/twitter-@arturgrigor-blue.svg?style=flat)](http://twitter.com/arturgrigor)

# IPAPI

http://ip-api.com Geolocation API client written in Swift.

## Requirements

- iOS 8.0+ / macOS 10.10+ / tvOS 9.0+ / watchOS 2.0+
- Xcode 10.2+
- Swift 5.1+

## Installation

### Carthage

[Carthage](https://github.com/Carthage/Carthage) is a decentralized dependency manager that builds your dependencies and provides you with binary frameworks.

You can install Carthage with [Homebrew](http://brew.sh/) using the following command:

```bash
$ brew update
$ brew install carthage
```

To integrate IPAPI into your Xcode project using Carthage, specify it in your `Cartfile`:

```ogdl
github "arturgrigor/IPAPI" ~> 2.1
```

Run `carthage update` to build the framework and drag the built `IPAPI.framework` into your Xcode project.

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
    pod 'IPAPI', '~> 2.1'
end
```

Then, run the following command:

```bash
$ pod install
```

### Swift Package Manager

The [Swift Package Manager](https://swift.org/package-manager/) is a tool for automating the distribution of Swift code and is integrated into the `swift` compiler. 

Once you have your Swift package set up, adding IPAPI as a dependency is as easy as adding it to the `dependencies` value of your `Package.swift`.

```swift
dependencies: [
    .Package(url: "https://github.com/arturgrigor/IPAPI.git", majorVersion: 2)
]
```

## Usage

### 🎯 Lookup the current IP address ###

```swift
import IPAPI

IPAPI.Service.default.fetch { result, error in
            if let result = result {
                print("Geo IP result \(result).")
            }
        }
```

### 🔍 Lookup a domain ###

```swift
import IPAPI

Service.default.fetch(query: "apple.com") { result, error in
            if let result = result {
                print("Geo IP result \(result).")
            }
        }
```

### ✂️ Ask only for some specific fields ###

```swift
import IPAPI

Service.default.fetch(fields: [.ip, .latitude, .longitude, .organization]) { result, error in
            if let result = result {
                print("Geo IP result \(result).")
            }
        }
```

### 🇷🇴 Localization ###

```swift
import IPAPI

Service.default.fetch(language: "es") { result, error in
            if let result = result {
                print("Geo IP result \(result).")
            }
        }
```
*Checkout this [page](http://ip-api.com/docs/api:returned_values) for the available languages.

### 📦 Batch request ###

```swift
import IPAPI

Service.default.batch([Service.Request(query: "208.80.152.201",
                                       fields: [.countryName, .countryCode, .latitude, .longitude, .organization, .ip]),
                       Service.Request(query: "91.198.174.192", language: "es")]) { result, error in
            if let result = result {
                print("Geo IP result \(result).")
            }
        }
```

# Contact

- [GitHub](http://github.com/arturgrigor)
- [Twitter](http://twitter.com/arturgrigor)

Let me know if you're using or enjoying this product.
