//
//  CastDetailsView.swift
//  movie-app
//
//  Created by Sandor Vlajk on 2025. 06. 13..
//

import SwiftUI
import InjectPropertyWrapper
import Combine

class CastDetailsViewModel: ObservableObject {
    @Published var castMember: CastMember
    @Published var isLoading: Bool = false
    @Published var error: String? = nil
    
    @Inject
    private var repository: MovieRepository
    
    private var cancellables = Set<AnyCancellable>()
    
    init(castMember: CastMember) {
        self.castMember = castMember
        fetchDetails()
    }
    
    func fetchDetails() {
        isLoading = true
        error = nil
        repository.fetchPersonDetails(personId: castMember.id)
            .receive(on: RunLoop.main)
            .sink { [weak self] completion in
                self?.isLoading = false
                if case let .failure(err) = completion {
                    self?.error = err.localizedDescription
                }
            } receiveValue: { [weak self] details in
                self?.castMember = details
            }
            .store(in: &cancellables)
    }
}

struct CastDetailsView: View {
    let castMember: CastMember? = nil
    @StateObject private var viewModel: CastDetailsViewModel
    
    init(castMember: CastMember) {
        _viewModel = StateObject(wrappedValue: CastDetailsViewModel(castMember: castMember))
    }
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            Color.black.ignoresSafeArea()
            if viewModel.isLoading {
                ProgressView().frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if let error = viewModel.error {
                Text(error)
                    .foregroundColor(.red)
                    .padding()
            } else {
                let member = viewModel.castMember
                VStack(alignment: .leading, spacing: 24) {
                    if let url = member.castImageURL {
                        LoadImageView(url: url)
                            .frame(height: 160)
                            .frame(maxWidth: .infinity)
                            .cornerRadius(24)
                            .padding(.horizontal, 8)
                    }
                    Text(member.name)
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.horizontal, 16)
                    HStack(spacing: 32) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Birth year")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.white)
                            Text(member.birthday?.prefix(4) ?? "-")
                                .font(.system(size: 16))
                                .foregroundColor(.white)
                        }
                        VStack(alignment: .leading, spacing: 4) {
                            Text("City")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.white)
                            Text(member.placeOfBirth ?? "-")
                                .font(.system(size: 16))
                                .foregroundColor(.white)
                        }
                    }
                    .padding(.horizontal, 16)
                    Text("Bio")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.white)
                        .padding(.horizontal, 16)
                    Text(member.biography?.isEmpty == false ? member.biography! : "No biography available.")
                        .font(.system(size: 14))
                        .foregroundColor(.white)
                        .padding(.horizontal, 16)
                    Text("Popularity")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                        .padding(.horizontal, 16)
                    HStack(spacing: 8) {
                        let stars = Int((member.popularity ?? 0) / 5).clamped(to: 1...5)
                        ForEach(0..<stars, id: \.self) { _ in
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
}

extension Comparable {
    func clamped(to limits: ClosedRange<Self>) -> Self {
        min(max(self, limits.lowerBound), limits.upperBound)
    }
}
