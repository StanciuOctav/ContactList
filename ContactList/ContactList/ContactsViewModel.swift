//
//  ContactsViewModel.swift
//  ContactList
//
//  Created by Ioan-Octavian Stanciu on 10.02.2024.
//

import Combine
import Foundation
import SwiftUI

final class ContactsViewModel: ObservableObject {
    
    // MARK: Published properties
    @Published var contacts: [PersonModel] = []
    
    // MARK: Public constants
    let imageURL: String = "https://fastly.picsum.photos/id/553/200/200.jpg?hmac=HSLKzqqoxnajv4KjLxYSjZokWcuCCiZLGdRPUoryhXk"
    
    // MARK: Private properties
    private var cancellables = Set<AnyCancellable>()
    private let contactsUrlString: String = "https://gorest.co.in/public/v2/users"
    private let contactsKey: String = "contacts"
    
    // MARK: Private methods
    private func fetchContactsPublisher() -> AnyPublisher<[PersonModel], Error>? {
        guard let url = URL(string: contactsUrlString) else { return nil }
        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: [PersonModel].self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
    
    // MARK: Public methods
    func fetchContacts() {
        self.fetchContactsPublisher()?
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in }) { contacts in
                self.contacts = contacts.compactMap({ $0.isInactive ? nil : $0 })
            }
            .store(in: &cancellables)
    }
}
