//
//  SimplePhoneNumberKit.swift
//  PhoneNumberKit
//
//  Created by Andrew Koshkin on 3/21/18.
//  Copyright © 2018 Roy Marmelstein. All rights reserved.
//

import UIKit

public struct Country {
    public let prefix: String
    public let codeID: String
    public let name: String
}

public class PhoneNumberKitManager {
    
    // MARK: - Public variables
    public static let shared = PhoneNumberKitManager()
    public let countries: [Country]
    public var defaultCountry: Country?
    
    // MARK: - Private variables
    let phoneNumberKit = PhoneNumberKit()
    
    // MARK: - Life cycle
    private init() {
        var defaultCountry: Country?
        var countries = [Country]()
        for territory in phoneNumberKit.metadataManager.territories {
            if let countryName = Locale.current.localizedString(forRegionCode: territory.codeID),
                countryName != "World" {
                var phonePrefix = "+" + String(territory.countryCode)
                if let leadingDigits = phoneNumberKit.leadingDigits(for: territory.codeID) {
                    phonePrefix += leadingDigits
                }
                let country = Country(prefix: phonePrefix, codeID: territory.codeID, name: countryName)
                countries.append(country)
                if territory.codeID == Locale.current.regionCode {
                    defaultCountry = country
                }
            } else {
                print("-----" + territory.codeID)
            }
        }
        self.countries = countries
        self.defaultCountry = defaultCountry ?? countries.first
    }
}
