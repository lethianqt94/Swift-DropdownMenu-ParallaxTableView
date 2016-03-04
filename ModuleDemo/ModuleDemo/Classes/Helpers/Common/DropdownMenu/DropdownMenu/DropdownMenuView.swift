//
//  DropdownMenuView.swift
//  ModuleDemo
//
//  Created by An Le on 3/1/16.
//  Copyright © 2016 Le Thi An. All rights reserved.
//

import UIKit

enum Selection {
    case Default
    case Single
    case Multiple
}

enum IconType {
    case Default
    case None
    case Custom
}

@objc protocol DropdownMenuDelegate: NSObjectProtocol{
    
    optional func menuDidSelectedAtIndex(index: Int)
    optional func menuDidSelectedAtIndexs(indexItems: [Int])
}

class DropdownMenuView: UIView {
    
    //MARK: Outlets
    
    @IBOutlet weak var view: UIView!
    
    @IBOutlet weak var fadeView: UIView!
    
    @IBOutlet weak var tableView: UITableView!
    
//    var selectRowAtIndexPathHandler: ((indexPath: Int) -> ())?
    
    weak var delegate:DropdownMenuDelegate?
    
    var selection:Selection = .Default
    var iconType:IconType = .Default
    
    var cellIcon:UIImage = UIImage(named: "img_header.png")!
    
    var menuTitles:[String] = []
    
    var currentItems:[Int] = []
    
    var cellHeight:CGFloat = 30
    
    var textColorNomal:UIColor = UIColor.blackColor()
    var textColorHighlight:UIColor  = UIColor(red: 76/266, green: 175/266, blue: 80/255, alpha: 1)
    
    var isShown: Bool = false
    
    //MARK: Lifecycle
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
//    MARK: Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubviews()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        initSubviews()
    }
    
    func initSubviews() {
        if let nibsView = NSBundle.mainBundle().loadNibNamed("DropdownMenuView", owner: self, options: nil) as? [UIView] {
            let nibRoot = nibsView[0]
            self.addSubview(nibRoot)
            nibRoot.frame = self.bounds
        }
        
        tableView.registerNib(UINib(nibName: "DropdownMenuCell", bundle: nil), forCellReuseIdentifier: "DropdownMenuCell")
        tableView.contentSize.height = cellHeight*CGFloat(menuTitles.count)
        tableView.scrollEnabled = false
        
        tableView.layer.borderWidth = 1
        tableView.layer.borderColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1).CGColor
        tableView.clipsToBounds = false
        tableView.layer.masksToBounds = false
        tableView.layer.shadowColor = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1).CGColor
        tableView.layer.shadowOffset = CGSizeMake(0, 0)
        tableView.layer.shadowRadius = 2.0
        tableView.layer.shadowOpacity = 1
        
//        self.selectRowAtIndexPathHandler = { (indexPath: Int) -> () in
//        }
        
        switch (selection) {
        case Selection.Multiple:
            tableView.allowsMultipleSelection = true
        default:
            tableView.allowsMultipleSelection = false
        }
    }
    
    convenience init(uSelection: Selection = Selection.Default, uIconType:IconType = IconType.Default, uMenuTitles:[String]) {
        self.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        self.selection = uSelection
        self.iconType = uIconType
        self.menuTitles = uMenuTitles
    }
    
    convenience init(uSelection: Selection = Selection.Default, icon:UIImage, uMenuTitles:[String]) {
        self.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        self.selection = uSelection
        self.iconType = IconType.Custom
        self.cellIcon = icon
        self.menuTitles = uMenuTitles
    }
    
    
//    MARK: show/hide action
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        hide()
    }
    
    internal func show() {
        if self.isShown == false {
            self.showMenu()
        }
    }
    
    internal func hide() {
        if self.isShown == true {
            self.hideMenu()
        }
    }
    
    func showMenu() {
        self.isShown = true
        
        tableView.reloadData()
        
        // Animation
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.alpha = 1
        })
    }
    
    func hideMenu() {
        self.isShown = false
        
        // Animation
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.alpha = 0
        })
    }
    
//    MARK: setup View
    
    internal func setIconImage(image:UIImage) {
        self.cellIcon = image
    }
    
    internal func setBg(color:UIColor) {
        fadeView.backgroundColor = color
    }
    
    internal func setTableBorderColor(color:UIColor) {
        tableView.layer.borderColor = color.CGColor
    }
    
    internal func setColorHighlight(color:UIColor) {
        textColorHighlight = color
    }
    
    internal func setColorNomal(color:UIColor) {
        textColorNomal = color
    }
    
}

//MARK: UITableViewDelegate methods
extension DropdownMenuView: UITableViewDelegate {
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return cellHeight
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if selection == Selection.Multiple {
            if currentItems.count == 0 {
                currentItems.append(indexPath.row)
            } else {
                
                var isOld:Bool = false
                
                for index in currentItems {
                    if index == indexPath.row {
                        isOld = true
                        break
                    } else {
                        isOld = false
                    }
                    
                }
                
                if isOld == false {
                    currentItems.append(indexPath.row)
                } else {
                    tableView.deselectRowAtIndexPath(indexPath, animated: true)
                    currentItems.removeAtIndex(currentItems.indexOf(indexPath.row)!)
                }
            }
        } else {
            currentItems = []
            currentItems.append(indexPath.row)
            if let d = delegate where d.respondsToSelector("menuDidSelectedAtIndex:") {
                d.menuDidSelectedAtIndex!(indexPath.row)
            }
            self.hide()
        }
        
        if let d = delegate where d.respondsToSelector("menuDidSelectedAtIndexs:") {
            d.menuDidSelectedAtIndexs!(currentItems)
        }
//        delegate!.menuDidSelectedAtIndex!(indexPath.row)
//        selectRowAtIndexPathHandler!(indexPath: indexPath.row)
        tableView.reloadData()
        
    }
    
}


//MARK: UITableViewDataSource methods
extension DropdownMenuView: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuTitles.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("DropdownMenuCell") as! DropdownMenuCell
        cell.lblTitle.text = menuTitles[indexPath.row]
        cell.initWithItemType(iconType, iconCustom: cellIcon)
        
        var isSelected:Bool = false
        
        for index in currentItems {
            if index == indexPath.row {
                isSelected = true
                break
            } else {
                isSelected = false
            }
        }
        if isSelected == true {
            cell.imvIcon.hidden = false
            cell.lblTitle.textColor = textColorHighlight
        } else {
            cell.imvIcon.hidden = true
            cell.lblTitle.textColor = textColorNomal
        }
        
        return cell
    }
}

