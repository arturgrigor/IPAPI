//
//  ContentView.swift
//  Demo iOS
//
//  Created by Artur Grigor on 17/07/2020.
//  Copyright © 2020 Artur Grigor. All rights reserved.
//

import SwiftUI
import IPAPI

enum Data {
    case none
    case loading
    case result(Swift.Result<IPAPI.Service.Result, Swift.Error>)
    
    var text: String {
        switch self {
            case .none: return ""
            case .loading: return "Loading..."
            case .result(let innerResult):
            switch innerResult {
                case .failure(let error): return error.localizedDescription
                case .success(let apiResult): return String(describing: apiResult)
            }
        }
    }
}

struct ContentView: View {
    static let pricingPlan: IPAPI.Service.PricingPlan = .free
//    static let pricingPlan: IPAPI.Service.PricingPlan = .pro(apiKey: "test-demo-pro"); #warning("Set your own API Key")
    
    @State private var data: Data = .none
    private let service = IPAPI.Service(pricingPlan: Self.pricingPlan)
    
    var body: some View {
        VStack {
            Text(self.data.text)
                .padding(.all)
                .multilineTextAlignment(.center)
                .lineLimit(nil)
        }.onAppear(perform: loadData)
    }
    
    func loadData() {
        self.data = .loading
        self.service.fetch {
            self.data = .result($0)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            ContentView()
        }
    }
}
