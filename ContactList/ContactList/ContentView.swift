//
//  ContentView.swift
//  ContactList
//
//  Created by Ioan-Octavian Stanciu on 10.02.2024.
//

import SwiftUI

struct ContentView: View {
    
    // MARK: State objects
    @StateObject private var vm = ContactsViewModel()
    
    // MARK: UI constants
    private let navigationTopBarItemTitle = "Contacte"
    private let sectionName = "CONTACTELE MELE"
    private let initialsFrameSize = 40.0
    private let imageFrameSize = 50.0
    private let textPadding = 5.0
    private let colorOpacity = 0.3
    
    var body: some View {
        NavigationStack {
            List {
                Section(sectionName) {
                    ForEach(vm.contacts, id: \.self) { contact in
                        NavigationLink(value: contact) {
                            HStack {
                                if contact.id % 2 == 0 {
                                    Text("\(self.returnInitialsFrom(name: contact.name))")
                                        .frame(width: initialsFrameSize, height: initialsFrameSize)
                                        .foregroundStyle(.white)
                                        .padding(textPadding)
                                        .background(.gray.opacity(colorOpacity))
                                        .clipShape(Circle())
                                } else {
                                    AsyncImage(url: URL(string: vm.imageURL)) { image in
                                        image
                                            .resizable()
                                            .frame(width: imageFrameSize, height: imageFrameSize)
                                            .clipShape(Circle())
                                    } placeholder: {
                                        ProgressView()
                                    }
                                }
                                Text("\(contact.name)")
                                    .padding(.leading, 2 * textPadding)
                            }
                            .ignoresSafeArea(.container, edges: [.leading])
                        }
                    }
                }
            }
            .navigationDestination(for: PersonModel.self) { person in
                VStack {
                    // View to display more info about the person
                }
                .navigationTitle("\(person.name)")
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Text(navigationTopBarItemTitle)
                        .bold()
                        .font(.title)
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        // TODO: Maybe add a new person?
                    } label: {
                        Image(systemName: "person.fill.badge.plus")
                            .foregroundStyle(.gray)
                    }
                }
            }
        }
        .onAppear {
            vm.fetchContacts()
        }
    }
    
    /// Returns a string with the initials of a person's name.
    /// - Parameter name: String type that contains at least one substring separated only by space.
    /// - Returns: The string that contains only the first characters of each substring.
    private func returnInitialsFrom(name: String) -> String {
        return name.split(separator: " ")
            .map { $0.prefix(1) }
            .joined()
    }
}

#Preview {
    ContentView()
}
