//
//  Test2ViewController.swift
//  Pasco
//
//  Created by denis on 7/9/20.
//  Copyright © 2020 GhanaWare. All rights reserved.
//

import SideMenu
import UIKit

class Test2ViewController: UIViewController {
    

    private let sideMenu = SideMenuNavigationController(rootViewController: Test2MenuTableViewController())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        sidemenu stuff
        sideMenu.leftSide = true
        SideMenuManager.default.leftMenuNavigationController = sideMenu
        SideMenuManager.default.addPanGestureToPresent(toView: view)

        // Do any additional setup after loading the view.
    }
    
    @IBAction func didTapMenuButton() {
        present(sideMenu, animated: true)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
