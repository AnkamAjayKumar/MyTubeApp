//
//  MyTubeHome.swift
//  PageControl
//
//  Created by Ankam Ajay Kumar on 10/12/19.
//  Copyright © 2019 Ankam Ajay Kumar. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class MyTubeHome: UIViewController, UIScrollViewDelegate {

    //MARK: - IBOutlet Properties
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var imageScrollView: UIScrollView!
    @IBOutlet weak var latestMoviesScrollView: UIScrollView!
    @IBOutlet weak var pageControlObj: UIPageControl!
    
    //instance creation
    var movieJsonData = [[String:Any]]()
    var allButtonObj = [UIButton]()
    
    //MARK: - IBAction
    @IBAction func loadActionBtn(_ sender: Any) {
        pageControlObj.currentPage = 0
        displayMoviePosters()
    }
    
    @IBOutlet weak var loadActionBtn: UIButton!
    
    
    //MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()

        //calling method to display movie posters
        displayMoviePosters()
        
        //calling method to display latest movies
        latestMovieDetails()
        
        //adding scheduled timer to movie poster
        Timer.scheduledTimer(timeInterval: 6, target: self, selector: #selector(timerEH), userInfo: nil, repeats: true)
        
    }
    
    //MARK:- Method Creation
    //method to navigate and button tag values in singleton
    @objc func navigateToMovieDetails(obj:UIButton)
    {
        JsonData.shared.buttonTapped = obj.tag
    
        let movieDetails = storyboard?.instantiateViewController(withIdentifier: "MyTubeMovie") as! MyTubeMovie
        
        self.present(movieDetails, animated: true, completion: nil)
    }
    
    //method to set timer for pagecontrol
    @objc func timerEH()
    {
        
        if(pageControlObj.currentPage != pageControlObj.numberOfPages - 1)
        {
            pageControlObj.currentPage += 1
        }
        else
        {
            pageControlObj.currentPage = 0
        }
        
        imageScrollView.contentOffset.x = CGFloat(pageControlObj.currentPage) * imageScrollView.frame.width
    }
    
    //method to display movie posters
    func displayMoviePosters()
    {
        imageScrollView.delegate = self
        
        //removing all buttons
        for x in allButtonObj
               
        {
            x.removeFromSuperview()
        }
               
        //buttons will be empty after removing
        allButtonObj = [UIButton]()
        
        
        //singleton variables will be empty after loading
        JsonData.shared.posters = [UIImage]()
        JsonData.shared.title = [String]()
        JsonData.shared.directorName = [String]()
        JsonData.shared.stories = [String]()
        JsonData.shared.actorName = [[String]]()
        JsonData.shared.trailer = [AVPlayer]()
        JsonData.shared.songs = [[AVPlayer]]()
        
        movieJsonData = JsonData.shared.movieDataFromJson()
        pageControlObj.numberOfPages = movieJsonData.count
        
        
        var i = 0
        for x in movieJsonData
        {
            let poster = (x["posters"] as! [String])[0]
            let urlString = poster.replacingOccurrences(of: " ", with: "%20")
            print(poster)
            let posterURL = URL(string: "https://www.brninfotech.com/tws/\(urlString)")
            let posterDataTask = URLSession.shared.dataTask(with: posterURL!) { (data, connDetails, err) in
                
                DispatchQueue.main.async {
                    let posterBtn = UIButton()
                    posterBtn.frame = CGRect(x: CGFloat(i) * self.imageScrollView.bounds.width, y: 0, width: self.imageScrollView.bounds.width, height: self.imageScrollView.bounds.height)
                    posterBtn.tag = i
                    posterBtn.setImage(UIImage(data: data!), for: UIControl.State.normal)
                    posterBtn.addTarget(self, action: #selector(self.navigateToMovieDetails(obj:)), for: UIControl.Event.touchUpInside)
                    posterBtn.layer.cornerRadius = 5
                    posterBtn.clipsToBounds = true
                    self.allButtonObj.append(posterBtn)
                    self.imageScrollView.addSubview(posterBtn)
                    
                    //storing all singleton variables
                    JsonData.shared.posters.append(UIImage(data: data!)!)
                    JsonData.shared.stories.append(x["story"] as? String ?? "😟Story not Available")
                    JsonData.shared.title.append(x["title"] as! String)
                    JsonData.shared.directorName.append(x["director"] as! String)
                    
                    //storing all actors in singleton variable
                    var allActors = [String]()
                    for actors in (x["actors"] as! [String])
                    {
                        allActors.append(actors)
                    }
                    JsonData.shared.actorName.append(allActors)
                    
                    //storing all trailers in singleton variable
                    let trailer = (x["trailers"] as! [String])[0]
                    let urlString = trailer.replacingOccurrences(of: " ", with: "%20")
                    let trailerPath = "https://www.brninfotech.com/tws/\(urlString)"
                    let avPlayer = AVPlayer(url: URL(string: trailerPath)!)
                    JsonData.shared.trailer.append(avPlayer)
                    
                    //storing all songs in singleton variable
                    var audios = [AVPlayer]()
                    let audioArray = x["songs"] as! [String]
                    for a in audioArray
                    {
                        let urlString = a.replacingOccurrences(of: " ", with: "%20")
                        print("songs:", urlString)
                        let songPath = "https://www.brninfotech.com/tws/\(urlString)"
                        let audio = AVPlayer(url: URL(string: songPath)!)
                        audios.append(audio)

                    }
                    JsonData.shared.songs.append(audios)
                    JsonData.shared.songNames.append(audioArray)
                    
                    i += 1
                }
                
            }
            posterDataTask.resume()
            
            //setting content size for scrollview
            imageScrollView.contentSize = CGSize(width: imageScrollView.frame.width * CGFloat(movieJsonData.count), height: imageScrollView.frame.height)
            
        }
    }
    
    func latestMovieDetails()
    {
        var i = 0
        for x in movieJsonData
        {
            let poster = (x["posters"] as! [String])[0]
            let urlString = poster.replacingOccurrences(of: " ", with: "%20")
            print(poster)
            let posterURL = URL(string: "https://www.brninfotech.com/tws/\(urlString)")
            let posterDataTask = URLSession.shared.dataTask(with: posterURL!) { (data, connDetails, err) in
                
                DispatchQueue.main.async {
                    let posterBtn = UIButton()
                    posterBtn.frame = CGRect(x: CGFloat(i) * 180, y: 0, width: 170, height: self.latestMoviesScrollView.bounds.height)
                    posterBtn.setImage(UIImage(data: data!), for: UIControl.State.normal)
                    posterBtn.layer.cornerRadius = 6
                    posterBtn.clipsToBounds = true
                    self.latestMoviesScrollView.addSubview(posterBtn)
                    i += 1
                            
                }
            }
            posterDataTask.resume()
                        
            //setting content size for scrollview
            latestMoviesScrollView.contentSize = CGSize(width: 180 * CGFloat(movieJsonData.count), height: latestMoviesScrollView.frame.height)
                    }
    }
    
    //MARK: - scrollview delegate method
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        pageControlObj.currentPage = Int(scrollView.contentOffset.x / scrollView.bounds.width)
        
    }

   

}
