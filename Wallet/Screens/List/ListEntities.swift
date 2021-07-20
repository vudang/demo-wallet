//
//  ListEntities.swift
//  Wallet
//
//  Created by Vu Dang on 7/20/21.
//  Copyright © 2021 Vu Dang. All rights reserved.
//

import Foundation

struct ListEntryEntity {
    let currencies: [Currency]?
}

struct ListEntities {
    let entryEntity: ListEntryEntity

    init(entryEntity: ListEntryEntity) {
        self.entryEntity = entryEntity
    }
}
