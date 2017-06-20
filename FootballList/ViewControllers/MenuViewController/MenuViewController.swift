//
//  MenuViewController.swift
//  FootballList
//
//  Created by user on 05.04.17.
//  Copyright © 2017 AlexeyZayakin. All rights reserved.
//

import UIKit

class MenuViewController: BaseViewController
{
    
    //MARK: - IBA
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.tableView.registerNib()
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
        //self.view.backgroundColor = COLORS.MENU_BACKGROUND_COLOR
    }
}

extension MenuViewController: UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return STRINGS.MENU_ITEMS.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell: MenuCell = tableView.dequeueReusableCell(MenuCell.self, for: indexPath)
        cell.mainTitleLabel.text = STRINGS.MENU_ITEMS[indexPath.row]
        return cell
    }
}

extension MenuViewController: UITableViewDelegate
{
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        return 160
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        let headerViw: MenuHeaderCell = tableView.dequeueReusableCell(withIdentifier: "MenuHeaderCell") as! MenuHeaderCell
        headerViw.setCell(user: Facebook.shared.getUser())
        return headerViw
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        switch indexPath.row
        {
        case 0:
            self.revealViewController().pushFrontViewController(Storyboard.viewControllerWithType(.NewsFeedViewController), animated: true)
            break;

        case 1:
            self.revealViewController().pushFrontViewController(Storyboard.viewControllerWithType(.VideoFeedViewController), animated: true)
            break;
        default:
            break;
        }
        
    }
}
