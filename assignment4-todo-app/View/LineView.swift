//
//  LineView.swift
//  assignment4-todo-app
//
//  Created by Vladislav Kobyakov on 7/17/18.
//  Copyright © 2018 Vladislav Kobyakov. All rights reserved.
//

import UIKit

class LineView: UIView {
    
    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        context!.setLineWidth(2.0)
        context!.setStrokeColor(red: 203/255, green: 201/255, blue: 218/255, alpha: 1)
        context?.move(to: CGPoint(x: 0, y: self.frame.size.height))
        context?.addLine(to: CGPoint(x: self.frame.size.width, y: 0))
        context!.strokePath()
    }
}
