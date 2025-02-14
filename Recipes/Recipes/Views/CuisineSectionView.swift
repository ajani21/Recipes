import SwiftUI

struct CuisineSectionView: View {
    let cuisine: String
    let recipes: [Recipe]
    @State private var isExpanded = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Button(action: {
                withAnimation {
                    isExpanded.toggle()
                }
            }) {
                HStack {
                    Text(cuisine)
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    Spacer()
                    
                    Image(systemName: isExpanded ? "chevron.down" : "chevron.right")
                        .foregroundColor(.gray)
                        .animation(.easeInOut, value: isExpanded)
                }
                .padding(.vertical, 8)
                .background(Color(.systemBackground))
            }
            
            if isExpanded {
                LazyVStack(spacing: 16) {
                    ForEach(recipes) { recipe in
                        RecipeCard(recipe: recipe)
                    }
                }
                .transition(.move(edge: .top).combined(with: .opacity))
            }
        }
    }
}
