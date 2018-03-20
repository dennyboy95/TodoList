//
//  Category+CoreDataProperties.swift
//  MoviesListApp
//
//  Created by robin on 2018-03-15.
//  Copyright © 2018 robin. All rights reserved.
//

import Foundation
import CoreData


extension Category {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Category> {
        return NSFetchRequest<Category>(entityName: "Category")
    }

    @NSManaged public var name: String?
    @NSManaged public var movie: NSSet?

}

// MARK: Generated accessors for movie
extension Category {

    @objc(addMovieObject:)
    @NSManaged public func addToMovie(_ value: Movie)

    @objc(removeMovieObject:)
    @NSManaged public func removeFromMovie(_ value: Movie)

    @objc(addMovie:)
    @NSManaged public func addToMovie(_ values: NSSet)

    @objc(removeMovie:)
    @NSManaged public func removeFromMovie(_ values: NSSet)

}
