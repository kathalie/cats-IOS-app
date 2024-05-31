//
//  CatListView.swift
//  CatsUI
//
//  Created by Kathryn Verkhogliad on 25.05.2024.
//

import SwiftUI
import CatsNetworking
import FirebaseCrashlytics

extension String: Error {}

class ViewModel: ObservableObject {
    @Published var cats: [CatModelWithBreeds] = []
    @Published var isLoading: Bool = false
    let api: Api? = getApi()
    
    private var page = 0
    private let limit = 10
    
    init() {}
    
    func loadMoreItems() async throws {
        guard !isLoading else { return }
        
        DispatchQueue.main.async {
            self.isLoading = true
        }
        do {
            Crashlytics.crashlytics().log("Loading \(limit) cats for page \(page)")
            
            guard let api
            else {
                Crashlytics.crashlytics().log("Failed to read from Info.plist")
                
                print("Failed to read from Info.plist")
                
                DispatchQueue.main.async {
                    self.isLoading = false
                }
                
                throw "Something went wrong"
            }
            
            let networking = Networking(api: api)
            
            let newCats = try await networking.getManyWithBreeds(limit: limit, page: page)
            DispatchQueue.main.async {
                self.page += 1
                self.cats.append(contentsOf: newCats)
                self.isLoading = false
            }
        } catch let error {
            Crashlytics.crashlytics().record(error: error)
            
            DispatchQueue.main.async {
                self.isLoading = false
            }
            
            throw error
        }
    }
}

struct CatListView: View {
    @StateObject private var viewModel = ViewModel()
    @State private var detailsFor: CatModelWithBreeds?
    @State private var errorOccured: Bool = false
    
    private func loadMoreItems() async {
        do {
            try await viewModel.loadMoreItems()
        } catch let error {
            print(error)
            
            errorOccured = true
        }
    }
    
    private var mainHeaderCaption: String {
        switch self.viewModel.api {
        case .cats: return "Cats"
        case .dogs: return "Dogs"
        default: return ""
        }
    }
    
    var body: some View {
        ScrollView {
            Button("Crash") {
                Crashlytics.crashlytics().log("Tapping 'Crash' button")
                fatalError("Crash was triggered")
            }
            Text(self.mainHeaderCaption)
                .font(.title)
                .padding(.vertical, 12.0)
            LazyVStack(spacing: 10, pinnedViews: [.sectionHeaders]){
                ForEach(Array(self.viewModel.cats.enumerated()), id: \.offset) { _, cat in
                    Button(action: {
                        Crashlytics.crashlytics().setCustomValue(cat.id, forKey: "last_tapped_row_cat_id")
                        self.detailsFor = cat
                    }) {
                        CatTileView(for: cat)
                    }
                    .buttonStyle(PlainButtonStyle())
                    .task {
                        if cat.id == viewModel.cats.last?.id {
                            await self.loadMoreItems()
                        }
                    }
                }
            }
            if viewModel.isLoading {
                ProgressView()
                    .padding()
            }
        }
        .task {
            await self.loadMoreItems()
        }
        .alert(isPresented: $errorOccured) {
            Alert(
                title: Text("Error"),
                message: Text("Something went wrong"),
                primaryButton: .cancel({
//                    fatalError("Something went wrong was canceled.")
                    
                    errorOccured = false
                }),
                secondaryButton: .default(Text("Retry")) {
//                    fatalError("Failed to load more cats.")

                    Task { await self.loadMoreItems() }
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
