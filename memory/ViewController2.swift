//
//  ViewController2.swift
//  memory
//
//  Created by Wojciech Wysocki on 25/11/2022.
//

import UIKit

class ViewController2: UIViewController {
    @IBOutlet weak var gridView: UIView!
    let MARGIN = 10.0;
    var level = 0;
    var cells: Array<Array<Cell>> = [[]]

    override func viewDidLoad() {
        super.viewDidLoad()
        selectLevel()
    }
    
    func selectLevel() {
        let screenSize: CGRect = UIScreen.main.bounds
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        let navBarHeight = self.navigationController!.navigationBar.bounds.height
        let statusBarHeight = getStatusBarHeight()
        
        let workSpaceHeight = screenHeight - navBarHeight - statusBarHeight
        
        if (level == 0) {
            createGrid(width: screenWidth, height: workSpaceHeight, nRows: 3, mCols: 4)
        } else if (level == 1) {
            createGrid(width: screenWidth, height: workSpaceHeight, nRows: 4, mCols: 7)
        }
    }
    
    func createGrid(width: Double, height: Double, nRows: Double, mCols: Double) {
        let statusBarHeight = getStatusBarHeight()
        let navBarHeight = self.navigationController!.navigationBar.bounds.height
        var cellSize = (width - ((mCols + 1) * MARGIN)) / mCols
        if (cellSize * nRows >= height) {
            cellSize = (height - ((nRows + 1) * MARGIN)) / nRows
        }
        var tag = 0
        
        let cellsSpaceHeight = (nRows * cellSize) + ((nRows - 1) * MARGIN)
        let marginTop = ((height - cellsSpaceHeight) / 2) + statusBarHeight + navBarHeight
        let marginLeft = (width - ((mCols * cellSize) + ((mCols + 1) * MARGIN))) / 2
        
        var it = 0
        if (marginLeft > 0.0) {
            for i in stride(from: 0, to: (cellSize + MARGIN) * nRows, by: (cellSize + MARGIN))  {
                cells.append([])
                for j in stride(from: 0, to: (cellSize + MARGIN) * mCols, by: (cellSize + MARGIN)) {
                    let cell = Cell(image: UIImage(named: "img/none.jpg")!, tag: tag)
                    cell.setFrame(frame: CGRect(x: marginLeft + j, y: marginTop + i, width: cellSize, height: cellSize))
                    self.view.addSubview(cell.button)
                    cells[it].append(cell)
                    tag += 1
                }
                it += 1
            }
        } else {
            for i in stride(from: 0, to: (cellSize + MARGIN) * nRows, by: (cellSize + MARGIN))  {
                cells.append([])
                for j in stride(from: MARGIN, to: (cellSize + MARGIN) * mCols, by: (cellSize + MARGIN)) {
                    let cell = Cell(image: UIImage(named: "img/none.jpg")!, tag: tag)
                    cell.setFrame(frame: CGRect(x: j, y: marginTop + i, width: cellSize, height: cellSize))
                    self.view.addSubview(cell.button)
                    cells[it].append(cell)
                    tag += 1
                }
                it += 1
            }
        }

        for row in cells {
            for cell in row {
                cell.button.addTarget(self, action: #selector(jazda), for: UIControl.Event.touchUpInside)
            }
        }
    }
    
    @objc func jazda(sender: UIButton) {
        print(sender.tag)
    }
    
    func reframeGrid(width: Double, height: Double, nRows: Double, mCols: Double) {
        let statusBarHeight = getStatusBarHeight()
        let navBarHeight = self.navigationController!.navigationBar.bounds.height
        var cellSize = (width - ((mCols + 1) * MARGIN)) / mCols
        if (cellSize * nRows >= height) {
            cellSize = (height - ((nRows - 1) * MARGIN)) / nRows
        }
        
        let cellsSpaceHeight = (nRows * cellSize) + ((nRows - 1) * MARGIN)
        let marginTop = ((height - cellsSpaceHeight) / 2) + statusBarHeight + navBarHeight
        let marginLeft = (width - ((mCols * cellSize) + ((mCols + 1) * MARGIN))) / 2
        
        var it_1 = 0
        var it_2 = 0
        
        if (marginLeft > 0.0) {
            for i in stride(from: 0, to: (cellSize + MARGIN) * nRows, by: (cellSize + MARGIN))  {
                cells.append([])
                for j in stride(from: 0, to: (cellSize + MARGIN) * mCols, by: (cellSize + MARGIN)) {
                    cells[it_1][it_2].setFrame(frame: CGRect(x: marginLeft + j, y: marginTop + i, width: cellSize, height: cellSize))
                    it_2 += 1
                }
                it_1 += 1
                it_2 = 0
            }
        } else {
            for i in stride(from: 0, to: (cellSize + MARGIN) * nRows, by: (cellSize + MARGIN))  {
                cells.append([])
                for j in stride(from: MARGIN, to: (cellSize + MARGIN) * mCols, by: (cellSize + MARGIN)) {
                    cells[it_1][it_2].setFrame(frame: CGRect(x: j, y: marginTop + i, width: cellSize, height: cellSize))
                    it_2 += 1
                }
                it_1 += 1
                it_2 = 0
            }
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        let screenSize: CGRect = UIScreen.main.bounds
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        let navBarHeight = self.navigationController!.navigationBar.bounds.height
        let statusBarHeight = getStatusBarHeight()
        
        let workSpaceHeight = screenHeight - navBarHeight - statusBarHeight
        var nRows: Double = 3.0
        var mCols: Double = 4.0
        
        if (level == 0) {
            nRows = 3.0
            mCols = 4.0
        } else if (level == 1) {
            nRows = 4.0
            mCols = 7.0
        }
        
        reframeGrid(width: screenWidth, height: workSpaceHeight, nRows: nRows, mCols: mCols)
    }
    
    func getStatusBarHeight() -> CGFloat {
        var statusBarHeight: CGFloat = 0
        if #available(iOS 13.0, *) {
            let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
            statusBarHeight = window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        } else {
            statusBarHeight = UIApplication.shared.statusBarFrame.height
        }
        return statusBarHeight
    }
}


