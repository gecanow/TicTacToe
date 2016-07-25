//
//  OpeningViewController.swift
//  TicTacToe
//
//  Created by Gaby Ecanow on 7/23/16.
//  Copyright © 2016 Gaby Ecanow. All rights reserved.
//

import UIKit

class OpeningViewController: UIViewController {

    @IBOutlet weak var nameField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let dvc = segue.destinationViewController as! MainViewController
        dvc.name = nameField.text!
    }

}
