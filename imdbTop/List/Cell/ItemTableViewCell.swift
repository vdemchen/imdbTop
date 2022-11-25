//
//  ItemTableViewCell.swift
//  imdbTop
//
//  Created by Vladyslav Demchenko on 24.11.2022.
//

import Combine
import Nuke
import UIKit

final class ItemTableViewCell: UITableViewCell {
    // MARK:  - Outlets
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var ratingLabel: UILabel!
    @IBOutlet private weak var movieImageView: UIImageView!
    
    // MARK: - Properties
    private var cancellables = Set<AnyCancellable>()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        cancellables = []
    }
    
    func setup(movie: MovieModel) {
        titleLabel.text = movie.title
        ratingLabel.text = movie.imDBRating
        if let url = URL(string: movie.image) {
            Nuke.loadImage(with: url, into: movieImageView)
        }
    }
}
