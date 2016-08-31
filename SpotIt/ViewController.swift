//
//  ViewController.swift
//  SpotIt
//
//  Created by Gabriel Theodoropoulos on 11/11/15.
//  Copyright © 2015 Appcoda. All rights reserved.
//

import UIKit
import CoreSpotlight
import MobileCoreServices

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tblMovies: UITableView!
    
    var moviesInfo: NSMutableArray!
    
    var selectedMovieIndex: Int!

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Movies"

        loadMoviesInfo()
        
        configureTableView()
        
        setupSearchableContent()
    }
    
    
    
    func loadMoviesInfo() {
        if let path = NSBundle.mainBundle().pathForResource("MoviesData", ofType: "plist") {
            moviesInfo = NSMutableArray(contentsOfFile: path)
        }
    }

    func setupSearchableContent() {
        var searchableItems = [CSSearchableItem]()
        for i in 0..<moviesInfo.count {
            let movie = moviesInfo[i] as! [String: String]
            let searchableItemAttributeSet = CSSearchableItemAttributeSet(itemContentType: kUTTypeText as String)
            //设置标题
            searchableItemAttributeSet.title = movie["Title"]!
            //设置电影封面
            let imagePathParts = movie["Image"]!.componentsSeparatedByString(".")
            searchableItemAttributeSet.thumbnailURL = NSBundle.mainBundle().URLForResource(imagePathParts[0], withExtension: imagePathParts[1])
            //设置简介
            searchableItemAttributeSet.contentDescription = movie["Description"]!
            
            //设置搜索的关键字(如电影所属的类别以及评星数)
            var keywords = [String]()
            let movieCategories = movie["Category"]!.componentsSeparatedByString(", ")
            for movieCategory in movieCategories {
                keywords.append(movieCategory)
            }
            
            let stars = movie["Stars"]!.componentsSeparatedByString(", ")
            for star in stars {
                keywords.append(star)
            }
            
            searchableItemAttributeSet.keywords = keywords
            
            
            let searchableItem = CSSearchableItem(uniqueIdentifier: "com.appcoda.SpotIt.\(i)", domainIdentifier: "movies", attributeSet: searchableItemAttributeSet)
            searchableItems.append(searchableItem)
            
            CSSearchableIndex.defaultSearchableIndex().indexSearchableItems(searchableItems, completionHandler: { (error) in
                if error != nil {
                    print(error?.localizedDescription)
                }
            })
            
        }
    }
    
    
    override func restoreUserActivityState(activity: NSUserActivity) {
        if activity.activityType == CSSearchableItemActionType {
            if let userInfo = activity.userInfo {
                let selectedMovie = userInfo[CSSearchableItemActivityIdentifier] as! String
                
                print(selectedMovie)
                print("Hello")
                selectedMovieIndex = Int(selectedMovie.componentsSeparatedByString(".").last!)
                performSegueWithIdentifier("idSegueShowMovieDetails", sender: self)
            }
        }
    }
    
    

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    // MARK: Custom Functions
    
    func configureTableView() {
        tblMovies.delegate = self
        tblMovies.dataSource = self
        tblMovies.tableFooterView = UIView(frame: CGRectZero)
        tblMovies.registerNib(UINib(nibName: "MovieSummaryCell", bundle: nil), forCellReuseIdentifier: "idCellMovieSummary")
    }
    
    
    // MARK:  UITableView Functions
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard moviesInfo != nil else {
            return 0
        }
        return moviesInfo.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("idCellMovieSummary", forIndexPath: indexPath) as! MovieSummaryCell
        let curentMovieInfo = moviesInfo[indexPath.row] as! [String: String]
        cell.lblTitle.text = curentMovieInfo["Title"]!
        cell.lblDescription.text = curentMovieInfo["Description"]!
        cell.lblRating.text = curentMovieInfo["Rating"]!
        cell.imgMovieImage.image = UIImage(named: curentMovieInfo["Image"]!)
        
        
        return cell
    }
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100.0
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        selectedMovieIndex = indexPath.row
        performSegueWithIdentifier("idSegueShowMovieDetails", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier {
            if identifier == "idSegueShowMovieDetails" {
                let movieDetailsViewController = segue.destinationViewController as! MovieDetailsViewController
                movieDetailsViewController.movieInfo = moviesInfo[selectedMovieIndex] as! [String: String]
                
            }
        }
    }
    
    
}

























