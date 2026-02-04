import SwiftUI

struct ProfileView: View {
    @EnvironmentObject private var appState: AppState
    @State private var showSettings = false

    private let accent = Color(red: 0.18, green: 0.18, blue: 0.70)

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
                .padding(.bottom, 120) // щоб не перекрив таббар
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
                .environmentObject(appState)
        }
    }

    // MARK: Header
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

            Button {
                showSettings = true
            } label: {
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

    // MARK: Account Card
    private var accountCard: some View {
        HStack(spacing: 14) {
            Image(systemName: "person.crop.circle.fill")
                .font(.system(size: 54))
                .foregroundStyle(accent)

            VStack(alignment: .leading, spacing: 4) {
                Text(appState.activeAccount == .jobSeeker ? "Job Seeker" : "Employer")
                    .font(.system(size: 16, weight: .semibold))

                Text(appState.language == .uk ? "Мова: Українська" : "Language: English")
                    .font(.system(size: 12))
                    .foregroundStyle(.gray)
            }

            Spacer()

            if appState.canSwitchAccounts {
                Menu {
                    Button("Job Seeker") { appState.switchAccount(to: .jobSeeker) }
                    Button("Employer") { appState.switchAccount(to: .employer) }
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
                title: appState.activeAccount == .jobSeeker ? "My CV" : "Company",
                subtitle: appState.activeAccount == .jobSeeker ? "Edit & upload" : "Edit info",
                icon: appState.activeAccount == .jobSeeker ? "doc.text" : "building.2"
            ) {}

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
            // Create employer account button (only if missing)
            if !appState.hasEmployerAccount {
                optionRow(title: "Create Employer Account", icon: "briefcase.fill") {
                    appState.createEmployerAccount()
                    appState.switchAccount(to: .employer)
                }
            }

            // Create job seeker account button (if missing)
            if !appState.hasJobSeekerAccount {
                optionRow(title: "Create Job Seeker Account", icon: "person.fill") {
                    appState.createJobSeekerAccount()
                    appState.switchAccount(to: .jobSeeker)
                }
            }

            // Switch accounts row (only if both exist)
            if appState.canSwitchAccounts {
                optionRow(title: "Switch Account", icon: "arrow.left.arrow.right") {
                    appState.switchAccount(to: appState.activeAccount == .jobSeeker ? .employer : .jobSeeker)
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

#Preview {
    ProfileView()
}
