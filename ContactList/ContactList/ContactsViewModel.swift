//
//  ContactsViewModel.swift
//  ContactList
//
//  Created by Ioan-Octavian Stanciu on 10.02.2024.
//

import SwiftUI

final class ContactsViewModel: ObservableObject {
    
    @Published var contacts: [PersonModel] = []
    let imageURL: String = "https://fastly.picsum.photos/id/553/200/200.jpg?hmac=HSLKzqqoxnajv4KjLxYSjZokWcuCCiZLGdRPUoryhXk"
    private var contactsUrlString: String = "https://gorest.co.in/public/v2/users"
    
    func fetchContacts() async {
        guard let url = URL(string: contactsUrlString) else { return }
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
