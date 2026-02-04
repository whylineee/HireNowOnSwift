import SwiftUI

struct HomeScreenView: View {
    @State private var searchText = ""

    var body: some View {
        ZStack(alignment: .top) {
            // Background (same style as SignUp)
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
                topHeader

                // White rounded card
                VStack(alignment: .leading, spacing: 16) {
                    searchBar

                    quickActions

                    sectionTitle("Recommended for you")
                    recommendedCards

                    sectionTitle("Latest")
                    latestList
                }
                .padding(.top, 18)
                .padding(.horizontal, 20)
                .padding(.bottom, 22)
                .frame(maxWidth: .infinity)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 26, style: .continuous))
                .padding(.top, 12)

                Spacer(minLength: 0)
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
    }

    // MARK: - Header
    private var topHeader: some View {
        HStack(alignment: .center, spacing: 12) {
            VStack(alignment: .leading, spacing: 4) {
                Text("HireNow")
                    .font(.system(size: 26, weight: .bold))
                    .foregroundStyle(.white)

                Text("Find your next opportunity")
                    .font(.system(size: 13))
                    .foregroundStyle(.white.opacity(0.85))
            }

            Spacer()

            Button {
                // notifications
            } label: {
                Image(systemName: "bell")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(.white)
                    .frame(width: 40, height: 40)
                    .background(.white.opacity(0.14))
                    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
            }

            Button {
                // settings/profile
            } label: {
                Image(systemName: "person.circle")
                    .font(.system(size: 20, weight: .semibold))
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

    // MARK: - Search
    private var searchBar: some View {
        HStack(spacing: 10) {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(.gray)

            TextField("Search jobs, companies…", text: $searchText)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled(true)

            if !searchText.isEmpty {
                Button {
                    searchText = ""
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(.gray.opacity(0.8))
                }
            }
        }
        .padding(.horizontal, 14)
        .frame(height: 52)
        .background(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .stroke(Color(.systemGray4), lineWidth: 1)
        )
    }

    // MARK: - Quick actions
    private var quickActions: some View {
        HStack(spacing: 12) {
            QuickActionCard(
                title: "Find Jobs",
                subtitle: "Explore offers",
                systemImage: "briefcase.fill"
            ) {
                // action
            }

            QuickActionCard(
                title: "My Profile",
                subtitle: "Update CV",
                systemImage: "person.fill"
            ) {
                // action
            }
        }
    }

    // MARK: - Sections
    private func sectionTitle(_ text: String) -> some View {
        HStack {
            Text(text)
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(Color(red: 0.18, green: 0.18, blue: 0.70))
            Spacer()
            Button {
                // see all
            } label: {
                Text("See all")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(.gray)
            }
        }
        .padding(.top, 2)
    }

    private var recommendedCards: some View {
        VStack(spacing: 12) {
            JobCard(
                title: "iOS Developer",
                company: "NovaApps",
                meta: "Remote • Full-time",
                badge: "New"
            )

            JobCard(
                title: "React Native Developer",
                company: "HireHub",
                meta: "Kyiv • Hybrid",
                badge: "Top"
            )
        }
    }

    private var latestList: some View {
        VStack(spacing: 10) {
            LatestRow(title: "Junior SwiftUI", company: "StartUpX", meta: "Remote • Intern")
            LatestRow(title: "Backend Django", company: "CloudTeam", meta: "Lviv • Full-time")
            LatestRow(title: "QA Engineer", company: "TestLab", meta: "Remote • Part-time")
        }
    }
}

// MARK: - Components

private struct QuickActionCard: View {
    let title: String
    let subtitle: String
    let systemImage: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                ZStack {
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .fill(Color(red: 0.18, green: 0.18, blue: 0.70).opacity(0.12))
                        .frame(width: 46, height: 46)

                    Image(systemName: systemImage)
                        .foregroundStyle(Color(red: 0.18, green: 0.18, blue: 0.70))
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
}

private struct JobCard: View {
    let title: String
    let company: String
    let meta: String
    let badge: String

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            ZStack {
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(Color(.systemGray6))
                    .frame(width: 54, height: 54)

                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .fill(Color(red: 0.20, green: 0.22, blue: 0.76))
                    .frame(width: 30, height: 42)
                    .overlay(
                        Image(systemName: "briefcase.fill")
                            .foregroundStyle(.white)
                            .font(.system(size: 14, weight: .semibold))
                    )
            }

            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Text(title)
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundStyle(.black)

                    Spacer()

                    Text(badge)
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundStyle(.white)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(
                            RoundedRectangle(cornerRadius: 12, style: .continuous)
                                .fill(Color(red: 0.18, green: 0.18, blue: 0.70))
                        )
                }

                Text(company)
                    .font(.system(size: 13))
                    .foregroundStyle(.gray)

                Text(meta)
                    .font(.system(size: 12))
                    .foregroundStyle(.gray.opacity(0.9))
            }
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .stroke(Color(.systemGray4), lineWidth: 1)
        )
    }
}

private struct LatestRow: View {
    let title: String
    let company: String
    let meta: String

    var body: some View {
        Button {
            // open details
        } label: {
            HStack(spacing: 12) {
                Circle()
                    .fill(Color(red: 0.18, green: 0.18, blue: 0.70).opacity(0.16))
                    .frame(width: 42, height: 42)
                    .overlay(
                        Image(systemName: "doc.text")
                            .foregroundStyle(Color(red: 0.18, green: 0.18, blue: 0.70))
                            .font(.system(size: 16, weight: .semibold))
                    )

                VStack(alignment: .leading, spacing: 3) {
                    Text(title)
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(.black)

                    Text("\(company) • \(meta)")
                        .font(.system(size: 12))
                        .foregroundStyle(.gray)
                }

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
    NavigationStack {
        HomeScreenView()
    }
}

