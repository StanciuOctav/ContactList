//
//  ContentView.swift
//  ContactList
//
//  Created by Ioan-Octavian Stanciu on 10.02.2024.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject private var vm = ContactsViewModel()
    
    var body: some View {
        NavigationStack {
            List {
                Section("CONTACTELE MELE") {
                    ForEach(vm.contacts, id: \.self) { contact in
                        NavigationLink(value: contact) {
                            HStack {
                                if contact.id % 2 == 0 {
                                    Text("\(self.returnNameInitialsFrom(name: contact.name))")
                                        .frame(width: 40, height: 40)
                                        .foregroundStyle(.white)
                                        .padding(5)
                                        .background(.gray.opacity(0.3))
                                        .clipShape(Circle())
                                } else {
                                    AsyncImage(url: URL(string: vm.imageURL)) { image in
                                        image
                                            .resizable()
                                            .frame(width: 50, height: 50)
                                            .clipShape(Circle())
                                    } placeholder: {
                                        ProgressView()
                                    }
                                }
                                Text("\(contact.name)")
                                    .padding(.leading, 10)
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
                    Text("Contacte")
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
        .task {
            await vm.fetchContacts()
        }
    }
    
    private func returnNameInitialsFrom(name: String) -> String {
        return name.split(separator: " ")
            .map { $0.prefix(1) }
            .joined()
    }
}

#Preview {
    ContentView()
}
