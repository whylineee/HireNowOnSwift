import SwiftUI
import Combine

final class AppState: ObservableObject {

    enum AccountType: String, CaseIterable, Identifiable {
        case jobSeeker = "Job Seeker"
        case employer = "Employer"
        var id: String { rawValue }
    }

    enum AppLanguage: String, CaseIterable, Identifiable {
        case uk = "Українська"
        case en = "English"
        var id: String { rawValue }
    }

    @Published var language: AppLanguage = .uk
    @Published var hasJobSeekerAccount: Bool = true
    @Published var hasEmployerAccount: Bool = false
    @Published var activeAccount: AccountType = .jobSeeker

    var canSwitchAccounts: Bool { hasJobSeekerAccount && hasEmployerAccount }

    func createEmployerAccount() { hasEmployerAccount = true }
    func createJobSeekerAccount() { hasJobSeekerAccount = true }

    func switchAccount(to type: AccountType) {
        if type == .jobSeeker, hasJobSeekerAccount { activeAccount = .jobSeeker }
        if type == .employer, hasEmployerAccount { activeAccount = .employer }
    }
}

