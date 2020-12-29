//
//  TodayToDoCell.swift
//  Do_Did_List
//
//  Created by 강민석 on 2020/12/19.
//  Copyright © 2020 MinseokKang. All rights reserved.
//

import UIKit
import Cosmos

class TodayToDoCell: UITableViewCell {

    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var starRating: CosmosView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        starRating.settings.fillMode = .half
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        self.selectionStyle = .none
    }
    
    func setTime(date: Date) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        
        let selectDate = dateFormatter.string(from: date)
        
        timeLabel.text = selectDate
    }
    
    func setIcon(imageData: Data) {
        let image = UIImage(data: imageData)
        
        iconImage.image = image
    }
    
}
