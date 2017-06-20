//
//  NewsFeedViewController.swift
//  FootballList
//
//  Created by user on 03.04.17.
//  Copyright © 2017 AlexeyZayakin. All rights reserved.
//

import UIKit
import Firebase
import EZSwiftExtensions
import Nuke
import RealmSwift
import SKPhotoBrowser


class NewsFeedViewController: BaseViewController
{
    //MARK: - IBO
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    //MARK: - LET
    fileprivate var isDataLoading:Bool = false
    fileprivate var lastPostIndexPath:IndexPath?
    fileprivate var lastPost:Post?
    fileprivate var postsLimit:UInt = 10
    
    private let refreshControl = UIRefreshControl()
    
    override var estimateRowHeight: CGFloat {
        get{
            return 117
        }
    }
    
    //MARK: - VAR
    fileprivate var posts:[Post] = []
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    
        self.tableView.refreshControl = self.refreshControl
        self.refreshControl.addTarget(self, action: #selector(self.loadData), for: .valueChanged)

            self.tableView.registerNib()
            self.setUpSideMenuGesture()
            self.loadData()

        
        NotificationCenter.default.addObserver(self, selector: #selector(self.singlePostDidLiked(notification:)), name: NSNotification.Name(rawValue: "SinglePostDidLike"), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        self.navigationItem.title = "Новости"
    }
    
    func singlePostDidLiked(notification: Notification)
    {
        let post = notification.object as! Post
        let indexOfOldPost = self.posts.index(of: post)
        self.posts[indexOfOldPost!] = post
        
        self.tableView.beginUpdates()
        self.tableView.reloadRows(at: [IndexPath(row: indexOfOldPost!, section: 0)], with: .none)
        self.tableView.endUpdates()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc fileprivate func loadData()
    {
        Firebase.shared.getPostsRef().queryOrderedByKey().queryLimited(toLast: self.postsLimit).observeSingleEvent(of: .value, with: {[weak self] (snapshot) in
            
            self?.posts = []
            
            self?.refreshControl.endRefreshing()
            guard let value: Dict = snapshot.value as? Dict else {
                
                self?.tableView.reloadData()
                return
            }
            
            for key in value.keys
            {
                let singlePost: Dict = value[key] as! Dict
                let post = Post(value: singlePost)
                
                self?.posts.append(post)
            }
            
            self?.lastPostIndexPath = IndexPath(row:(self?.posts.count)! - 1, section:0)
            self?.lastPost = self?.posts.last
            
            self?.tableView.reloadData()
            self?.tableView.isHidden = false
            self?.indicator.stopAnimating()
            
        })
    }
    
    fileprivate func loadNewData()
    {
        
        Firebase.shared.getPostsRef().queryOrderedByKey().queryEnding(atValue: self.lastPost?.key).queryLimited(toLast: self.postsLimit).observeSingleEvent(of: .value, with: {[weak self] (snapshot) in
            
            guard let value: Dict = snapshot.value as? Dict else {
                
                return
            }
            
            for key in value.keys
            {
                let singlePost: Dict = value[key] as! Dict
                let post = Post(value: singlePost)
                if self?.posts.contains(post) == false
                {
                    self?.posts.append(post)
                }
                
            }

            var indexPaths = [IndexPath]()
            for i in (self?.lastPostIndexPath?.row)!..<(self?.posts.count)! - 1
            {
                let indexPath = IndexPath(row: i, section:0)
                indexPaths.append(indexPath)
            }
            
            self?.tableView.insertRows(at: indexPaths, with: .none )
            
            self?.lastPost = self?.posts.last
            self?.lastPostIndexPath = IndexPath(row: (self?.posts.count)! - 1, section: 0)
            
        })
    }
    
    @IBAction func menuButtonTapped(_ sender: Any)
    {
        self.revealViewController().revealToggle(animated: true)
    }
}

//MARK: - UITableViewDataSource

extension NewsFeedViewController: UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell: PostCell = tableView.dequeueReusableCell(PostCell.self, for: indexPath)
        let post = self.posts[indexPath.row]
        cell.delegate = self
        let result = self.postCellHeight(post: post, estimateHeight: self.estimateRowHeight)
        cell.setCell(post: self.posts[indexPath.row])
        cell.setConstains(textH: result.textH, imageH: result.imgH)
        return cell
    }
}

//MARK: - UITableViewDelegate

extension NewsFeedViewController: UITableViewDelegate
{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        let post = self.posts[indexPath.row]
        let result = self.postCellHeight(post: post,estimateHeight: self.estimateRowHeight)
        return result.cellH
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let post: Post = self.posts[indexPath.row]
        
        if post.postType == .defaultType
        {
            var images = [SKPhoto]()
            let photo = SKPhoto.photoWithImageURL(self.posts[indexPath.row].url)
            photo.shouldCachePhotoURLImage = false // you can use image cache by true(NSCache)
            images.append(photo)
            
            let browser = SKPhotoBrowser(photos: images)
            browser.initializePageIndex(0)
            present(browser, animated: true, completion: {})
        }
        else
        {
            let vc = Storyboard.viewControllerWithType(.SinglePostSwipeViewController) as! SinglePostSwipeViewController
            vc.postKey = self.posts[indexPath.row].key
            self.pushVC(vc)
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
            let indexPath = IndexPath(row: self.posts.count - i, section: 0)
            indexPaths.append(indexPath)
        }
        
        if self.isDataLoading == false
        {
            for indexPath in indexPaths{
                if self.tableView.indexPathsForVisibleRows?.contains(indexPath) == true
                {
                    self.isDataLoading = true
                    self.loadNewData()
                    break
                }
            }
            
        }
        
    }

}

//MARK: - NewsFeddCellDelegate

extension NewsFeedViewController: PostCellDelegate
{
    func voteButtonDidTap(post: Post)
    {
        let indexOfOldPost = self.posts.index(of: post)
        self.posts[indexOfOldPost!] = post
    }
}
