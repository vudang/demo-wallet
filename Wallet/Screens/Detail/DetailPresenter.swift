//
//  DetailPresenter.swift
//  Wallet
//
//  Created by Vu Dang on 7/20/21.
//  Copyright © 2021 Vu Dang. All rights reserved.
//

import Foundation
import WebKit

typealias DetailPresenterDependencies = (
    interactor: DetailInteractor,
    router: DetailRouterOutput
)

final class DetailPresenter: Presenterable {

    internal var entities: DetailEntities
    private weak var view: DetailViewInputs!
    let dependencies: DetailPresenterDependencies

    init(entities: DetailEntities,
         view: DetailViewInputs,
         dependencies: DetailPresenterDependencies)
    {
        self.view = view
        self.entities = entities
        self.dependencies = dependencies
    }

}

extension DetailPresenter: DetailViewOutputs {

    func viewDidLoad() {
        view.indicatorView(animate: true)
        view.configure(entities: entities)
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        view.indicatorView(animate: false)
    }
}

extension DetailPresenter: DetailInteractorOutputs {}
