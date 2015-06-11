//
//  CHCategoryModel.swift
//  Cherry2
//
//  Created by Kenny Tang on 6/10/15.
//  Copyright © 2015 Kenny Tang. All rights reserved.
//

import Foundation
import CoreData

@objc(CHCategoryModel)
public class CHCategoryModel: NSManagedObject {

    @NSManaged var categoryID: String?
    @NSManaged var name: String?

}
