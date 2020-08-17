//
//  MovieTableViewCell.swift
//  MovieSearcher
//
//  Created by Usha on 15/08/2020.
//  Copyright © 2020 developers. All rights reserved.
//

import UIKit
import DataManager
import StaticLib

class MovieTableViewCell: UITableViewCell {
    
    @IBOutlet var movieTitleLabel: UILabel!
    @IBOutlet var movieYearLabel: UILabel!
    @IBOutlet var moviePosterImageView: UIImageView!
    @IBOutlet var movieRatingLabel : UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    static let identifier = "MovieTableViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "MovieTableViewCell",
                     bundle: nil)
    }
    
    func configure(with model: MovieDetails) {
        self.movieTitleLabel.text = String(cString: model.originalTitle)
        let posterPath = String(cString: model.posterPath)
        if let data = try? Data(contentsOf: URL(string: "https://image.tmdb.org/t/p/w500\(posterPath)")!) {
            self.moviePosterImageView.image = UIImage(data: data)
        }
        self.movieYearLabel.text = String(model.releaseDate)
        self.movieRatingLabel.text = String(model.voteAverage)
    }    
}
