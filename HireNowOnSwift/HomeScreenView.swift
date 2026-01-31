import SwiftUI

struct HomeScreenView: View {
    @State private var searchText = ""

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            
            // Header
            HStack {
                Text("HireNow")
                    .font(.system(size: 34, weight: .bold))
                
                Spacer()
                
                Button {
                    // settings
                } label: {
                    Image(systemName: "gearshape")
                        .font(.system(size: 26))
                        .foregroundStyle(.black)
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 1)
            
            // 🔍 Search bar (під буквами)
            HStack(spacing: 8) {
                Image(systemName: "magnifyingglass")
                    .foregroundStyle(.gray)
                
                TextField("Пошук", text: $searchText)
                    .textInputAutocapitalization(.never)
                    .disableAutocorrection(true)
            }
            .padding(12)
            .background(Color(.systemGray6))
            .cornerRadius(14)
            .padding(.horizontal, 20)
            
            Spacer()
        }
        .background(Color.white)
    }
}

#Preview {
    HomeScreenView()
}

