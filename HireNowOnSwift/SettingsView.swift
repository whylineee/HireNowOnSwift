import SwiftUI

struct SettingsView: View {
    @EnvironmentObject private var appState: AppState
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            Form {
                Section("Language") {
                    Picker("App Language", selection: $appState.language) {
                        ForEach(AppState.AppLanguage.allCases) { lang in
                            Text(lang.rawValue).tag(lang)
                        }
                    }
                }

                Section("Accounts") {
                    HStack {
                        Text("Job Seeker account")
                        Spacer()
                        Image(systemName: appState.hasJobSeekerAccount ? "checkmark.circle.fill" : "xmark.circle")
                            .foregroundStyle(appState.hasJobSeekerAccount ? .green : .gray)
                    }

                    HStack {
                        Text("Employer account")
                        Spacer()
                        Image(systemName: appState.hasEmployerAccount ? "checkmark.circle.fill" : "xmark.circle")
                            .foregroundStyle(appState.hasEmployerAccount ? .green : .gray)
                    }

                    if appState.canSwitchAccounts {
                        Picker("Active account", selection: $appState.activeAccount) {
                            Text("Job Seeker").tag(AppState.AccountType.jobSeeker)
                            Text("Employer").tag(AppState.AccountType.employer)
                        }
                    }
                }

                Section {
                    if !appState.hasEmployerAccount {
                        Button("Create Employer Account") {
                            appState.createEmployerAccount()
                            appState.switchAccount(to: .employer)
                        }
                    }
                }
            }
            .navigationTitle("Settings")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }
}

