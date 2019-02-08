//
//  ViewController.swift
//  ExtraaNumber
//
//  Created by sadman samee on 13/1/19.
//  Copyright © 2019 sadman samee. All rights reserved.

import UIKit

class HomeVC: UIViewController {
    @IBOutlet var tableView: UITableView!

    lazy var viewModel: HomeVM = {
        HomeVM()
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTableView()
        initVM()
        viewModel.getBooks()
    }

    func initVM() {
        viewModel.showError = { [weak self] alert in
            DispatchQueue.main.async {
                AppHUD.showErrorMessage(alert.message ?? "", title: alert.title ?? "")
            }
        }

        viewModel.showLoadingHUD = { [weak self] isLoading in
            DispatchQueue.main.async {
                if isLoading {
                    AppHUD.showHUD()
                    //                    UIView.animate(withDuration: 0.2, animations: {
                    //                        self?.tableView.alpha = 0.0
                    //                    })
                } else {
                    AppHUD.hideHUD()
                    //                    UIView.animate(withDuration: 0.2, animations: {
                    //                        self?.tableView.alpha = 1.0
                    //                    })
                }
            }
        }

        viewModel.reloadTableView = { [weak self] () in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }
}

// MARK: - TableView

extension HomeVC {
    func setUpTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.register(BookTC.cellNib, forCellReuseIdentifier: BookTC.id)
    }
}

extension HomeVC: UITableViewDataSource {
    func numberOfSections(in _: UITableView) -> Int {
        return 1
    }

    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return viewModel.bookCells.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: BookTC.id) as? BookTC else { return UITableViewCell() }
        cell.selectionStyle = .none
        cell.viewModel = viewModel.bookCells[indexPath.row]
        return cell
    }
}

extension HomeVC: UITableViewDelegate {
    func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
        return 100
    }
}
