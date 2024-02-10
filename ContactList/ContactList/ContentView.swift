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
            List(vm.contacts) { contact in
                
            }
        }
        .navigationTitle("Contacte")
        .task {
            await vm.fetchContacts()
        }
    }
}

#Preview {
    ContentView()
}
