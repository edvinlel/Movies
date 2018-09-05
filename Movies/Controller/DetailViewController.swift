//
//  DetailViewController.swift
//  Movies
//
//  Created by Edvin Lellhame on 9/5/18.
//  Copyright © 2018 Edvin Lellhame. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var movieDescription: UITextView!
    
    var movie: TopRatedMovie!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Simple detail view controller with passed data from view controller of certain movie
        titleLabel.text = movie.title
        movieDescription.text = movie.description
        
        guard let imagePath = movie.imagePath else {
            return
        }
        let url = URL(string: Constants.posterPath + imagePath)
        Networking.httpRequestForImage(url: url!) { (image, error) in
            guard error == nil else {
                return
            }
            DispatchQueue.main.async {
                self.imageView.image = image
            }
        }
    }

    @IBAction func backButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
}
