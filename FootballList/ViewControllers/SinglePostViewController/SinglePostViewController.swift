//
//  SinglePostViewController.swift
//  FootballList
//
//  Created by user on 26.04.17.
//  Copyright © 2017 AlexeyZayakin. All rights reserved.
//

import UIKit
import Firebase

class SinglePostViewController: BaseViewController
{
    
    //MARK: - IBO
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - LET 
    
    //MARK: - VAR
    fileprivate var postRef: FIRDatabaseReference!
    fileprivate var post: Post?
    fileprivate var banner: RevMobBannerView?
    
    var postKey: String!
    
    override var estimateRowHeight: CGFloat
    {
        get{
            return 217
        }
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        RevmobManager.shared.loadBanner {[weak self] (banner) in
            self?.banner = banner
            
            self?.tableView.reloadData()
        }
        
        self.tableView.registerNib()
        self.tableView.separatorStyle = .none
        
        self.postRef = Firebase.shared.getNewsRef(newsKey: self.postKey)
        self.loadData()
    }
    
    fileprivate func loadData()
    {
        self.postRef.observe(.value, with: {[weak self] (snapshot) in
            
            self?.post = Post(value: snapshot.value!)
            self?.post?.key = (self?.postKey)!
            self?.reloadTable()
        })
    }
    
    fileprivate func reloadTable()
    {
        let singleCellIndexPath = IndexPath(row: 0, section: 0)
        if(self.tableView.cellForRow(at: singleCellIndexPath) != nil)
        {
            self.tableView.reloadRows(at: [singleCellIndexPath], with: .none)
        }
        else
        {
            self.tableView.reloadData()
        }
    }
}

//MAKR: - UITableViewDataSource

extension SinglePostViewController: UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        guard self.post != nil else
        {
            return 0
        }
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell: SinglePostCell = tableView.dequeueReusableCell(SinglePostCell.self, for: indexPath)
        cell.setCell(post: self.post!)
        
        if self.banner != nil && cell.bannerContainerView.subviews.count == 0
        {
            cell.bannerContainerView.addSubview(self.banner!)
        }
        
        let result = self.singlePostCellHeight(post: self.post!, estimateHeight: self.estimateRowHeight)
        cell.setConstains(textH: result.titleH, imageH: result.imgH, desсH: result.descH)
        
        return cell
    }
}

//MAKR: - UITableViewDelegate

extension SinglePostViewController: UITableViewDelegate
{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        let result = self.singlePostCellHeight(post: self.post!, estimateHeight: self.estimateRowHeight)
        return result.cellH
    }
}


