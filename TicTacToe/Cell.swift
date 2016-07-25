//
//  Cell.swift
//  TicTacToe
//
//  Created by Gaby Ecanow on 7/22/16.
//  Copyright © 2016 Gaby Ecanow. All rights reserved.
//

import UIKit

class Cell: UILabel {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    var isEmpty = true
    var chipReference : Chip?
    
    var tempChipColor = ""

}
