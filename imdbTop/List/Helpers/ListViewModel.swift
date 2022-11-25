//
//  ListViewModel.swift
//  imdbTop
//
//  Created by Vlada Kemskaya on 24.11.2022.
//

import Combine
import Foundation

final class ListViewModel {
    private enum Constants {
        static let fetchStep = 10
    }
    // MARK: - Properties
    @Published var filteredMovies = Movies()
    @Published var movies = Movies()
    @Published var searchString = ""
    @Published var isLoading = false
    
    private let manager = ListManager()

    private var fetchItems = Constants.fetchStep
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        self.bindData()
    }
    
    func loadData() {
        manager.getTop250(fetchItems)
            .handleEvents(receiveSubscription: { [weak self] _ in
                self?.isLoading = true
            }, receiveOutput: { _ in
                self.isLoading = false
            })
            .replaceError(with: Movies())
            .receive(on: DispatchQueue.main)
            .assign(to: \.movies, on: self)
            .store(in: &cancellables)
    }
    
    func reloadData() {
        fetchItems = Constants.fetchStep
        loadData()
    }
    
    func loadMore() {
        fetchItems += Constants.fetchStep
        loadData()
    }
    
    private func bindData() {
        let filterPublisher = $searchString
            .combineLatest($movies) { text, movies in
                text.isEmpty ? movies : movies.filter {
                    $0.title.localizedCaseInsensitiveContains(text)
                }
            }
        
        $searchString
            .combineLatest(filterPublisher)
            .debounce(for: .seconds(0.5), scheduler: RunLoop.main)
            .dropFirst()
            .flatMap { [unowned self] text, movies in
                return movies.isEmpty ? searchByName(text) : Just(movies)
                    .eraseToAnyPublisher()
            }
            .assign(to: \.filteredMovies, on: self)
            .store(in: &cancellables)
    }
    
    private func searchByName(_ name: String) -> AnyPublisher<Movies, Never> {
        manager.searchMoviewForName(name)
            .handleEvents(receiveSubscription: { [weak self] _ in
                self?.isLoading = true
            }, receiveOutput: { _ in
                self.isLoading = false
            })
            .replaceError(with: Movies())
            .eraseToAnyPublisher()
    }
}
