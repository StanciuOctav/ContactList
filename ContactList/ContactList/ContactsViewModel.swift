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
        let urlString: String = "https://gorest.co.in/public/v2/users"
        guard let url = URL(string: urlString) else { return }
        if let contactsData = try? Data(contentsOf: url) {
            if let jsonContacts = try? JSONDecoder().decode([PersonModel].self, from: contactsData) {
                DispatchQueue.main.async { [weak self] in
                    guard let self else { return }
                    self.contacts = jsonContacts.compactMap({ $0.isInactive ? nil : $0 })
                }
            }
        }
    }
}
