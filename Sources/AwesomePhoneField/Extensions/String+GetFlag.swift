//
//  File.swift
//  
//
//  Created by kej on 17.04.2022.
//

import Foundation
public extension String {
    /// Returns String unicode value of country flag for iso code
    func getFlag() -> String {
        unicodeScalars
            .map { 127_397 + $0.value }
            .compactMap(UnicodeScalar.init)
            .map(String.init)
            .joined()
    }
}
