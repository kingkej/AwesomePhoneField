//
//  File.swift
//  
//
//  Created by kej on 17.04.2022.
//

import Foundation
import IsoCountryCodes

public struct CountryData: Codable, Identifiable {
     public var id: String {
        return "id\(isoCode)"
    }
    public var isoCode: String
    public var phoneCode: String
    
    public var localizedName: String {
        guard let localized = IsoCountryCodes.find(key: isoCode) else {
            return isoCode
        }
        return localized.name
    }
    
    public init(isoCode: String, phoneCode: String) {
        self.isoCode = isoCode
        self.phoneCode = phoneCode
    }
    public init() {
        self.isoCode = ""
        self.phoneCode = ""
    }
}
