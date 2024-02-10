//
//  PersonModel.swift
//  ContactList
//
//  Created by Ioan-Octavian Stanciu on 10.02.2024.
//

import SwiftUI

struct PersonModel: Codable, Identifiable, Hashable {
    var id: Int = 0
    var name: String = ""
    var email: String = ""
    var gender: String = ""
    var status: String = ""
    var isInactive: Bool {
        get { status == "inactive" }
    }
}
