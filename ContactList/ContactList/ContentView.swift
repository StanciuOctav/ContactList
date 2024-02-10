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
                        HStack {
                            //                    if contact.id % 2 == 0 {
                            Text("\(contact.name)")
                            //                    } else {
                            //                        Text("\(contact.email)")
                            //                    }
                        }
                    }
                }
            }
            .navigationTitle("Contacte")
            .navigationBarTitleDisplayMode(.large)
        }
        .task {
            await vm.fetchContacts()
        }
    }
}

#Preview {
    ContentView()
}
