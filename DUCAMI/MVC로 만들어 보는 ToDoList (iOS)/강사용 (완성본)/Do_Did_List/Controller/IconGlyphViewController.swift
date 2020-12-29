//
//  IconGlyphViewController.swift
//  Do_Did_List
//
//  Created by 강민석 on 2020/03/27.
//  Copyright © 2020 MinseokKang. All rights reserved.
//

import UIKit

class IconGlyphViewController: UIViewController {

    @IBOutlet weak var glyphCollectionView: UICollectionView!
    
    var selectedIndexPath: IndexPath?
    
    let iconsNames = ["avatar-1.png", "avatar.png", "back 6.16.26 AM.png", "book.png", "cancel.png", "chat-1.png", "chat-2.png", "chat.png", "copy.png", "dislike 6.16.26 AM.png", "download 6.16.26 AM.png", "download-1.png", "edit 6.16.26 AM.png", "envelope.png", "folder 6.16.26 AM.png", "garbage 6.16.26 AM.png", "glasses.png", "hand.png", "headphones.png", "heart.png", "house 6.16.26 AM.png", "like 6.16.26 AM.png", "link 6.16.26 AM.png", "logout.png", "magnifying-glass.png", "monitor.png", "musical-note.png", "next 6.16.26 AM.png", "next-1.png", "padlock.png", "paper-plane 6.16.26 AM.png", "phone-call.png", "photo-camera 6.16.26 AM.png", "pie-chart.png", "piggy-bank.png", "placeholder 6.16.26 AM.png", "printer.png", "reload.png", "settings 6.16.26 AM.png", "settings-1 6.16.26 AM.png", "share 6.16.26 AM.png", "shopping-bag.png", "shopping-cart.png", "shuffle 6.16.26 AM.png", "speaker 6.16.26 AM.png", "star 6.16.26 AM.png", "tag.png", "upload 6.16.26 AM.png", "upload-1.png", "vector.png"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setCollectionView()
    }
    
    func setCollectionView() {
        glyphCollectionView.dataSource = self
        glyphCollectionView.delegate = self
        
        glyphCollectionView.showsHorizontalScrollIndicator = false
        glyphCollectionView.allowsSelection = true
        glyphCollectionView.allowsMultipleSelection = false
        
        if let layout = glyphCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
            
            layout.itemSize = CGSize(width: 40, height: 40)
            layout.minimumLineSpacing = 5.0
            layout.minimumInteritemSpacing = 5.0
            
            layout.sectionInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        }
    }
}


// MARK: - UICollectionViewDataSource
extension IconGlyphViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return iconsNames.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GlyphCell", for: indexPath)
        
        if let icon = cell.contentView.viewWithTag(100) as? UIImageView {
            icon.image = UIImage(named: self.iconsNames[indexPath.row])
            icon.image = icon.image?.withRenderingMode(.alwaysTemplate)
            cell.contentView.tintColor = UIColor.black
        }
        
        cell.roundCorners(.allCorners, radius: 10)
        
        if let selectedIndexPath = selectedIndexPath {
            if indexPath == selectedIndexPath {
                cell.contentView.backgroundColor = UIColor.systemGray4
            } else {
                cell.contentView.backgroundColor = nil
            }
        }
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension IconGlyphViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("#1", indexPath, #function)
        
        let selectedIcon = UIImage(named: iconsNames[indexPath.row])!
        let iconDict: [String: UIImage] = ["iconDict": selectedIcon]
        NotificationCenter.default.post(name: Notification.Name(rawValue: "iconRefresh"), object: nil, userInfo: iconDict)
        
        selectedIndexPath = indexPath
        
        collectionView.reloadItems(at: [selectedIndexPath!])
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        print("#2", indexPath, #function)
        
        guard let selectedIndexPath = selectedIndexPath else { return true }
        
        if let cell = collectionView.cellForItem(at: selectedIndexPath) {
            cell.contentView.backgroundColor = nil
        }
        return true
    }
}
