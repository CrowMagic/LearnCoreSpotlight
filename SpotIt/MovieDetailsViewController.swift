//
//  MovieDetailsViewController.swift
//  SpotIt
//
//  Created by Gabriel Theodoropoulos on 11/11/15.
//  Copyright © 2015 Appcoda. All rights reserved.
//

import UIKit

class MovieDetailsViewController: UIViewController {

    @IBOutlet weak var imgMovieImage: UIImageView!
    
    @IBOutlet weak var lblTitle: UILabel!
    
    @IBOutlet weak var lblCategory: UILabel!
    
    @IBOutlet weak var lblDescription: UILabel!
    
    @IBOutlet weak var lblDirector: UILabel!
    
    @IBOutlet weak var lblStars: UILabel!
    
    @IBOutlet weak var lblRating: UILabel!
    
    var movieInfo: [String: String]!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    func populateMovieInfo() {
        lblTitle.text = movieInfo["Title"]!
        lblCategory.text = movieInfo["Category"]!
        lblDescription.text = movieInfo["Description"]!
        lblDirector.text = movieInfo["Director"]!
        lblStars.text = movieInfo["Stars"]!
        lblRating.text = movieInfo["Rating"]!
        imgMovieImage.image = UIImage(named: movieInfo["Image"]!)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if movieInfo != nil {
            populateMovieInfo()
        }
        lblRating.layer.cornerRadius = lblRating.frame.size.width/2
        lblRating.layer.masksToBounds = true
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
