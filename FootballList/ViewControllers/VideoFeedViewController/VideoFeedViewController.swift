//
//  VideoFeedViewController.swift
//  FootballList
//
//  Created by user on 05.04.17.
//  Copyright © 2017 AlexeyZayakin. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation
import Alamofire
import Firebase

class VideoFeedViewController: BaseViewController {
    
    //MARK: - IBO
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    //MARK: - LET
    fileprivate var isDataLoading:Bool = false
    fileprivate var isPreloadData:Bool = true
    fileprivate var postsLimit:Int = 10
    fileprivate var lastPostIndexPath:IndexPath?
    
    override var estimateRowHeight: CGFloat {
        get{
            return 278
        }
    }
    
    //MARK: - VAR
    fileprivate var videoPosts:[VidmeVideoPost] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUpSideMenuGesture()
        self.tableView.registerNib()
        self.loadData()
        
    }
    
    fileprivate func loadData()
    {
        RequestManager.addRequest(VideoRequestModel(offset:self.videoPosts.count, limit:postsLimit)).runWithHandler(GetVideoHandler()) { (response, error) in
            if error == nil
            {
                if self.isPreloadData == true
                {
                    self.videoPosts = (response?.videos)!
                    self.tableView.reloadData()
                    self.tableView.isHidden = false
                    self.indicator.stopAnimating()
                    self.isPreloadData = false
                    self.lastPostIndexPath = IndexPath(row:self.videoPosts.count - 1, section:0)
                }
                else
                {
                    let fetchedVideos = (response?.videos)!
                    for i in 0..<fetchedVideos.count
                    {
                        if self.videoPosts.contains(fetchedVideos[i]) != true
                        {
                            self.videoPosts.append(fetchedVideos[i])
                        }
                    }
                    
                    var indexPaths = [IndexPath]()
                    for i in (self.lastPostIndexPath?.row)!..<(self.videoPosts.count - 1)
                    {
                        let indexPath = IndexPath(row: i, section:0)
                        indexPaths.append(indexPath)
                    }
                    
                    self.tableView.insertRows(at: indexPaths, with: .none )
                    self.lastPostIndexPath = IndexPath(row:self.videoPosts.count - 1, section:0)
                }
                
            }
            else
            {
                print("Error: ", error?.localizedDescription ?? "some unknown error")
            }
            
        }
    }
    
    @IBAction func menuButtonTapped(_ sender: Any)
    {
        self.revealViewController().revealToggle(animated: true)
    }
}

//MAKR: - UITableViewDataSource

extension VideoFeedViewController: UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.videoPosts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell: VideoPostCell = tableView.dequeueReusableCell(VideoPostCell.self, for: indexPath)
        cell.setCell(post: self.videoPosts[indexPath.row])
        return cell
    }
}

//MAKR: - UITableViewDelegate

extension VideoFeedViewController: UITableViewDelegate
{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return self.estimateRowHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let url = self.videoPosts[indexPath.row].videoUrl
        let player = AVPlayer(url: url)
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        self.present(playerViewController, animated: true) {
            playerViewController.player!.play()
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView)
    {
        self.isDataLoading = false
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool)
    {
        var indexPaths:[IndexPath] = []
        
        for i in 0..<6
        {
            let indexPath = IndexPath(row: self.videoPosts.count - i, section: 0)
            indexPaths.append(indexPath)
        }
        let offset = self.videoPosts.count
        
        if self.isDataLoading == false && offset >= self.postsLimit
        {
            for indexPath in indexPaths{
                if self.tableView.indexPathsForVisibleRows?.contains(indexPath) == true
                {
                    self.isDataLoading = true
                    self.loadData()
                    break
                }
            }
            
        }
        
    }

}
