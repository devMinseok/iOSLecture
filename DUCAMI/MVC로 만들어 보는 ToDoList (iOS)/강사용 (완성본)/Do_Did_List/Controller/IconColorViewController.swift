//
//  IconColorViewController.swift
//  Do_Did_List
//
//  Created by 강민석 on 2020/03/27.
//  Copyright © 2020 MinseokKang. All rights reserved.
//

import UIKit

class IconColorViewController: UIViewController {
    
    @IBOutlet weak var colorCollectionView: UICollectionView!
    
    let colorModel = ColorModel()
    var colorTable = [Int: [UIColor]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        colorTable = colorModel.createColorTable()
        
        setCollectionView()
    }
    
    func setCollectionView() {
        
        colorCollectionView.delegate = self
        colorCollectionView.dataSource = self
        
        colorCollectionView.allowsSelection = true
        colorCollectionView.showsVerticalScrollIndicator = false
        
        if let layout = colorCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .vertical
            layout.itemSize = CGSize(width: 50, height: 50)
            layout.minimumLineSpacing = 5.0
            layout.minimumInteritemSpacing = 5.0

            layout.sectionInset = UIEdgeInsets(top: 25, left: 55, bottom: 0, right: 55)
        }
    }
}


// MARK: - UICollectionViewDataSource
extension IconColorViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colorTable.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ColorCell", for: indexPath)
        guard let colors = colorTable[indexPath.row] else { fatalError("ColorTable error") }
        cell.setGradientBackgroundColor(colorOne: colors[0], colorTow: colors[1])
        cell.roundCorners(.allCorners, radius: (cell.frame.width / 2))
        
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension IconColorViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let colors = colorTable[indexPath.row] else { fatalError("ColorTable error!") }
        
        let colorDataDict:[String: [UIColor]] = ["colorDict": [colors[0], colors[1]]]
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "colorRefersh"), object: nil, userInfo: colorDataDict)
        
        if let cell = collectionView.cellForItem(at: indexPath) {
            cell.layer.borderColor = UIColor.white.cgColor
            cell.layer.borderWidth = 2.5
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) {
            cell.layer.borderWidth = 0.0
        }
    }
}
