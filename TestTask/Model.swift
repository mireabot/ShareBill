//
//  Model.swift
//  TestTask
//
//  Created by Mikhail Kolkov  on 25.02.2021.
//

import Foundation
import SwiftUI

struct User : Codable, Identifiable {
    let id = UUID()
    let access_token : String
}
