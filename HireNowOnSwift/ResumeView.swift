import SwiftUI

struct ResumeView: View {
    @EnvironmentObject private var store: DataStore
    @Environment(\.dismiss) private var dismiss

    @State private var fullName = ""
    @State private var about = ""
    @State private var skills = ""

    var body: some View {
        NavigationStack {
            Form {
                Section("Resume") {
                    TextField("Full name", text: $fullName)
                    TextField("About", text: $about, axis: .vertical)
                    TextField("Skills", text: $skills, axis: .vertical)
                }

                Button("Save resume") {
                    store.upsertResume(Resume(fullName: fullName, about: about, skills: skills))
                    dismiss()
                }
                .disabled(fullName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            }
            .navigationTitle("My Resume")
            .onAppear {
                if let r = store.myResume() {
                    fullName = r.fullName
                    about = r.about
                    skills = r.skills
                }
            }
        }
    }
}
