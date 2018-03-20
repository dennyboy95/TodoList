//
//  Movie+CoreDataProperties.swift
//  MoviesListApp
//
//  Created by robin on 2018-03-15.
//  Copyright © 2018 robin. All rights reserved.
//

import Foundation
import CoreData


extension Movie {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Movie> {
        return NSFetchRequest<Movie>(entityName: "Movie")
    }

    @NSManaged public var name: String?
    @NSManaged public var seen: Bool
    @NSManaged public var year: String?
    @NSManaged public var category: Category?

}
