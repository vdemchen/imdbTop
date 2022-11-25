//
//  DetailsViewController.swift
//  imdbTop
//
//  Created by Vlada Kemskaya on 25.11.2022.
//

import Nuke
import UIKit

final class DetailsViewController: UIViewController {
    // MARK: Outlets
    @IBOutlet weak var descriptionView: UITextView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var ratingLabel: UILabel!
    
    // MARK: - Properies
    private let movie: MovieModel
    
    // MARK: - Init
    init(movie: MovieModel) {
        self.movie = movie
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let url = URL(string: movie.image) {
            Nuke.loadImage(with: url, into: movieImageView)
        }
        titleLabel.text = "\(movie.title) \(movie.description)"
        ratingLabel.text = "Rating: \(movie.imDBRating)"
        descriptionView.text = movie.plot
        
    }
}
