//
//  ToDoTableViewCell.swift
//  Do_Did_List
//
//  Created by 강민석 on 2020/02/24.
//  Copyright © 2020 MinseokKang. All rights reserved.
//

import UIKit
import Cosmos
import M13Checkbox
import VerticalCardSwiper

class ToDoCardCell: CardCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    @IBOutlet weak var starRatingView: CosmosView!
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var navigationItem: UINavigationItem!
    
    @IBOutlet weak var colorView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        starRatingView.settings.fillMode = .half
        setNavigationBar()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = 30
    }
    
    func setNavigationBar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithDefaultBackground()
        appearance.titleTextAttributes = [.foregroundColor: UIColor.black]
        
        self.navigationBar.prefersLargeTitles = true
        self.navigationItem.standardAppearance = appearance
        self.navigationItem.compactAppearance = appearance
        self.navigationItem.scrollEdgeAppearance = appearance
        self.navigationItem.largeTitleDisplayMode = .always
    }
    
    func setBackgroundColor(_ firstColor: String?, _ secondColor: String?) {
        print(UIColor(hex: "#ffe700ff"))
        colorView.backgroundColor = UIColor(hex: firstColor!)
    }
    
    func setIconImage(_ iconImageData: Data) {
        guard let iconImage = UIImage(data: iconImageData) else { return }
        let imageView = UIImageView(image: iconImage)
        
        navigationBar.addSubview(imageView)
        imageView.layer.cornerRadius = Const.ImageSizeForLargeState / 2
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.rightAnchor.constraint(equalTo: navigationBar.rightAnchor, constant: -Const.ImageRightMargin),
            imageView.bottomAnchor.constraint(equalTo: navigationBar.bottomAnchor, constant: -Const.ImageBottomMarginForLargeState),
            imageView.heightAnchor.constraint(equalToConstant: Const.ImageSizeForLargeState),
            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor)
        ])
    }
    
    func setDate(date: Date) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        
        let selectDate = dateFormatter.string(from: date)
        
        navigationItem.title = selectDate
    }
    
    func setTitleLabel(title: String) {
        titleLabel.text = title
    }
    
    func setImportance(ratingCount: Double) {
        starRatingView.rating = ratingCount
    }
    
    func setDescriptionTextView(text: String) {
        descriptionTextView.text = text
    }
    
}

private struct Const {
    /// Image height/width for Large NavBar state
    static let ImageSizeForLargeState: CGFloat = 40
    /// Margin from right anchor of safe area to right anchor of Image
    static let ImageRightMargin: CGFloat = 16
    /// Margin from bottom anchor of NavBar to bottom anchor of Image for Large NavBar state
    static let ImageBottomMarginForLargeState: CGFloat = 12
}
