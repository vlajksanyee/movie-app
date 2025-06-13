import SwiftUI
import Foundation

struct PublisherDetailsView: View {
    let publisher: ProductionCompany
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            Color.black.ignoresSafeArea()
            VStack(alignment: .leading, spacing: 24) {
                if let url = publisher.imageUrl {
                    LoadImageView(url: url)
                        .frame(height: 120)
                        .frame(maxWidth: .infinity)
                        .cornerRadius(24)
                        .padding(.horizontal, 8)
                }
                Text(publisher.name)
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 16)
                HStack(spacing: 32) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Country")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.white)
                        Text(publisher.originCountry)
                            .font(.system(size: 16))
                            .foregroundColor(.white)
                    }
                }
                .padding(.horizontal, 16)
                Text("Description")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 16)
                Text("No description available.")
                    .font(.system(size: 14))
                    .foregroundColor(.white)
                    .padding(.horizontal, 16)
                Text("Popularity")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 16)
                HStack(spacing: 8) {
                    ForEach(0..<3, id: \..self) { _ in
                        Image(systemName: "star.fill")
                            .foregroundColor(.yellow)
                            .font(.title2)
                    }
                }
                .padding(.horizontal, 16)
                Spacer()
            }
            .padding(.top, 16)
        }
    }
}
