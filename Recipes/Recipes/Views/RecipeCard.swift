//
//  RecipeCard.swift
//  Recipies
//
//  Created by Arth Jani on 2/12/25.
//

import SwiftUI

struct RecipeCard: View {
    let recipe: Recipe
    @State private var image: UIImage?
    
    var body: some View {
        VStack(spacing: 12) {
            Text(recipe.name)
                .font(.title2)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
            
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 125)
                    .cornerRadius(8)
            } else {
                Rectangle()
                    .fill(Color.gray.opacity(0.2))
                    .frame(height: 200)
                    .cornerRadius(8)
                    .overlay(
                        ProgressView()
                    )
            }
            
            Text(recipe.cuisine)
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            if let sourceUrl = recipe.sourceUrl,
               let url = URL(string: sourceUrl) {
                Link("View Recipe", destination: url)
                    .font(.callout)
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(radius: 5)
        .task {
            await loadImage()
        }
    }
    
    private func loadImage() async {
        guard let urlString = recipe.photoUrlSmall,
              let url = URL(string: urlString) else { return }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            if let loadedImage = UIImage(data: data) {
                self.image = loadedImage
            }
        } catch {
            print("Error loading image: \(error)")
        }
    }
}
