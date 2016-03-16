//
//  GalleryViewController.swift
//  Enterprise contacts
//
//  Created by andrey on 3/1/16.
//  Copyright © 2016 Andrey. All rights reserved.
//

import UIKit

class GalleryViewController: UIViewController, UIScrollViewDelegate {
    let countOfImages = 15
    var currentImageIndex = 0 {
        didSet {
            print("currentImageIndex = \(currentImageIndex)")
        }
    }
    
    var currentImageView: UIImageView = {
        let result = UIImageView(frame: CGRectZero)
        result.contentMode = .ScaleAspectFit
        result.backgroundColor = UIColor.blackColor()
        return result
    }()
    var nextImageView: UIImageView = {
        let result = UIImageView(frame: CGRectZero)
        result.contentMode = .ScaleAspectFit
        result.backgroundColor = UIColor.blackColor()
        return result
    }()
    var preImageView: UIImageView = {
        let result = UIImageView(frame: CGRectZero)
        result.contentMode = .ScaleAspectFit
        result.backgroundColor = UIColor.blackColor()        
        return result
    }()
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    func setupGallery() {
        print("LAYOUT")
        for subview in scrollView.subviews {
            subview.removeFromSuperview()
        }
        let width = scrollView.bounds.width
        let height = scrollView.bounds.height
        scrollView.contentSize = CGSize(width: width * CGFloat(countOfImages), height: height - 10)
        scrollView.contentOffset = CGPointZero
        scrollView.addSubview(nextImageView)
        scrollView.addSubview(currentImageView)
        scrollView.addSubview(preImageView)
        let tapgesture = UITapGestureRecognizer(target: self, action: "didtapScrollView")
        scrollView.addGestureRecognizer(tapgesture)
    }
    
    func didtapScrollView() {
        navigationController?.setNavigationBarHidden(!navigationController!.navigationBar.hidden, animated: true)
        tabBarController!.tabBar.hidden = !tabBarController!.tabBar.hidden
    }
    
    //MARK: - View Controller Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "back"), style: .Plain, target: self, action: "prevImage")
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "forward"), style: .Plain, target: self, action: "nextImage")
        self.navigationItem.title = "Gallery"
        scrollView.pagingEnabled = true
        currentImageIndex = 0
    }
    
    override func viewDidAppear(animated: Bool) {
        setupGallery()
        loadImageAtIndex(currentImageIndex)
    }
    
    func changePage() -> () {
        let x = CGFloat(currentImageIndex) * scrollView.frame.size.width
        scrollView.setContentOffset(CGPointMake(x, 0), animated: true)
    }
    
    func loadImageAtIndex(index: Int) {
        self.navigationItem.leftBarButtonItem?.enabled = true
        self.navigationItem.rightBarButtonItem?.enabled = true
        let width = scrollView.bounds.width
        let height = scrollView.bounds.height
        let nextIndex = index + 1
        let preIndex = index - 1
        let image = UIImage(named: "img\(index)")
        let nextImage = UIImage(named: "img\(nextIndex)")
        let preImage = UIImage(named: "img\(preIndex)")
        if index == 0 {
            currentImageView.frame = CGRect(x: CGFloat(index) * width, y: 0, width: width, height: height)
            currentImageView.image = image
            nextImageView.frame = CGRect(x: CGFloat(nextIndex) * width, y: 0, width: width, height: height)
            nextImageView.image = nextImage
            self.navigationItem.leftBarButtonItem?.enabled = false
        } else if index == countOfImages {
            currentImageView.frame = CGRect(x: CGFloat(index) * width, y: 0, width: width, height: height)
            currentImageView.image = image
            preImageView.frame = CGRect(x: CGFloat(preIndex) * width, y: 0, width: width, height: height)
            preImageView.image = preImage
            self.navigationItem.rightBarButtonItem?.enabled = true
        } else {
            currentImageView.frame = CGRect(x: CGFloat(index) * width, y: 0, width: width, height: height)
            currentImageView.image = image
            nextImageView.frame = CGRect(x: CGFloat(nextIndex) * width, y: 0, width: width, height: height)
            nextImageView.image = nextImage
            preImageView.frame = CGRect(x: CGFloat(preIndex) * width, y: 0, width: width, height: height)
            preImageView.image = preImage
        }
    }
    
    //MARK: - ScrollView Delegate
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
        currentImageIndex = Int(pageNumber)
        changePage()
        loadImageAtIndex(currentImageIndex)
    }
    //MARK: - Actions
    func nextImage(){
        if currentImageIndex + 1 < countOfImages {
            print("nextImage")
            currentImageIndex++
            self.navigationItem.leftBarButtonItem?.enabled = true
        } else {
            self.navigationItem.rightBarButtonItem?.enabled = false
        }
        changePage()
        loadImageAtIndex(currentImageIndex)
    }
    
    func prevImage(){
        if currentImageIndex - 1 >= 0 {
            print("prevImage")
            currentImageIndex--
            self.navigationItem.rightBarButtonItem?.enabled = true
        } else {
            self.navigationItem.leftBarButtonItem?.enabled = false
        }
        changePage()
        loadImageAtIndex(currentImageIndex)
    }
}
