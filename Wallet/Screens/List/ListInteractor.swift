//
//  ListInteractor.swift
//  Wallet
//
//  Created by Vu Dang on 7/20/21.
//  Copyright © 2021 Vu Dang. All rights reserved.
//

import RxSwift

protocol ListInteractorOutputs: AnyObject {
    func onSuccessSearch(res: [Currency])
    func onErrorSearch(error: Error)
}

final class ListInteractor: Interactorable {

    weak var presenter: ListInteractorOutputs?
    private lazy var disposeBag = DisposeBag()
    private let searchingSubject = ReplaySubject<String?>.create(bufferSize: 1)
    
    init() {
        self.observerSearching()
    }

    private func observerSearching() {
        let timerSubject = Observable<Int>.timer(RxTimeInterval.seconds(0),
                                                 period: RxTimeInterval.seconds(30),
                                                 scheduler: ConcurrentMainScheduler.instance)
        let searchSubject = searchingSubject.distinctUntilChanged()
            .debounce(RxTimeInterval.milliseconds(500), scheduler: ConcurrentMainScheduler.instance)
            .flatMapLatest { Requester.fetchListCurrency($0) }
        
        Observable.combineLatest(searchSubject, timerSubject)
            .map { $0.0 }
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] res in
                print("aaaa")
                guard let list = res.0 else {
                    return
                }
                self?.presenter?.onSuccessSearch(res: list)
            } onError: { [weak self] error in
                self?.presenter?.onErrorSearch(error: error)
            }.disposed(by: disposeBag)
    }
    
    func searchCurrencies(currency: String? = nil) {
        self.searchingSubject.onNext(currency)
    }
}
