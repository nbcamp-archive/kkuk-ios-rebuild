//
//  And.swift
//  Kkuk
//
//  Created by Yujin Kim on 2023-10-16.
//

import UIKit

protocol And: AnyObject {
    
    associatedtype T
    
    @discardableResult func and(_ block: (T) throws -> Void) rethrows -> T
}

extension And {
    
    @discardableResult
    @inline(__always)
    func and(_ block: (Self) throws -> Void) rethrows -> Self {
        try block(self)
        return self
    }
    
}

extension NSObject: And {}
