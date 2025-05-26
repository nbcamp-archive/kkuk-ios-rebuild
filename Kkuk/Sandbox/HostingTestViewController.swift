//
//  HostingTestViewController.swift
//  Kkuk
//
//  Created by Yujin Kim on 2025-05-27.
//

import SwiftUI

class HostingTestViewController: UIHostingController<HostingTestView> {
    
    override init(rootView: HostingTestView) {
        super.init(rootView: rootView)
    }
    
    @objc required dynamic init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder, rootView: HostingTestView())
    }
}
