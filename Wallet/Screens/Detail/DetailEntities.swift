//
//  DetailEntities.swift
//  Wallet
//
//  Created by Vu Dang on 7/20/21.
//  Copyright © 2021 Vu Dang. All rights reserved.
//

import Foundation

struct DetailEntryEntity {
    let currenct: Currency
    init(currenct: Currency) {
        self.currenct = currenct
    }
}

struct DetailEntities {
    let entryEntity: DetailEntryEntity

    init(entryEntity: DetailEntryEntity) {
        self.entryEntity = entryEntity
    }
}
