//
//  UICollectionView+Extension.swift
//  Pill-IT
//
//  Created by JinwooLee on 3/15/24.
//

import UIKit

extension UICollectionView {

    func deselectAllItems(animated: Bool) {
        guard let selectedItems = indexPathsForSelectedItems else { return }
        
        print("??? ⚠️", selectedItems)
        for indexPath in selectedItems {
            print(indexPath)
            deselectItem(at: indexPath, animated: animated)
        }
    }
}
