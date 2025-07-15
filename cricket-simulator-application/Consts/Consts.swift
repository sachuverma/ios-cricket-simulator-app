//
//  teams-data.swift
//  cricket-simulator-application
//
//  Created by Sachin Verma on 02/07/25.
//

import Foundation
import UIKit

public struct TeamDetail: Codable {
    let name: String
    let flagURL: String

    enum CodingKeys: String, CodingKey {
        case name
        case flagURL = "flag"
    }
}

public class Consts {
    static private let jsonData = """
    [
        {
            "name": "Afghanistan",
            "flag": "https://img.cricketworld.com/images/d-046469/afghanistan.jpg"
        },
        {
            "name": "Australia",
            "flag": "https://img.cricketworld.com/images/d-046471/australia.jpg"
        },
        {
            "name": "Bangladesh",
            "flag": "https://img.cricketworld.com/images/d-046472/bangladesh.jpg"
        },
        {
            "name": "England",
            "flag": "https://img.cricketworld.com/images/d-046473/england.jpg"
        },
        {
            "name": "India",
            "flag": "https://img.cricketworld.com/images/d-046474/india.jpg"
        },
        {
            "name": "New Zealand",
            "flag": "https://img.cricketworld.com/images/d-046475/new-zealand.jpg"
        },
        {
            "name": "Pakistan",
            "flag": "https://img.cricketworld.com/images/d-046488/pakistan.jpg"
        },
        {
            "name": "South Africa",
            "flag": "https://img.cricketworld.com/images/d-046477/south-africa.jpg"
        },
        {
            "name": "Sri Lanka",
            "flag": "https://img.cricketworld.com/images/d-046478/sri-lanka.jpg"
        },
        {
            "name": "West Indies",
            "flag": "https://img.cricketworld.com/images/d-046479/west-indies.jpg"
        }
    ]
    """.data(using: .utf8)!

    
    static let greenColor = UIColor(red: 6.0/255.0, green: 89.0/255.0, blue: 10.0/255.0, alpha: 1.0)

    static func fetchTeamsData() -> [TeamDetail]? {
        do {
            let teams = try JSONDecoder().decode([TeamDetail].self, from: jsonData)
            return teams
        } catch {
            print("Decoding failed: \(error)")
            return nil
        }
    }
}
