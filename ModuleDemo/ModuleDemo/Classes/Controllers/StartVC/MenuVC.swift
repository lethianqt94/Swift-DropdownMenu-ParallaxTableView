//
//  MenuVC.swift
//  ModuleDemo
//
//  Created by Le Thi An on 3/1/16.
//  Copyright © 2016 Le Thi An. All rights reserved.
//

import UIKit

class MenuVC: UIViewController {
    
    //MARK: Outlets & Variables
    
    @IBOutlet weak var selectedCellLabel: UILabel!
    var menuView: DropdownMenuView!
    
    var stepper: KWStepper!
    
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var decrementButton: UIButton!
    @IBOutlet weak var incrementButton: UIButton!
    
    let items = ["Most Popular", "Latest", "Trending", "Nearest", "Top Picks"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        configureStepper()
        configureSwitches()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBar.translucent = false
    }

    // MARK: - Configuration
    
    func configureStepper() {
        
        stepper = KWStepper(decrementButton: decrementButton, incrementButton: incrementButton)
        stepper.maximumValue = 9
        stepper.valueChangedCallback = { [unowned self] stepper in
            self.countLabel.text = String(format: "%.f", stepper.value)
        }
    }
    
    // MARK: - Helper
    
    private func configureSwitches() {
        stepper.wraps = true
        stepper.autoRepeat = true
    }

    // MARK: - Actions
    
    @IBAction func tappedButton(sender: AnyObject) {
        let scrollView = ParallaxScrollViewVC()
        self.navigationController?.pushViewController(scrollView, animated: true)
    }
    
    @IBAction func tappedToShowMenu(sender: AnyObject) {
        if menuView == nil {
//            menuView = DropdownMenuView(uSelection: Selection.Single, uIconType: IconType.None, uMenuTitles: items)
            menuView = DropdownMenuView(uSelection: Selection.Multiple, icon: UIImage(named: "img_mid.png")!, uMenuTitles: items)
            menuView.delegate = self
            
            menuView.translatesAutoresizingMaskIntoConstraints = false
            let consLeftMenuViewToSuperView = NSLayoutConstraint(item: menuView,
                attribute: .Left,
                relatedBy: .Equal,
                toItem: self.view,
                attribute: .Left,
                multiplier: 1,
                constant: 0)
            
            let consRightMenuViewToSuperView = NSLayoutConstraint(item: menuView,
                attribute: .Right,
                relatedBy: .Equal,
                toItem: self.view,
                attribute: .Right,
                multiplier: 1,
                constant: 0)
            
            let consTopMenuViewToSuperView = NSLayoutConstraint(item: menuView,
                attribute: .Top,
                relatedBy: .Equal,
                toItem: self.view,
                attribute: .Top,
                multiplier: 1,
                constant: 0)
            
            let consBottomMenuViewToSuperView = NSLayoutConstraint(item: menuView,
                attribute: .Bottom,
                relatedBy: .Equal,
                toItem: self.view,
                attribute: .Bottom,
                multiplier: 1,
                constant: 0)
            
//            menuView.frame = CGRectMake(0, 0, self.view.frame.width, self.view.frame.height)
            menuView.tableView.frame = CGRectMake(selectedCellLabel.frame.origin.x, selectedCellLabel.frame.maxY + 10, selectedCellLabel.frame.width, menuView.cellHeight*CGFloat(items.count))
//            menuView.setBg(UIColor.clearColor())
//            menuView.setTableBorderColor(UIColor.greenColor())
//            menuView.setColorHighlight(UIColor.redColor())
//            menuView.setColorNomal(UIColor.blueColor())
            menuView.show()
            self.view.addSubview(menuView)
            self.view.addConstraints([consLeftMenuViewToSuperView, consRightMenuViewToSuperView, consTopMenuViewToSuperView, consBottomMenuViewToSuperView])
        } else if menuView.alpha == 1 {
            menuView.hide()
        } else {
            menuView.show()
        }
    }
    
}

extension MenuVC:DropdownMenuDelegate {
    
    func menuDidSelectedAtIndex(index: Int) {
        selectedCellLabel.text = items[index]
    }
}
