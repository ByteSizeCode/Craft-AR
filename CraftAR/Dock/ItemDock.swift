//
//  ItemDock.swift
//  CraftAR
//
//  Created by Isaac Raval on 5/16/19.
//  Copyright © 2019 Isaac Raval. All rights reserved.
//

import UIKit

/*Items dock */
extension ViewController {
    
    //Number of cells for collectionView
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.items.count
    }
    
    //Create each cell
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // get a reference to our storyboard cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! DockCell
        
        cell.cellImageView.image = UIImage(named: self.items[indexPath.item]) //Show appropriate image in each cell
        //            cell.backgroundColor = UIColor.cyan // make cell more visible in our example project
        
        return cell
    }
    
    //Detect which cell was tapped on
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // handle tap events
        print("You selected cell #\(indexPath.item)!")
        nameOfBlockSelected = items[indexPath.row]
    }
    
}
