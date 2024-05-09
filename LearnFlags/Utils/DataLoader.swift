//
//  DataLoader.swift
//  LearnFlags
//
//  Created by Mohit Arora on 2024-05-08.
//

import Foundation

struct DataLoader {
    
    static func loadCountries() -> [Country] {
        guard let url = Bundle.main.url(forResource: "countries", withExtension: "json") else {
            print("Countries JSON file not found.")
            return []
        }
        
        do {
            let data = try Data(contentsOf: url)
            let countryDict = try JSONDecoder().decode([String: String].self, from: data)
            return countryDict.map { Country(id: $0.key, name: $0.value) }.sorted(by: { $0.name < $1.name })
        } catch {
            print("Error loading countries: \(error)")
            return []
        }
    }
}
