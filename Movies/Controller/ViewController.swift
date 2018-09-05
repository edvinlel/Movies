//
//  ViewController.swift
//  Movies
//
//  Created by Jessica Lemus on 9/3/18.
//  Copyright © 2018 Edvin Lellhame. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var topRatedLabel: UILabel!
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var backButtonView: UIView!
    
    var currentPageNumber = 1
    
    var topRated = [Movie]()

    override func viewDidLoad() {
        super.viewDidLoad()
        isBackButtonHidden(hidden: true)
        
        textField.delegate = self
        
        // Populate table view with top rated movies
        guard let url = URL(string: "https://api.themoviedb.org/3/movie/top_rated?page=\(currentPageNumber)&language=en-US&api_key=\(Constants.apiKey)") else { return }
        getRequest(url: url)
        

    }
    
    //MARK: Helper Method(s)
    func getRequest(url: URL) {
        
        // Call the network and get data
        // Add data to array and reload table view
        Networking.httpRequest(withURL: url) { (parsedResult, error) in
            guard let results = parsedResult!["results"] as? [[String: AnyObject]] else {
                return
            }
            
            for i in results {
                let topRatedMovie = Movie(data: i)
                
                DispatchQueue.main.async {
                    self.topRated.append(topRatedMovie)
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    func isBackButtonHidden(hidden: Bool) {
        // Hide button when top rated is shown
        // Show button when in search
        backButton.isHidden = hidden
        backButtonView.isHidden = hidden
    }
    
    //MARK: IBAction(s)
    @IBAction func backButtonPressed(_ sender: UIButton) {
        // Reload original Top Rated movies to table view
        currentPageNumber = 1
        isBackButtonHidden(hidden: true)
        topRated.removeAll()
        getRequest(url: URL(string: "https://api.themoviedb.org/3/movie/top_rated?page=\(currentPageNumber)&language=en-US&api_key=\(Constants.apiKey)")!)
        topRatedLabel.text = "Top Rated"
        textField.text = "Search"
    }
    
}


//MARK: UITableView Delegate and DataSource
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return topRated.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.reuseIdentifier, for: indexPath) as! MovieCell
        
        cell.configureTopRatedMovieCell(movie:topRated[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        // Get the latest cell and add more to the table view by incrementing page number
        let last = topRated.count - 1
        currentPageNumber += 1
        if indexPath.row == last {
            guard let url = URL(string: "https://api.themoviedb.org/3/movie/top_rated?page=\(currentPageNumber)&language=en-US&api_key=\(Constants.apiKey)") else { return }
            getRequest(url: url)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let movie = topRated[indexPath.row]
        let detailViewController = storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        detailViewController.movie = movie
        present(detailViewController, animated: true, completion: nil)
    }
}

// MARK: UITextFieldDelegate
extension ViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = ""
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        // Remove all data from array and upload new Search data to table view
        topRated.removeAll()
        
        let searchURL = "https://api.themoviedb.org/3/search/movie?api_key=2cfeee589afd4786fdf6e57b641d9a33&language=en-US&query=\(textField.text!)&page=1&include_adult=false"
        
        let urlString = searchURL.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        
        guard let url = URL(string: urlString!) else { return false }
        getRequest(url: url)
        
        isBackButtonHidden(hidden: false)
        topRatedLabel.text = textField.text?.uppercased()
        textField.text = ""
        textField.resignFirstResponder()
        
        return true
    }
}




