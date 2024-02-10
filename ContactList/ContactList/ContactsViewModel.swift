//
//  ContactsViewModel.swift
//  ContactList
//
//  Created by Ioan-Octavian Stanciu on 10.02.2024.
//

import SwiftUI

final class ContactsViewModel: ObservableObject {
    
    @Published var contacts: [PersonModel] = []
    
    func fetchContacts() async {
        
    }
}
