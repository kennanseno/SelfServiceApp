//
//  UserCell.swift
//  Self service App
//
//  Created by Kennan Lyle Seno on 23/12/2016.
//  Copyright © 2016 kennanseno. All rights reserved.
//

import UIKit
import Cartography

class UserCell: UITableViewCell {

    // TODO: Learn how to use cartography in here
    
    @IBOutlet weak var fieldName: UILabel!
    @IBOutlet weak var fieldValue: UILabel!
    let lightGreyColor = UIColor(red: 197/255, green: 205/255, blue: 205/255, alpha: 1.0)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.addConstraint()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    func updateUI(_fieldName: String, _fieldValue: String) {
        fieldName.text = _fieldName
        fieldValue.text = _fieldValue
    }
    
    private func addConstraint() {
        fieldName.textAlignment = .left
        fieldName.font = UIFont.boldSystemFont(ofSize: fieldName.font.pointSize)
        fieldValue.textColor = lightGreyColor
        fieldValue.textAlignment = .right
    }
    
}
