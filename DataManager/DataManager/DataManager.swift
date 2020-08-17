//
//  DataManager.swift
//  DataManager
//
//  Created by Usha on 15/08/2020.
//  Copyright © 2020 developers. All rights reserved.
//

import Foundation
import StaticLib


//Decoding encrypted API_KEY
extension String {
    var Decrypt_APIKEY: String? {
        guard let base64 = Data(base64Encoded: self) else { return nil }
        let utf8 = String(data: base64, encoding: .utf8)
        return utf8
    }
}


public class DataManager {
    
    var API_KEY = ""
    var newMovies = [Movie]()
    var moviesList = [MovieDetails]()
    
    
    public init(){
        let key = "ZTQzMWUyMTQyZDMzMzBjYjRmNTg0ZGJlNTY3MmMxMTY="
        API_KEY = key.Decrypt_APIKEY!
    }
    
    public func fetchMovies(query:String,completion: @escaping(_ MovieDict: [MovieDetails]?, _ error: Error?) -> ()) {
        
        let URLsession = URLSession.shared
        let baseURL = "https://api.themoviedb.org/3"
        
        let jsonDecoder: JSONDecoder = {
            let jsonDecoder = JSONDecoder()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-mm-dd"
            jsonDecoder.dateDecodingStrategy = .formatted(dateFormatter)
            return jsonDecoder
        }()
        
        // rest api call to search novies
        URLsession.dataTask(with:URL(string:"\(baseURL)/search/multi?api_key=\(API_KEY)&query=\(query))")!,completionHandler: { data, response, error in
            
            guard let data = data, error == nil else {
                return
            }
            // decoding data data
            var result: MovieResult?
            do {
                result = try jsonDecoder.decode(MovieResult.self, from: data)
            }
            catch {
                print("error")
                completion(nil,error)
            }
            guard let finalResult = result else {
                return
            }
            self.newMovies.removeAll()
            self.moviesList.removeAll()
            
            self.newMovies = finalResult.results
            
            //update rest api results to movie array
            self.UpdateMovieArray()
            
            //sort movie array
            // calling c static lib function to sort movies based on rating
            SortMovieRating(&self.moviesList, self.moviesList.count)
            
            completion(self.moviesList, nil)
        }).resume()
    }
    
    func UpdateMovieArray(){
        // Update movies array
        for Movie in newMovies {
            if Movie.releaseDate != nil
            {
                let components = Calendar.current.dateComponents([.year,.month, .day], from: Movie.releaseDate!)
                let releaseYear : Int = components.year!
                if releaseYear == 2017 || releaseYear == 2018 {
                    var moview = MovieDetails()
                    if let title = Movie.originalTitle{
                        moview.originalTitle = strdup(title)
                    }
                    moview.releaseDate = Int32(releaseYear)
                    moview.voteAverage = Movie.voteAverage!
                    if let poster = Movie.posterPath{
                        moview.posterPath = strdup(poster)
                    }
                    moviesList.append(moview)
                }
            }
            else {
                continue
            }
        }
    }
}
