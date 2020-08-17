//
//  ViewController.swift
//  MovieSearcher
//
//  Created by Usha on 15/08/2020.
//  Copyright © 2020 developers. All rights reserved.
//

import UIKit
import DataManager
import StaticLib

class ViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var table : UITableView!
    @IBOutlet var field : UITextField!
    @IBOutlet weak var noDataLbl: UILabel!
    
    let dataManager = DataManager()
    var movies = [MovieDetails]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        table.register(MovieTableViewCell.nib(), forCellReuseIdentifier: MovieTableViewCell.identifier)
        table.delegate = self
        table.dataSource = self
        field.delegate = self
        self.noDataLbl.isHidden = true
    }
    
    // search field
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchMovies()
        return true
    }
    
    func searchMovies() {
        field.resignFirstResponder()
        guard let text = field.text, !text.isEmpty else {
            return
        }
        let query = text.replacingOccurrences(of: " ", with: "%20")
        movies.removeAll()
        dataManager.fetchMovies( query: query){ films, err in
            
            if(films != nil){
                self.movies.append(contentsOf:  films!)
                if self.movies.count > 0{
                    // Refresh our table
                    DispatchQueue.main.async {
                        self.table.reloadData()
                        self.noDataLbl.isHidden = true;
                        self.table.isHidden = false
                    }
                }
                else {
                    DispatchQueue.main.async {
                        self.table.isHidden = true
                        self.noDataLbl.isHidden = false;
                        self.noDataLbl.text = "No Data Found"
                    }
                }
            }
            else{
                DispatchQueue.main.async {
                    self.table.isHidden = true
                    self.noDataLbl.isHidden = false;
                    self.noDataLbl.text = "No Data Found"
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(movies.count > 10){
            return 10
        }
        return movies.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MovieTableViewCell.identifier, for: indexPath) as! MovieTableViewCell
        cell.configure(with: movies[indexPath.row])
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}


