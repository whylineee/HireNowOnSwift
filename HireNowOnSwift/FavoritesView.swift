import SwiftUI

struct FavoritesView: View {
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

            VStack {
                VStack(alignment: .leading, spacing: 14) {
                    Text("Favorites")
                        .font(.system(size: 26, weight: .bold))
                        .foregroundStyle(Color(red: 0.18, green: 0.18, blue: 0.70))

                    Text("Saved vacancies will appear here.")
                        .font(.system(size: 14))
                        .foregroundStyle(.gray)

                    Spacer()
                }
                .padding(.top, 22)
                .padding(.horizontal, 20)
                .padding(.bottom, 120)
                .frame(maxWidth: .infinity)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 26))
                .padding(.top, 80)

                Spacer()
            }
        }
        .navigationBarHidden(true)
    }
}
