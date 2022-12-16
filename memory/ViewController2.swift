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
    var images: Array<UIImage> = Array<UIImage>()
    var moves = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        selectLevel()
    }
    
    func setImagesArray() {
        let fm = FileManager.default
        let path = Bundle.main.resourcePath!

        do {
            let items = try fm.contentsOfDirectory(atPath: path + "/img")

            for item in items {
                images.append(UIImage(named: "img/\(item)")!)
            }
        } catch {
            print("Failed to read directory")
        }
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
        
        let cellsSpaceHeight = (nRows * cellSize) + ((nRows - 1) * MARGIN)
        let marginTop = ((height - cellsSpaceHeight) / 2) + statusBarHeight + navBarHeight
        let marginLeft = (width - ((mCols * cellSize) + ((mCols - 1) * MARGIN))) / 2
        
        let numOfCells = Int(nRows) * Int(mCols)
        var tags: Array<Int> = []
        var tagsAndImages: [Int: UIImage] = [Int: UIImage]()
        var usedImages: Array<UIImage> = []
        setImagesArray()
        
        for num in 0..<(numOfCells / 2) {
            tags.append(num)
            tags.append(num)
            var randomImage: UIImage = UIImage()
            repeat {
                randomImage = images.randomElement()!
            } while (usedImages.contains(randomImage))
            tagsAndImages[num] = randomImage
            usedImages.append(randomImage)
        }
        
        var it = 0
        if (marginLeft > 0.0) {
            for i in stride(from: 0, to: (cellSize + MARGIN) * nRows, by: (cellSize + MARGIN))  {
                cells.append([])
                for j in stride(from: 0, to: (cellSize + MARGIN) * mCols, by: (cellSize + MARGIN)) {
                    tags.shuffle()
                    let cell = Cell(hiddenImage: UIImage(named: "none/none.jpg")!,
                                    image: tagsAndImages[tags.last!]!,
                                    tag: tags.last!,
                                    active: false,
                                    uncovered: false)
                    cell.changeImageOnClick()
                    cell.button.addTarget(self, action: #selector(lookForPair), for: UIControl.Event.touchUpInside)
                    tags.removeLast()
                    cell.setFrame(frame: CGRect(x: marginLeft + j, y: marginTop + i, width: cellSize, height: cellSize))
                    self.view.addSubview(cell.button)
                    cells[it].append(cell)
                }
                it += 1
            }
        } else {
            for i in stride(from: 0, to: (cellSize + MARGIN) * nRows, by: (cellSize + MARGIN))  {
                cells.append([])
                for j in stride(from: MARGIN, to: (cellSize + MARGIN) * mCols, by: (cellSize + MARGIN)) {
                    tags.shuffle()
                    let cell = Cell(hiddenImage: UIImage(named: "none/none.jpg")!,
                                    image: tagsAndImages[tags.last!]!,
                                    tag: tags.last!,
                                    active: false,
                                    uncovered: false)
                    cell.changeImageOnClick()
                    cell.button.addTarget(self, action: #selector(lookForPair), for: UIControl.Event.touchUpInside)
                    tags.removeLast()
                    cell.setFrame(frame: CGRect(x: j, y: marginTop + i, width: cellSize, height: cellSize))
                    self.view.addSubview(cell.button)
                    cells[it].append(cell)
                }
                it += 1
            }
        }
    }
    
    @objc func lookForPair(sender: UIButton) {
        moves += 1
        var gameOver = true
        var activeCells: Array<Cell> = []
        for row in cells {
            for cell in row {
                if cell.active {
                    activeCells.append(cell)
                }
            }
        }
        
        if activeCells.count == 2 {
            if activeCells[0].tag == activeCells[1].tag {
                activeCells[0].uncoverPermanentlyAndDisable()
                activeCells[1].uncoverPermanentlyAndDisable()
            } else {
                activeCells[0].hide(cells: cells)
                activeCells[1].hide(cells: cells)
            }
        }
        
        for row in cells {
            for cell in row {
                if !cell.uncovered {
                    gameOver = false
                }
            }
        }
        
        if (gameOver) {
            let gameOverAlert = UIAlertController(title: "Koniec!",
                                                  message: "Ilość ruchów: \(moves)",
                                                  preferredStyle: .alert)
            gameOverAlert.addAction(UIAlertAction(title: "Powrót",
                                                  style: .default,
                                                  handler: { action in
                self.navigationController?.popToRootViewController(animated: true)
            }))
            
            self.present(gameOverAlert, animated: true)
        }
    }
    
    func reframeGrid(width: Double, height: Double, nRows: Double, mCols: Double) {
        let statusBarHeight = getStatusBarHeight()
        let navBarHeight = self.navigationController!.navigationBar.bounds.height
        var cellSize = (width - ((mCols + 1) * MARGIN)) / mCols
        if (cellSize * nRows >= height) {
            cellSize = (height - ((nRows + 1) * MARGIN)) / nRows
        }
        
        let cellsSpaceHeight = (nRows * cellSize) + ((nRows - 1) * MARGIN)
        let marginTop = ((height - cellsSpaceHeight) / 2) + statusBarHeight + navBarHeight
        let marginLeft = (width - ((mCols * cellSize) + ((mCols - 1) * MARGIN))) / 2
        
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


