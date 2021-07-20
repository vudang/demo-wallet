//
//  ListViewController.swift
//  Wallet
//
//  Created by Vu Dang on 7/20/21.
//  Copyright © 2021 Vu Dang. All rights reserved.
//

import UIKit
import RxRelay
import RxSwift
import RxCocoa

protocol ListViewOutputs: AnyObject {
    func viewDidLoad()
    func searchCurrency(with keyword: String?)
    func didSelected(_ currency: Currency)
}

final class ListViewController: UIViewController {

    internal var presenter: ListViewOutputs?
    internal let dataSubject = BehaviorRelay<[Currency]>.init(value: [])
    private lazy var disposeBag = DisposeBag()

    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var indicatorView: UIActivityIndicatorView!
    private var searchBar: UISearchBar?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
        presenter?.viewDidLoad()
    }
    
    private func configure() {
        view.backgroundColor = .white
        navigationItem.title = "Wallet"
        configureTableView()
        configureSearchBar()
    }
    
    private func configureTableView() {
        let cellIdentifier = String(describing: ListTableViewCell.self)
        tableView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: cellIdentifier)
        
        dataSubject.observe(on: MainScheduler.instance)
            .bind(to: tableView.rx.items(cellIdentifier: cellIdentifier, cellType: ListTableViewCell.self)) { (row, data, cell) in
                cell.configure(with: data)
            }.disposed(by: disposeBag)
        
        tableView.rx.modelSelected(Currency.self)
            .observe(on: MainScheduler.instance)
            .bind { [weak self] currency in
                self?.presenter?.didSelected(currency)
            }.disposed(by: disposeBag)
    }
    
    private func configureSearchBar() {
        searchBar?.rx.text
            .distinctUntilChanged()
            .bind(onNext: { [weak self] keyword in
                self?.presenter?.searchCurrency(with: keyword)
            }).disposed(by: disposeBag)
    }
}

extension ListViewController: ListViewInputs {
    func reloadData(_ data: ListEntities) {
        dataSubject.accept(data.entryEntity.currencies ?? [])
    }
    
    func indicator(animate: Bool) {
        DispatchQueue.main.async { [weak self] in
            self?.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: animate ? 50 : 0, right: 0)
            _ = animate ? self?.indicatorView.startAnimating() : self?.indicatorView.stopAnimating()
        }
    }
}

extension ListViewController: Viewable {}
