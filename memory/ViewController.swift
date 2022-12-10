//
//  ViewController.swift
//  memory
//
//  Created by Wojciech Wysocki on 18/11/2022.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var levelSegmentedControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.addBackground()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let dest = segue.destination as! ViewController2
        dest.level = levelSegmentedControl.selectedSegmentIndex
    }
}



