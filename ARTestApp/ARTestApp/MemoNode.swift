//
//  MemoNode.swift
//  ARTestApp
//
//  Created by satoto on 2018/01/26.
//  Copyright © 2018年 佐藤秀輔. All rights reserved.
//

import Foundation
import RealmSwift

class MemoNode: Object {
    @objc dynamic var eulerAnglesX:Float = 0.0
    @objc dynamic var eulerAnglesY:Float = 0.0
    @objc dynamic var eulerAnglesZ:Float = 0.0
    
    @objc dynamic var cameraPosX:Float = 0.0
    @objc dynamic var cameraPosY:Float = 0.0
    @objc dynamic var cameraPosZ:Float = 0.0
    
    @objc dynamic var memoText = ""
}
