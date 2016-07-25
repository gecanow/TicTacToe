//
//  ThirdViewController.swift
//  TicTacToe
//
//  Created by Gaby Ecanow on 7/22/16.
//  Copyright © 2016 Gaby Ecanow. All rights reserved.
//

import UIKit

class ThirdViewController: UIViewController {
    
    @IBOutlet var dropLabels: [UIImageView]!
    @IBOutlet weak var background: UIView!
    @IBOutlet weak var comPlayerLevel: UISegmentedControl!
    
    @IBOutlet weak var redBox: UILabel!
    @IBOutlet weak var blackBox: UILabel!
    var redChip : Chip!
    var blackChip : Chip!
    
    @IBOutlet weak var redTurnArrow: UIImageView!
    @IBOutlet weak var blackTurnArrow: UIImageView!
    var fadedAlpha = CGFloat(0.2)
    
    @IBOutlet weak var cell1A: Cell!
    @IBOutlet weak var cell2A: Cell!
    @IBOutlet weak var cell3A: Cell!
    @IBOutlet weak var cell4A: Cell!
    @IBOutlet weak var cell5A: Cell!
    @IBOutlet weak var cell6A: Cell!
    @IBOutlet weak var cell7A: Cell!
    
    @IBOutlet weak var cell1B: Cell!
    @IBOutlet weak var cell2B: Cell!
    @IBOutlet weak var cell3B: Cell!
    @IBOutlet weak var cell4B: Cell!
    @IBOutlet weak var cell5B: Cell!
    @IBOutlet weak var cell6B: Cell!
    @IBOutlet weak var cell7B: Cell!
    
    @IBOutlet weak var cell1C: Cell!
    @IBOutlet weak var cell2C: Cell!
    @IBOutlet weak var cell3C: Cell!
    @IBOutlet weak var cell4C: Cell!
    @IBOutlet weak var cell5C: Cell!
    @IBOutlet weak var cell6C: Cell!
    @IBOutlet weak var cell7C: Cell!
    
    @IBOutlet weak var cell1D: Cell!
    @IBOutlet weak var cell2D: Cell!
    @IBOutlet weak var cell3D: Cell!
    @IBOutlet weak var cell4D: Cell!
    @IBOutlet weak var cell5D: Cell!
    @IBOutlet weak var cell6D: Cell!
    @IBOutlet weak var cell7D: Cell!
    
    @IBOutlet weak var cell1E: Cell!
    @IBOutlet weak var cell2E: Cell!
    @IBOutlet weak var cell3E: Cell!
    @IBOutlet weak var cell4E: Cell!
    @IBOutlet weak var cell5E: Cell!
    @IBOutlet weak var cell6E: Cell!
    @IBOutlet weak var cell7E: Cell!
    
    @IBOutlet weak var cell1F: Cell!
    @IBOutlet weak var cell2F: Cell!
    @IBOutlet weak var cell3F: Cell!
    @IBOutlet weak var cell4F: Cell!
    @IBOutlet weak var cell5F: Cell!
    @IBOutlet weak var cell6F: Cell!
    @IBOutlet weak var cell7F: Cell!
    
    @IBOutlet var dragField: UIPanGestureRecognizer!
    
    var movable : Chip?
    var board : [[Cell]!]!

    var rowOne: [Cell]!
    var rowTwo: [Cell]!
    var rowThree: [Cell]!
    var rowFour: [Cell]!
    var rowFive: [Cell]!
    var rowSix: [Cell]!
    
    var redTurn = true
    
    var boardStr = ""
    var boardFeatures = [[["rrrr"],
                          ["rrro", "orrr", "rror", "rorr"],
                          ["rroo", "roro", "roor", "orro", "oror", "oorr"]],
                         [["bbbb"],
                          ["bbbo", "obbb", "bbob", "bobb"],
                          ["bboo", "bobo", "boob", "obbo", "obob", "oobb"]]]
    
    //==================================================
    // VIEW DID LOAD FUNCTION
    //==================================================
    override func viewDidLoad() {
        super.viewDidLoad()
        
        rowOne =   [cell1A, cell2A, cell3A, cell4A, cell5A, cell6A, cell7A]
        rowTwo =   [cell1B, cell2B, cell3B, cell4B, cell5B, cell6B, cell7B]
        rowThree = [cell1C, cell2C, cell3C, cell4C, cell5C, cell6C, cell7C]
        rowFour =  [cell1D, cell2D, cell3D, cell4D, cell5D, cell6D, cell7D]
        rowFive =  [cell1E, cell2E, cell3E, cell4E, cell5E, cell6E, cell7E]
        rowSix =   [cell1F, cell2F, cell3F, cell4F, cell5F, cell6F, cell7F]
        
        board = [rowSix, rowFive, rowFour, rowThree, rowTwo, rowOne]
        
        redChip = createNewChip("redChipImage", place: redBox.center, color: "r")
        blackChip = createNewChip("blackChipImage", place: blackBox.center, color: "b")
        
        blackTurnArrow.alpha = fadedAlpha
    }
    
