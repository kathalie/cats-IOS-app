//
//  CatListView.swift
//  CatsUI
//
//  Created by Kathryn Verkhogliad on 25.05.2024.
//

import SwiftUI
import CatsNetworking

class CatViewModel: ObservableObject {
    @Published var cats: [CatModelWithBreeds] = []
    @Published var isLoading: Bool = false
    
    private var page = 0
    private let limit = 10
    
    init() {}
    
    func loadMoreCats() async throws {
        guard !isLoading else { return }
        
        DispatchQueue.main.async {
            self.isLoading = true
        }
        do {
            let newCats = try await CatsNetworking.getCats(limit: limit, page: page)
            DispatchQueue.main.async {
                self.page += 1
                self.cats.append(contentsOf: newCats)
                self.isLoading = false
            }
        } catch let error {
            DispatchQueue.main.async {
                self.isLoading = false
            }
            
            throw error
        }


        
    }
}

struct CatListView: View {
    @StateObject private var catModel = CatViewModel()
    @State private var detailsFor: CatModelWithBreeds?
    @State private var errorOccured: Bool = false
    
    private func loadMoreCats() async {
        do {
            try await catModel.loadMoreCats()
        } catch let error {
            print(error)
            
            errorOccured = true            
        }
    }
    
    var body: some View {
        ScrollView {
            Text("Cats")
                .font(.title)
                .padding(.vertical, 12.0)
            LazyVStack(spacing: 10, pinnedViews: [.sectionHeaders]){
                ForEach(Array(self.catModel.cats.enumerated()), id: \.offset) { _, cat in
                    Button(action: {
                        self.detailsFor = cat
                    }) {
                        CatTileView(for: cat)
                    }
                    .buttonStyle(PlainButtonStyle())
                    .task {
                        if cat.id == catModel.cats.last?.id {
                            await self.loadMoreCats()
                        }
                    }
                }
            }
            if catModel.isLoading {
                ProgressView()
                    .padding()
            }
        }
        .task {
            await self.loadMoreCats()
        }
        .alert(isPresented: $errorOccured) {
            Alert(
                title: Text("Error"),
                message: Text("Something went wrong"),
                primaryButton: .cancel({
                    errorOccured = false
                }),
                secondaryButton: .default(Text("Retry")) {
                    Task { await self.loadMoreCats() }
                    errorOccured = false
                }
            )
        }
        .sheet(isPresented: Binding(
            get: { self.detailsFor != nil },
            set: { _ in self.detailsFor = nil }
        )){
            if let detailsFor = self.detailsFor {
                CatDetailsView(for: detailsFor)
            }
        }
        
    }
}

#Preview {
    CatListView()
}
