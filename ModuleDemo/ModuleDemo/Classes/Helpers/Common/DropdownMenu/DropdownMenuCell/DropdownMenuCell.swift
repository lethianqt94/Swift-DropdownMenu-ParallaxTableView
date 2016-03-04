//
//  DropdownMenuCell.swift
//  ModuleDemo
//
//  Created by An Le on 3/1/16.
//  Copyright © 2016 Le Thi An. All rights reserved.
//

import UIKit

class DropdownMenuCell: UITableViewCell {
    
    //MARK: Outlets & Variabless

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imvIcon: UIImageView!
    
    var iconType:IconType = IconType.Default
    var iconImgCustom:UIImage!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    internal func initWithItemType(itemType:IconType, iconCustom:UIImage) {
        self.iconType = itemType
        self.iconImgCustom = iconCustom
        self.imvIcon.hidden = true
        initImage()
    }
    
    private func initImage() {
        switch(iconType) {
        case IconType.Custom:
            imvIcon.image = iconImgCustom
        case IconType.Default:
            imvIcon.image = UIImage(named: "img_header.png")
        default:
            imvIcon.image = nil
            imvIcon.backgroundColor = self.backgroundColor
        }
    }
    
}