    //==================================================
    // Tests for when the touch first hits, and 
    // whether it is on a chip or not
    //==================================================
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let first = touches.first?.locationInView(background)
        movable = nil
        
        let chipToMove : Chip!
        if redTurn { chipToMove = redChip }
        else { chipToMove = blackChip }

        if CGRectContainsPoint(chipToMove.frame, first!) && chipToMove.canMove {
            movable = chipToMove
        }

    }

    //==================================================
    // Drags the chip if the pan gesture is recognized
    // and the first touch was on the chip
    //==================================================
    @IBAction func onDragged(sender: AnyObject) {
        let point = dragField.locationInView(background)
        movable?.center = CGPoint(x: point.x, y: point.y)
        
        var landedOnDropLabel = false
        if dragField.state == UIGestureRecognizerState.Ended && movable != nil {
            for label in dropLabels {
                if CGRectContainsPoint(label.frame, movable!.center) {
                    if fallDown(label.tag, makeMove: true) >= 0 {
                        landedOnDropLabel = true
                    }
                    break
                }
            }
            
            if !landedOnDropLabel {
                // send 'em back!
                if redTurn { movable!.center = redBox.center }
                else { movable!.center = blackBox.center }
            }
        }

    }
    
    //==================================================
    // Handles whether the chip can fall down
    // the column specified, and which row
    // it ends up at
    //==================================================
    func fallDown(col: Int, makeMove: Bool) -> Int {
        
        for checkMe in 0...5 {
            let cell = board[checkMe][col]
            if cell.isEmpty {
                if makeMove && movable != nil {
                    if !redTurn && comPlayerLevel.selectedSegmentIndex > 0 {
                        animateToDrop(col, toCell: cell)
                    } else { animateDownwards(cell) }
                
                    movable!.canMove = false
                    cell.isEmpty = false
                    cell.chipReference = movable
                
                    // now assign redChip/blackChip to a new chip
                    if redTurn {
                        redChip = createNewChip("redChipImage", place: redBox.center, color: "r")
                    } else {
                        blackChip = createNewChip("blackChipImage", place: blackBox.center, color: "b")
                    }
                }
                return checkMe
            }
        }
        return -1
    }
    
    //==================================================
    // Handles the animation from the down
    // arrow to the open cell
    //==================================================
    func animateDownwards(toCell: Cell) {
        movable?.center.x = toCell.center.x
        UIView.animateWithDuration(0.4, animations: {
            self.movable?.center.y = toCell.center.y
            }, completion: { finished in
                
                // NOW CHECK FOR A WINNER
                let rank = self.determineRank()
                
                if rank == 1000000 {
                    self.presentWinAlert("Winner: RED")
                } else if rank == -1000000 {
                    self.presentWinAlert("Winner: BLACK")
                } else if self.checkForStalemate() {
                    self.presentWinAlert("Tie")
                } else {
                    self.redTurn = !self.redTurn
                    if self.redTurn {
                        self.blackTurnArrow.alpha = self.fadedAlpha
                        self.redTurnArrow.alpha = 1.0
                    } else {
                        self.blackTurnArrow.alpha = 1.0
                        self.redTurnArrow.alpha = self.fadedAlpha
                    }
                    
                    if self.comPlayerLevel.selectedSegmentIndex > 0 && !self.redTurn {
                        self.comPlayer()
                    }
                }
        })
    }
    
    //==================================================
    // Create a new chip with image name, at the
    // specified place (redBox or blackBox)
    //==================================================
    func createNewChip(name: String, place: CGPoint, color: String) -> Chip {
        let newChip = Chip(image: UIImage(named: name))
        newChip.frame.size = CGSize(width: 42, height: 42)
        newChip.center = place
        background.addSubview(newChip)
        background.bringSubviewToFront(newChip)
        newChip.colorStr = color
        
        return newChip
    }
    
    //==================================================
    // Resets the board
    //==================================================
    @IBAction func reset(sender: AnyObject) {
        for row in board {
            for cell in row {
                cell.isEmpty = true
                cell.chipReference?.removeFromSuperview()
                cell.chipReference = nil
            }
        }
        redTurn = true
        
        redTurnArrow.alpha = 1.0
        blackTurnArrow.alpha = fadedAlpha
    }
    
    // THE FOLLOWING DEALS WITH WINNING
    
    //==================================================
    // Determines the "rank" of the board:
    // higher ranking is in favor of red, 
    // lower ranking is in favor or black
    //==================================================
    func determineRank() -> Int {
        
        var boardRanking = 0
        evaluateBoard()

        var mult = 1
        
        for rb in boardFeatures {
            for feat in 0..<rb.count {
                for str in rb[feat] {
                    let repeats = occurancesWithin(boardStr, lookUp: str)
                    if feat == 0 && repeats > 0 {
                        return 1000000 * mult
                    } else if feat == 1 {
                        boardRanking += repeats * 1000 * mult
                    } else {
                        boardRanking += repeats * 10 * mult
                    }
                }
            }
            mult = -1
        }
        
        return boardRanking
    }
    
    //==================================================
    // Checks if the board is in a stalement
    //==================================================
    func checkForStalemate() -> Bool {
        for row in board {
            for cell in row {
                if cell.isEmpty { return false }
            }
        }
        return true
    }
    
    //==================================================
    // Handles the winning alert
    //==================================================
    func presentWinAlert(winner: String) {
        let alert = UIAlertController(title: winner, message: nil,preferredStyle: .Alert)
        let alertAction = UIAlertAction(title: "Reset", style: .Default) {
            (action) -> Void in self.reset(self)
        }
        alert.addAction(alertAction)
        presentViewController(alert, animated: true, completion: nil)
    }
    
    //==================================================
    // Evaluates the board:
    // Tests for four-in-a-row, three-in-a-row, and
    // two-in-a-row horizontally, vertically, and
    // diagonally
    //==================================================
    func evaluateBoard() {
        
        boardStr = "-"
        
        // HORIZONTAL
        for row in board {
            for cell in row {
                addCell(cell)
            }
            addCell(nil)
        }
        
        // VERTICAL
        for index in 0...6 {
            for row in board {
                addCell(row[index])
            }
            addCell(nil)
        }
        
        // MAIN DIAGONAL
        for i in [[3,0,3], [4,0,4], [5,0,5], [5,1,5], [5,2,4], [5,3,3]] {
            for ctr in 0...i[2] {
                addCell(board[i[0] - ctr][i[1] + ctr])
            }
            addCell(nil)
        }
        
        // MINOR DIAGONAL
        for i in [[2,0,3], [1,0,4], [0,0,5], [0,1,5], [0,2,4], [0,3,3]] {
            for ctr in 0...i[2] {
                addCell(board[i[0] + ctr][i[1] + ctr])
            }
            addCell(nil)
        }
    }
    
    //==================================================
    // Adds a cell to the board string:
    // Either add an 'r', 'b', 'o', '-', if it's
    // red, black, open, or the end
    //==================================================
    func addCell(cell: Cell?) {
        if cell == nil {
            boardStr += "-"
        } else if cell!.isEmpty {
            boardStr += "o"
        } else {
            boardStr += cell!.chipReference!.colorStr
        }
    }
    
    //==================================================
    // Returns how many occurances of lookUp
    // are in mainString
    //==================================================
    func occurancesWithin(mainString: String, lookUp: String) -> Int {
        var main = mainString
        var range = main.rangeOfString(lookUp)
        var ctr = 0
        
        while String(range) != "nil" {
            ctr += 1
            main = String(main.substringFromIndex(range!.endIndex))
            range = main.rangeOfString(lookUp)
        }
        
        return ctr
    }
    
    // THE FOLLOWING DEALS WITH A COMPUTER PLAYER
    
    //==================================================
    // Handle's the computer player's move
    //==================================================
    func comPlayer() {
        
        movable = blackChip
        
        // LEVEL TWO: Based on the board evaluation
        if comPlayerLevel.selectedSegmentIndex > 1 {
            var nextStepIndex = 0
            var nextStepRank = testFakeChip("b", col: 0)
        
            for i in 1..<dropLabels.count {
                let temp = testFakeChip("b", col: i)
                if (temp != nil && temp < nextStepRank) || (nextStepRank == nil) {
                    nextStepRank = temp
                    nextStepIndex = i
                }
            }
            
            fallDown(nextStepIndex, makeMove: true)
        }
        // LEVEL ONE: pick a random column
        else {
            var column : Int!
            repeat {
                column = Int(arc4random_uniform(UInt32(board.count)))
            } while fallDown(column, makeMove: true) == -1 && column < board.count
        }
    }
    
    //==================================================
    // Handles the animation from the box to the 
    // to the dropLabel
    //==================================================
    func animateToDrop(dropIndex: Int, toCell: Cell) {
        UIView.animateWithDuration(0.5, animations: {
            self.movable?.center = self.dropLabels[dropIndex].center
            }, completion: { finished in
                self.animateDownwards(toCell)
        })
    }
    
    //==================================================
    // Computer Player's strategy:
    // temporarily place the computer player's chip
    // into the column specified and return a value 
    // based on how good that move was
    //==================================================
    func testFakeChip(color: String, col: Int) -> Int? {
        
        let row = fallDown(col, makeMove: false)
        
        if row != -1 {
            // temporarily give board[row][col] a chip that is
            // detected by the code, but not the UI
            let newChip = Chip()
            newChip.colorStr = color
            board[row][col].chipReference = newChip
            board[row][col].isEmpty = false
            
            // check for ranking
            let ranking = determineRank()
            
            // finally, remove the temporary chip and return the ranking
            board[row][col].isEmpty = true
            board[row][col].chipReference = nil
            
            return ranking
        }
        
        return nil
    }
    
}
