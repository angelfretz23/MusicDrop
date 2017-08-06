//
//  BaseCell.swift
//  DropMusic
//
//  Created by Angel Contreras on 8/5/17.
//  Copyright © 2017 Angel Contreras. All rights reserved.
//

import UIKit

class BaseCell:UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews(){
        
    }
}
