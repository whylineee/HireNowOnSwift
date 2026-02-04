import SwiftUI

enum AppTab: CaseIterable {
    case home, favorites, profile

    var icon: String {
        switch self {
        case .home: return "house.fill"
        case .favorites: return "heart.fill"
        case .profile: return "person.fill"
        }
    }
}

struct MainContainerView: View {
    @StateObject private var appState = AppState()
    @State private var selected: AppTab = .home

    var body: some View {
        ZStack(alignment: .bottom) {
            Group {
                switch selected {
                case .home:
                    HomeScreenView()
                case .favorites:
                    FavoritesView()
                case .profile:
                    ProfileView()
                }
            }
            .environmentObject(appState)

            GlassTabBar(selected: $selected)
                .padding(.horizontal, 18)
                .padding(.bottom, 10)
        }
        .ignoresSafeArea(.keyboard)
    }
}

// MARK: - Glass Tab Bar
struct GlassTabBar: View {
    @Binding var selected: AppTab
    @Namespace private var ns

    private let active = Color(red: 0.18, green: 0.18, blue: 0.70)
    private let inactive = Color.gray.opacity(0.55)

    var body: some View {
        HStack(spacing: 0) {
            tabButton(.home)
            tabButton(.favorites)
            tabButton(.profile)
        }
        .padding(8)
        .frame(height: 70)
        .background(
            BlurView(style: .systemUltraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 30, style: .continuous)
                .stroke(Color.white.opacity(0.35), lineWidth: 1)
        )
        .shadow(color: .black.opacity(0.10), radius: 18, y: 6)
    }

    private func tabButton(_ tab: AppTab) -> some View {
        Button {
            withAnimation(.spring(response: 0.35, dampingFraction: 0.75)) {
                selected = tab
            }
        } label: {
            ZStack {
                // Animated indicator (pill)
                if selected == tab {
                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                        .fill(active.opacity(0.14))
                        .matchedGeometryEffect(id: "activePill", in: ns)
                        .frame(height: 48)
                        .padding(.horizontal, 10)
                }

                Image(systemName: tab.icon)
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundStyle(selected == tab ? active : inactive)
                    .scaleEffect(selected == tab ? 1.05 : 1.0)
                    .animation(.spring(response: 0.35, dampingFraction: 0.75), value: selected)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .buttonStyle(.plain)
    }
}

// MARK: - UIKit blur wrapper
struct BlurView: UIViewRepresentable {
    let style: UIBlurEffect.Style

    func makeUIView(context: Context) -> UIVisualEffectView {
        UIVisualEffectView(effect: UIBlurEffect(style: style))
    }

    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {}
}

