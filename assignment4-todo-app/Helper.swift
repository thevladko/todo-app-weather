//
//  Helper.swift
//  assignment4-todo-app
//
//  Created by Vladislav Kobyakov on 7/16/18.
//  Copyright © 2018 Vladislav Kobyakov. All rights reserved.
//

//contains constansts, helper class, and helper global functions

import UIKit

let attributesForText = [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.bold), NSAttributedStringKey.foregroundColor : UIColor.black]

let attributesForDate = [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 13, weight: UIFont.Weight.semibold), NSAttributedStringKey.foregroundColor : UIColor.gray]

let iconSize = CGSize(width: 30, height: 30)

class Helper {
    static func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }
        
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!.withRenderingMode(.alwaysOriginal)
    }
}

func createGradient(bounds: CGRect) -> CAGradientLayer {
    let color0 = UIColor(red:0.0/255, green:229.0/255, blue:72.0/255, alpha:1.0).cgColor
    let color1 = UIColor(red:0.0/255, green:225.0/255, blue: 138.0/255, alpha:1.0).cgColor
    let color2 = UIColor(red:0.0/255, green:221.0/255, blue: 202.0/255, alpha:1.0).cgColor
    let color3 = UIColor(red:0.0/255, green:170.0/255, blue: 217.0/255, alpha:1.0).cgColor
    

    let gradientLayer = CAGradientLayer()
    gradientLayer.colors = [color0, color1, color2, color3]
    gradientLayer.frame = bounds

    return gradientLayer
}

extension Date {
    func toString( dateFormat format  : String ) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
}
