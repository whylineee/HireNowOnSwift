import SwiftUI

struct EmployerHomeView: View {
    @EnvironmentObject private var store: DataStore
    @State private var showCreate = false

    var body: some View {
        NavigationStack {
            List {
                ForEach(store.vacancies) { v in
                    VStack(alignment: .leading, spacing: 4) {
                        Text(v.title).font(.headline)
                        Text("\(v.company) • \(v.location)\(v.isRemote ? " • Remote" : "")")
                            .font(.subheadline)
                            .foregroundStyle(.gray)
                    }
                }
            }
            .navigationTitle("Employer")
            .toolbar {
                Button { showCreate = true } label: {
                    Image(systemName: "plus.circle.fill")
                }
            }
            .sheet(isPresented: $showCreate) {
                CreateVacancyView()
                    .environmentObject(store)
            }
        }
    }
}

struct CreateVacancyView: View {
    @EnvironmentObject private var store: DataStore
    @Environment(\.dismiss) private var dismiss

    @State private var title = ""
    @State private var company = ""
    @State private var location = ""
    @State private var isRemote = true

    var body: some View {
        NavigationStack {
            Form {
                TextField("Title", text: $title)
                TextField("Company", text: $company)
                TextField("Location", text: $location)
                Toggle("Remote", isOn: $isRemote)
            }
            .navigationTitle("New vacancy")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) { Button("Cancel") { dismiss() } }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save") {
                        store.addVacancy(title: title, company: company, location: location, isRemote: isRemote)
                        dismiss()
                    }
                    .disabled(title.isEmpty || company.isEmpty || location.isEmpty)
                }
            }
        }
    }
}
