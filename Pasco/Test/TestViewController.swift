//
//  TestViewController.swift
//  Pasco
//
//  Created by denis on 7/6/20.
//  Copyright © 2020 GhanaWare. All rights reserved.
//

import SideMenu
import UIKit

class TestViewController: UIViewController {

    private let sideMenu = SideMenuNavigationController(rootViewController: TestMenuTableViewController(with: ["aaa", "bbb"]))
    
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
