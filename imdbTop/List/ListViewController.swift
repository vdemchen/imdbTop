//
//  ListViewController.swift
//  imdbTop
//
//  Created by Vladyslav Demchenko on 24.11.2022.
//

import Combine
import UIKit

typealias DataSource = UITableViewDiffableDataSource<Int, MovieModel>
typealias Snapshot = NSDiffableDataSourceSnapshot<Int, MovieModel>

class ListViewController: UIViewController {
    private enum Constants {
        static let tablePrefetchOffset = 5
    }
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet private var tableView: UITableView!
    
    private let refreshControl = UIRefreshControl()
    private lazy var dataSource = createDataSource()
    private lazy var searchBar = UISearchBar(frame: .zero)
    
    private let viewModel: ListViewModel
    private var cancellables = Set<AnyCancellable>()
    
    init(viewModel: ListViewModel? = nil) {
        self.viewModel = viewModel ?? ListViewModel()
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindUI()
        viewModel.loadData()
    }

    private func setupUI() {
        title = "Top 250"
        navigationItem.titleView = searchBar
        searchBar.placeholder = "Search..."
        tableView.register(
            UINib(nibName: "ItemTableViewCell", bundle: nil),
            forCellReuseIdentifier: "ItemTableViewCell"
        )
        tableView.refreshControl = refreshControl
    }
 
    private func bindUI() {
        tableView.delegate = self
        tableView.prefetchDataSource = self
        searchBar.delegate = self
        
        viewModel.$filteredMovies
            .sink { [weak self] in
                self?.applySnaphot(movies: $0)
                self?.refreshControl.endRefreshing()
            }
            .store(in: &cancellables)
        
        viewModel.$isLoading
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                $0 ? self?.activityIndicator.startAnimating() : self?.activityIndicator.stopAnimating()
            }
            .store(in: &cancellables)
        
        refreshControl.addAction(.init { [weak self] _ in
            self?.viewModel.reloadData()
        }, for: .allEvents)
    }
    
    private func createDataSource() -> DataSource {
        DataSource(tableView: tableView) { tableView, indexPath, itemIdentifier in
            let cell = tableView.dequeueReusableCell(withIdentifier: "ItemTableViewCell", for: indexPath) as? ItemTableViewCell
            cell?.setup(movie: itemIdentifier)
            return cell
        }
    }
    
    private func applySnaphot(movies: Movies) {
        var snapshot = Snapshot()
        snapshot.appendSections([0])
        snapshot.appendItems(movies)
        dataSource.apply(snapshot)
    }
    
    private func loadMoreIfNeeded(indexPaths: [IndexPath]) {
        if indexPaths.contains(where: { $0.row > dataSource.snapshot().numberOfItems - Constants.tablePrefetchOffset }) {
            viewModel.loadMore()
        }
    }
}

extension ListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let movie = viewModel.filteredMovies[indexPath.row]
        let vc = DetailsViewController(movie: movie)
        navigationController?.pushViewController(vc, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension ListViewController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        loadMoreIfNeeded(indexPaths: indexPaths)
    }
}

extension ListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.searchString = searchText
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        viewModel.searchString = ""
        searchBar.text = ""
        searchBar.showsCancelButton = false
        searchBar.endEditing(true)
    }
}
