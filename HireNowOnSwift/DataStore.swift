import SwiftUI
import Combine

// MARK: - Models

enum AccountType: String, Codable, CaseIterable, Identifiable {
    case jobSeeker
    case employer
    var id: String { rawValue }
}

struct Account: Codable, Equatable {
    var username: String
    var email: String
    var phone: String
    var password: String
    var type: AccountType
}

struct Vacancy: Codable, Identifiable, Equatable {
    var id: UUID = UUID()
    var title: String
    var company: String
    var location: String
    var isRemote: Bool
    var createdAt: Date = Date()
}

struct Resume: Codable, Equatable {
    var fullName: String
    var about: String
    var skills: String
}

struct Application: Codable, Identifiable, Equatable {
    var id: UUID = UUID()
    var vacancyId: UUID
    var applicantEmail: String
    var message: String
    var createdAt: Date = Date()
}

// MARK: - DataStore

final class DataStore: ObservableObject {
    @Published private(set) var accounts: [Account] = []
    @Published private(set) var activeAccount: Account? = nil

    @Published private(set) var vacancies: [Vacancy] = []
    @Published private(set) var resumesByEmail: [String: Resume] = [:]
    @Published private(set) var applications: [Application] = []

    private var baseURL: URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }

    private var accountsURL: URL { baseURL.appendingPathComponent("accounts.json") }
    private var vacanciesURL: URL { baseURL.appendingPathComponent("vacancies.json") }
    private var resumesURL: URL { baseURL.appendingPathComponent("resumes.json") }
    private var applicationsURL: URL { baseURL.appendingPathComponent("applications.json") }

    init() {
        loadAll()
        if activeAccount == nil { activeAccount = accounts.first }
    }

    // MARK: Accounts

    func hasAccount(type: AccountType) -> Bool {
        accounts.contains { $0.type == type }
    }

    func register(username: String, email: String, phone: String, password: String, type: AccountType) -> Bool {
        let e = email.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()

        if accounts.contains(where: { $0.email == e && $0.type == type }) {
            return false
        }

        let acc = Account(username: username, email: e, phone: phone, password: password, type: type)
        accounts.append(acc)
        activeAccount = acc
        saveAccounts()
        return true
    }

    func switchTo(type: AccountType) {
        guard let acc = accounts.first(where: { $0.type == type }) else { return }
        activeAccount = acc
    }

    // MARK: Employer

    func addVacancy(title: String, company: String, location: String, isRemote: Bool) {
        vacancies.insert(
            Vacancy(title: title, company: company, location: location, isRemote: isRemote),
            at: 0
        )
        saveVacancies()
    }

    // MARK: Job Seeker

    func upsertResume(_ resume: Resume) {
        guard let email = activeAccount?.email else { return }
        resumesByEmail[email] = resume
        saveResumes()
    }

    func myResume() -> Resume? {
        guard let email = activeAccount?.email else { return nil }
        return resumesByEmail[email]
    }

    func apply(to vacancy: Vacancy, message: String) {
        guard let email = activeAccount?.email else { return }
        applications.insert(
            Application(vacancyId: vacancy.id, applicantEmail: email, message: message),
            at: 0
        )
        saveApplications()
    }

    // MARK: Persistence

    private func loadAll() {
        accounts = load(from: accountsURL, defaultValue: [])
        vacancies = load(from: vacanciesURL, defaultValue: [])
        resumesByEmail = load(from: resumesURL, defaultValue: [:])
        applications = load(from: applicationsURL, defaultValue: [])
    }

    private func saveAccounts() { save(accounts, to: accountsURL) }
    private func saveVacancies() { save(vacancies, to: vacanciesURL) }
    private func saveResumes() { save(resumesByEmail, to: resumesURL) }
    private func saveApplications() { save(applications, to: applicationsURL) }

    private func save<T: Encodable>(_ value: T, to url: URL) {
        do {
            let data = try JSONEncoder().encode(value)
            try data.write(to: url, options: [.atomic])
        } catch {
            print("Save error:", error)
        }
    }

    private func load<T: Decodable>(from url: URL, defaultValue: T) -> T {
        do {
            let data = try Data(contentsOf: url)
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            return defaultValue
        }
    }
}

