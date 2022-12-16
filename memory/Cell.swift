import UIKit

class Cell {
    var button: UIButton
    var image: UIImage
    var hiddenImage: UIImage
    var tag: Int
    var active: Bool
    var uncovered: Bool
    
    init(hiddenImage: UIImage, image: UIImage, tag: Int, active: Bool, uncovered: Bool) {
        self.button = UIButton()
        self.hiddenImage = hiddenImage
        self.image = image
        self.button.setBackgroundImage(hiddenImage, for: UIControl.State.normal)
        self.tag = tag
        self.button.tag = tag
        self.active = active
        self.uncovered = uncovered
    }
    
    func setImage(image: UIImage) {
        self.image = image
    }
    
    func setBackgroundImage(image: UIImage) {
        self.button.setBackgroundImage(image, for: UIControl.State.normal)
    }
    
    func setTag(tag: Int) {
        self.tag = tag
        self.button.tag = tag
    }
    
    func setFrame(frame: CGRect) {
        self.button.frame = frame
    }
    
    func changeImageOnClick() {
        self.button.addTarget(self, action: #selector(cellClick), for: UIControl.Event.touchUpInside)
    }
    
    @objc func cellClick(sender: UIButton) {
        self.setBackgroundImage(image: image)
        self.active = true
    }
    
    func uncoverPermanentlyAndDisable() {
        self.setBackgroundImage(image: self.image)
        self.button.isUserInteractionEnabled = false
        self.active = false
        self.uncovered = true
    }
    
    func hide(cells: Array<Array<Cell>>) {
        self.disableCells(cells: cells)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.setBackgroundImage(image: self.hiddenImage)
        }
        self.active = false
        enableCells(cells: cells)
    }
    
    func enableCells(cells: Array<Array<Cell>>) {
        for row in cells {
            for cell in row {
                if !cell.uncovered {
                    cell.button.isUserInteractionEnabled = true
                }
            }
        }
    }
    
    func disableCells(cells: Array<Array<Cell>>) {
        for row in cells {
            for cell in row {
                if cell.button != self.button {
                    cell.button.isUserInteractionEnabled = false
                }
            }
        }
    }
}
