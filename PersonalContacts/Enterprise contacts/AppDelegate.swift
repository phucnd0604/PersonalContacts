//
//  AppDelegate.swift
//  Enterprise contacts
//
//  Created by andrey on 2/29/16.
//  Copyright © 2016 Andrey. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var tabBarController: UITabBarController?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        tabBarController = UITabBarController()
        
        let listTableViewController = ListTableViewController()
        let navViewController1 = UINavigationController(rootViewController: listTableViewController)
        navViewController1.tabBarItem = UITabBarItem(title: "List", image: UIImage(named: "List"), tag: 0)
        
        let galleryViewController = GalleryViewController()
        let navViewController2 = UINavigationController(rootViewController: galleryViewController)
        navViewController2.tabBarItem = UITabBarItem(title: "Gallery", image: UIImage(named: "Gallery"), tag: 1)
        
        let serviceViewController = ServiceViewController()
        let navViewController3 = UINavigationController(rootViewController: serviceViewController)
        navViewController3.tabBarItem = UITabBarItem(title: "Service", image: UIImage(named: "Service"), tag: 2)
        
        tabBarController?.viewControllers = [navViewController1, navViewController2, navViewController3]
        window?.rootViewController = UIViewController()
        
        CoreDataStack.constructSQLiteStack(withModelName: "Enterprise_contacts") { result in
            switch result {
            case .Success(let stack):
                dispatch_async(dispatch_get_main_queue()) {
                    CoreDataStackSingleton.sharedInstance.coreDataStack = stack
                    self.window?.rootViewController = self.tabBarController
                }
            case .Failure(let error):
                assertionFailure("\(error)")
            }
        }
        
        window?.makeKeyAndVisible()
        return true
    }
}

