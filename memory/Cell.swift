import UIKit

class Cell {
    var button: UIButton
    var image: UIImage
    var tag: Int
    
    init(image: UIImage, tag: Int) {
        self.button = UIButton()
        self.image = image
        self.button.setBackgroundImage(image, for: UIControl.State.normal)
        self.tag = tag
        self.button.tag = tag
    }
    
    func setImage(image: UIImage) {
        self.image = image
        self.button.setBackgroundImage(image, for: UIControl.State.normal)
    }
    
    func setTag(tag: Int) {
        self.tag = tag
        self.button.tag = tag
    }
    
    func setFrame(frame: CGRect) {
        self.button.frame = frame
    }
}
