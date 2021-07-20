//
//  ListPresenter.swift
//  Wallet
//
//  Created by Vu Dang on 7/20/21.
//  Copyright © 2021 Vu Dang. All rights reserved.
//

import Foundation
import RxSwift

typealias ListPresenterDependencies = (
    interactor: ListInteractor,
    router: ListRouterOutput
)

protocol ListViewInputs: AnyObject {
    func reloadData(_ data: ListEntities)
    func indicator(animate: Bool)
}

final class ListPresenter: Presenterable {

    internal var entities: ListEntities?
    private weak var view: ListViewInputs!
    let dependencies: ListPresenterDependencies

    init(view: ListViewInputs,
         dependencies: ListPresenterDependencies)
    {
        self.view = view
        self.dependencies = dependencies
    }
}

extension ListPresenter: ListViewOutputs {
    func viewDidLoad() {
        dependencies.interactor.searchCurrencies()
    }
    
    func searchCurrency(with keyword: String?) {
        dependencies.interactor.searchCurrencies(currency: keyword)
    }
    
    func didSelected(_ currency: Currency) {
        dependencies.router.transitionDetail(currency)
    }
}

extension ListPresenter: ListInteractorOutputs {
    func onSuccessSearch(res: [Currency]) {
        view.reloadData(ListEntities(entryEntity: ListEntryEntity(currencies: res)))
        view.indicator(animate: false)
    }

    func onErrorSearch(error: Error) {
        view.indicator(animate: false)
    }
}
