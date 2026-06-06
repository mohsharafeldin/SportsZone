//
//  FavouriteLeague+CoreDataProperties.swift
//  SportsZone
//
//  Created by mohamed sharaf on 02/06/2026.
//
//

import Foundation
import CoreData


extension FavouriteLeague {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FavouriteLeague> {
        return NSFetchRequest<FavouriteLeague>(entityName: "FavouriteLeague")
    }

    @NSManaged public var countryLogo: Data?
    @NSManaged public var countryName: String?
    @NSManaged public var leagueID: Int64
    @NSManaged public var leagueLogo: Data?
    @NSManaged public var leagueName: String?
    @NSManaged public var sportType: String?

}

extension FavouriteLeague : Identifiable {

}
