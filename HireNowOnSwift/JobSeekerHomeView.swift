import SwiftUI

struct JobSeekerHomeView: View {
    @EnvironmentObject private var store: DataStore

    var body: some View {
        NavigationStack {
            List {
                ForEach(store.vacancies) { v in
                    NavigationLink {
                        VacancyDetailsView(vacancy: v)
                    } label: {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(v.title).font(.headline)
                            Text("\(v.company) • \(v.location)\(v.isRemote ? " • Remote" : "")")
                                .font(.subheadline)
                                .foregroundStyle(.gray)
                        }
                    }
                }
            }
            .navigationTitle("JobS")
        }
    }
}

struct VacancyDetailsView: View {
    @EnvironmentObject private var store: DataStore
    let vacancy: Vacancy

    @State private var message = ""
    @State private var applied = false

    var body: some View {
        Form {
            Section("Vacancy") {
                Text(vacancy.title).font(.headline)
                Text(vacancy.company)
                Text(vacancy.location)
                if vacancy.isRemote { Text("Remote") }
            }

            Section("Apply") {
                TextField("Message to employer", text: $message, axis: .vertical)
                Button(applied ? "Applied" : "Apply") {
                    store.apply(to: vacancy, message: message)
                    applied = true
                }
                .disabled(applied || message.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            }
        }
        .navigationTitle("Details")
    }
}
