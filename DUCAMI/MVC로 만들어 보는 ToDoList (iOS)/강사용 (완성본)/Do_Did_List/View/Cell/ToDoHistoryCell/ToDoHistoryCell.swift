//
//  ToDoHistoryCell.swift
//  Do_Did_List
//
//  Created by 강민석 on 2020/12/19.
//  Copyright © 2020 MinseokKang. All rights reserved.
//

import UIKit
import Cosmos
import M13Checkbox

class ToDoHistoryCell: UITableViewCell {

    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var starRatingView: CosmosView!
    @IBOutlet weak var checkboxView: M13Checkbox!
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        starRatingView.settings.fillMode = .half
        checkboxView.isUserInteractionEnabled = false
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

//        present(detailViewController)
    }
    
    func setTime(timestamp: Date) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        
        let selectDate = dateFormatter.string(from: timestamp)
        
        timeLabel.text = selectDate
    }
    
    func setIcon(imageData: Data) {
        iconImageView.image = UIImage(data: imageData)
    }
    
    func setCheckbox(isDone: Bool) {
        if isDone {
            checkboxView.checkState = .checked
        } else {
            checkboxView.checkState = .unchecked
        }
    }

}
