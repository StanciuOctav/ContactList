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
    
    // MARK: Public methods
    func fetchContacts() {
        // Eventually, we should first check if we already have cached contacts.
        // YES => we compare the cached ones to see if there are any differences compared to the ones from the request => if there are any differences, we need to update the cached ones, if not we just use the cached ones so we don't need to cache the same ones again
        // NO => just execute the code from the receiveValue block
        self.fetchContactsPublisher()?
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in }) { [weak self] contacts in
                self?.contacts = contacts.compactMap({ $0.isInactive ? nil : $0 })
                self?.cacheContacts()
            }
            .store(in: &cancellables)
    }
    
    // MARK: Private methods
    private func fetchContactsPublisher() -> AnyPublisher<[PersonModel], Error>? {
        guard let url = URL(string: contactsUrlString) else { return nil }
        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: [PersonModel].self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
    
    private func cacheContacts() {
        if let cacheData = try? PropertyListEncoder().encode(contacts) {
            UserDefaults.standard.set(cacheData, forKey: contactsKey)
        }
    }
}
