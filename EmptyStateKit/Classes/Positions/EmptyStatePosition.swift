//
//  EmptyStatePosition.swift
//  StateView
//
//  Created by Alberto Aznar de los Ríos on 24/05/2019.
//  Copyright © 2019 Alberto Aznar de los Ríos. All rights reserved.
//

import UIKit

public typealias MarginTop = CGFloat
// 别名
public typealias MarginBottom = CGFloat

// 位置配置
public struct EmptyStatePosition {
    var view: EmptyStateViewPosition = .center
    var text: EmptyStateTextPosition = .center
    var image: EmptyStateImagePosition = .top
    
    public init(view: EmptyStateViewPosition? = nil, text: EmptyStateTextPosition? = nil, image: EmptyStateImagePosition? = nil) {
        self.view = view ?? .center
        self.text = text ?? .center
        self.image = image ?? .top
    }
}

// view
public enum EmptyStateViewPosition {
    case top
    case center
    case bottom
}

// text
public enum EmptyStateTextPosition {
    case left
    case center
    case right
}

//
public enum EmptyStateImagePosition {
    case top
    case bottom
    case cover(MarginTop?, MarginBottom?) 
}
