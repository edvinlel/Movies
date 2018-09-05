//
//  Networking.swift
//  Movies
//
//  Created by Jessica Lemus on 9/3/18.
//  Copyright © 2018 Edvin Lellhame. All rights reserved.
//

import Foundation
import UIKit

struct Networking {

    // Call http get request for UIImage
    static func httpRequestForImage(url: URL, completion: @escaping (_ image: UIImage?, _ error: Error?) -> ()) {
        let request = NSMutableURLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request as URLRequest) { (data, response, error) in
            guard error == nil else {
                completion(nil, error)
                return
            }
            
            guard let data = data else {
                completion(nil, error)
                return
            }
            let image = UIImage(data: data)
            completion(image, nil)
            
        }
        task.resume()
        
    }
    
    // Call http get request for API data
    static func httpRequest(withURL url: URL, completion: @escaping (_ result: AnyObject?, _ error: Error?) -> ()) {
        let request = NSMutableURLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request as URLRequest) { (data, response, error) in
            guard error == nil else {
                completion(nil, error)
                return
            }
            guard let data = data else {
                completion(nil, error)
                return
            }
            
            getJSON(data: data, completion: completion)
            
            
        }
        task.resume()
    }
    
    // get parsed json from http request
    static func getJSON(data: Data?, completion:(_ result: AnyObject?, _ error: Error?)->(Void)) {
        var parsedResult: AnyObject!
        do {
            parsedResult = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as AnyObject
        } catch {
            completion(nil, error)
        }
        
        
        completion(parsedResult, nil)
    }
}
