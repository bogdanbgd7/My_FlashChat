//
//  CustomMessageCell.swift
//  My_Flash_Chat
//
//  Created by Bogdan Ponocko on 10/7/18.
//  Copyright © 2018 Bogdan Ponocko. All rights reserved.
//

import UIKit

class CustomMessageCell: UITableViewCell {


    @IBOutlet var messageBackground: UIView!
    @IBOutlet var avatarImageView: UIImageView!
    @IBOutlet var messageBody: UILabel!
    @IBOutlet var senderUsername: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code goes here
        
        
        
    }


}
