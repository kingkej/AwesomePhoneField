//
//  File.swift
//  
//
//  Created by kej on 17.04.2022.
//

import Foundation

extension Bundle {
     func getCountries() -> [CountryData] {
           guard let path = Bundle.module.path(forResource: "countryData", ofType: "json"),
                 let data = try? Data(contentsOf: URL(fileURLWithPath: path)) else { return [] }
           return (try? JSONDecoder().decode([CountryData].self, from: data)) ?? []
       }
}
