//
//  BaseViewController.swift
//  FootballList
//
//  Created by user on 03.04.17.
//  Copyright © 2017 AlexeyZayakin. All rights reserved.
//

import UIKit
import Nuke
import EZSwiftExtensions

class BaseViewController: UIViewController
{
    
    //MARK: - VAR
    fileprivate var gradientLayer: CAGradientLayer!
    open var estimateRowHeight: CGFloat {
    
        get{
            return 0
        }
    }

    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    open func createGradientLayer()
    {
        self.gradientLayer = CAGradientLayer()
        self.gradientLayer.frame = self.view.bounds
        self.gradientLayer.colors = [COLORS.FIRST_GRADIEND_COLOR.cgColor, COLORS.SECOND_GRADIENT_COLOR.cgColor]
        self.view.layer.insertSublayer(self.gradientLayer, at: 0)
    }
    
    open func makeClearPresentation()
    {
        self.modalPresentationStyle = .fullScreen
        self.modalTransitionStyle = .crossDissolve
        self.transitioningDelegate = self.transitioningDelegate;
        self.view.backgroundColor = .clear
    }
    

    open func setUpSideMenuGesture()
    {
        if self.revealViewController() != nil
        {
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }
    
    open func postCellHeight(post: Post, estimateHeight: CGFloat) -> (textH: CGFloat, imgH: CGFloat, cellH: CGFloat)
    {
        let textH = post.title.height(withConstrainedWidth: self.view.w - 32, font: UIFont(name: "Roboto-Regular", size: 16)!)
        
        let imgH = ((self.view.w - 32) * CGFloat(post.imgH)) / CGFloat(post.imgW)
        let value = (textH - 27) + imgH + estimateHeight
        
        return (textH, imgH, value)
    }
    
    open func singlePostCellHeight(post: Post, estimateHeight: CGFloat) -> (titleH: CGFloat, imgH: CGFloat, descH: CGFloat, cellH: CGFloat)
    {
        let titleH = post.title.height(withConstrainedWidth: self.view.w - 32, font: UIFont(name: "Roboto-Medium", size: 18)!)
        let imgH = ((self.view.w - 32) * CGFloat(post.imgH)) / CGFloat(post.imgW)
        
        let textV = UITextView(frame: CGRect(x: 0, y: 0, w: self.view.w - 32, h: CGFloat.greatestFiniteMagnitude))
        textV.font = UIFont(name: "Roboto-Regular", size: 18)!
        textV.text = post.desc
        
        let descH = textV.contentSize.height

        let cellH = (titleH - 27) + imgH + descH + estimateHeight
        
        return (titleH, imgH, descH, cellH)
    }
    
}

