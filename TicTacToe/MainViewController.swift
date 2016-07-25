//
//  MainViewController.swift
//  TicTacToe
//
//  Created by Gaby Ecanow on 7/23/16.
//  Copyright © 2016 Gaby Ecanow. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var welcomeLabel: UILabel!
    var name = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        welcomeLabel.text = "Welcome, \(name)!"
    }
}
