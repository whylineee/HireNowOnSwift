import SwiftUI

struct ProfileView: View {
    @EnvironmentObject private var store: DataStore

    @State private var showSettings = false
    @State private var showRegisterOther = false
    @State private var registerType: AccountType = .employer
    @State private var showResume = false

    private let accent = Color(red: 0.18, green: 0.18, blue: 0.70)

    private var currentType: AccountType {
        store.activeAccount?.type ?? .jobSeeker
    }

    var body: some View {
        ZStack(alignment: .top) {
            LinearGradient(
                colors: [
                    Color(red: 0.16, green: 0.20, blue: 0.78),
                    Color(red: 0.12, green: 0.12, blue: 0.62)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 0) {
                header

                VStack(alignment: .leading, spacing: 16) {
                    accountCard
                    quickActions
                    sectionTitle("Account")
                    accountOptions
                    sectionTitle("Support")
                    supportOptions
                }
                .padding(.top, 18)
                .padding(.horizontal, 20)
                .padding(.bottom, 120)
                .frame(maxWidth: .infinity)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 26, style: .continuous))
                .padding(.top, 12)

                Spacer()
            }
        }
        .navigationBarHidden(true)
        .sheet(isPresented: $showSettings) {
            SettingsView()
                .environmentObject(store)
        }
        .sheet(isPresented: $showRegisterOther) {
            RegistrationView(lockedType: registerType)
                .environmentObject(store)
        }
        .sheet(isPresented: $showResume) {
            ResumeView()
                .environmentObject(store)
        }
    }

    private var header: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("My Cabinet")
                    .font(.system(size: 26, weight: .bold))
                    .foregroundStyle(.white)

                Text("Manage profile & settings")
                    .font(.system(size: 13))
                    .foregroundStyle(.white.opacity(0.85))
            }

            Spacer()

            Button { showSettings = true } label: {
                Image(systemName: "gearshape.fill")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(.white)
                    .frame(width: 40, height: 40)
                    .background(.white.opacity(0.14))
                    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
            }
        }
        .padding(.horizontal, 16)
        .padding(.top, 10)
        .padding(.bottom, 14)
    }

    private var accountCard: some View {
        HStack(spacing: 14) {
            Image(systemName: currentType == .jobSeeker ? "person.crop.circle.fill" : "briefcase.circle.fill")
                .font(.system(size: 54))
                .foregroundStyle(accent)

            VStack(alignment: .leading, spacing: 4) {
                Text(currentType == .jobSeeker ? "Job Seeker" : "Employer")
                    .font(.system(size: 16, weight: .semibold))
                Text(store.activeAccount?.email ?? "—")
                    .font(.system(size: 12))
                    .foregroundStyle(.gray)
            }

            Spacer()

            if store.hasAccount(type: .jobSeeker) && store.hasAccount(type: .employer) {
                Menu {
                    Button("Job Seeker") { store.switchTo(type: .jobSeeker) }
                    Button("Employer") { store.switchTo(type: .employer) }
                } label: {
                    Image(systemName: "arrow.triangle.2.circlepath")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundStyle(accent)
                        .frame(width: 42, height: 42)
                        .background(accent.opacity(0.12))
                        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                }
            }
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .stroke(Color(.systemGray4), lineWidth: 1)
        )
    }

    private var quickActions: some View {
        HStack(spacing: 12) {
            actionCard(
                title: currentType == .jobSeeker ? "My CV" : "Company",
                subtitle: currentType == .jobSeeker ? "Edit & upload" : "Edit info",
                icon: currentType == .jobSeeker ? "doc.text" : "building.2"
            ) {
                if currentType == .jobSeeker {
                    showResume = true
                }
            }

            actionCard(
                title: "Settings",
                subtitle: "Language & more",
                icon: "gearshape"
            ) { showSettings = true }
        }
    }

    private func actionCard(title: String, subtitle: String, icon: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack(spacing: 12) {
                ZStack {
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .fill(accent.opacity(0.12))
                        .frame(width: 46, height: 46)

                    Image(systemName: icon)
                        .foregroundStyle(accent)
                        .font(.system(size: 18, weight: .semibold))
                }

                VStack(alignment: .leading, spacing: 3) {
                    Text(title)
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(.black)

                    Text(subtitle)
                        .font(.system(size: 12))
                        .foregroundStyle(.gray)
                }

                Spacer()
            }
            .padding(.horizontal, 12)
            .frame(height: 62)
            .background(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .stroke(Color(.systemGray4), lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
    }

    private func sectionTitle(_ text: String) -> some View {
        Text(text)
            .font(.system(size: 14, weight: .semibold))
            .foregroundStyle(accent)
            .padding(.top, 2)
    }

    private var accountOptions: some View {
        VStack(spacing: 10) {
            if currentType == .jobSeeker && !store.hasAccount(type: .employer) {
                optionRow(title: "Register Employer account", icon: "briefcase.fill") {
                    registerType = .employer
                    showRegisterOther = true
                }
            }

            if currentType == .employer && !store.hasAccount(type: .jobSeeker) {
                optionRow(title: "Register Job Seeker account", icon: "person.fill") {
                    registerType = .jobSeeker
                    showRegisterOther = true
                }
            }

            if store.hasAccount(type: .jobSeeker) && store.hasAccount(type: .employer) {
                optionRow(title: "Switch Account", icon: "arrow.left.arrow.right") {
                    store.switchTo(type: currentType == .jobSeeker ? .employer : .jobSeeker)
                }
            }
        }
    }

    private var supportOptions: some View {
        VStack(spacing: 10) {
            optionRow(title: "Help Center", icon: "questionmark.circle") { }
            optionRow(title: "Privacy", icon: "lock.shield") { }
        }
    }

    private func optionRow(title: String, icon: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Circle()
                    .fill(accent.opacity(0.14))
                    .frame(width: 42, height: 42)
                    .overlay(
                        Image(systemName: icon)
                            .foregroundStyle(accent)
                            .font(.system(size: 16, weight: .semibold))
                    )

                Text(title)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(.black)

                Spacer()

                Image(systemName: "chevron.right")
                    .foregroundStyle(.gray.opacity(0.7))
                    .font(.system(size: 14, weight: .semibold))
            }
            .padding(.horizontal, 12)
            .frame(height: 62)
            .background(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .stroke(Color(.systemGray4), lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
    }
}

