//
//  MovieCell.swift
//  Movies
//
//  Created by Edvin Lellhame on 9/5/18.
//  Copyright © 2018 Edvin Lellhame. All rights reserved.
//

import UIKit

class MovieCell: UITableViewCell {

    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    func configureTopRatedMovieCell(movie: TopRatedMovie) {
        // Upload cells with passed data
        titleLabel.text = movie.title
        guard let imagePath = movie.imagePath else {
            return
        }
        let url = URL(string: Constants.posterPath + imagePath)
        Networking.httpRequestForImage(url: url!) { (image, error) in
            guard error == nil else {
                return
            }
            DispatchQueue.main.async {
                self.movieImageView.image = image
            }
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
