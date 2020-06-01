//
//  FirstViewController.swift
//  Test
//
//  Created by gdml on 26/05/2020.
//  Copyright © 2020 gdml. All rights reserved.
//

import Foundation
import UIKit

class FirstViewController: UIViewController, UITextFieldDelegate {
    var viewModel = ReviewViewModel()
    let datePicker = UIDatePicker()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var firstTextField: UITextField!
    @IBOutlet weak var secondTextField: UITextField!
    
    var filter = false
    var search = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layout()
    }
    
    @objc fileprivate func refresher(sender: UIRefreshControl) {
        sender.beginRefreshing()
        firstTextField.text = nil
        secondTextField.text = nil
        filter = false
        viewModel.refresh()
        DispatchQueue.main.async {
            self.tableView.reloadData()
            sender.endRefreshing()
        }
    }
    
    fileprivate func tryGetModel() {
        viewModel.getItems(index: viewModel.offset)
        if viewModel.reviewModel != nil {
            DispatchQueue.global().async {
                self.viewModel.signal {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    @objc fileprivate func showDatePicker() {
        //Formate Date
        datePicker.datePickerMode = .date
        
        //ToolBar
        let toolbar = UIToolbar(frame: CGRect(origin: .zero, size: CGSize(width: 100, height: 44.0)))
        toolbar.sizeToFit()
        
        //done button & cancel button
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donedatePicker));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker))
        toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)
        
        // add toolbar to textField
        secondTextField.inputAccessoryView = toolbar
        // add datepicker to textField
        secondTextField.inputView = datePicker
        
    }
    
    @objc fileprivate func donedatePicker() {
        tableView.tableFooterView = nil
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        let text = formatter.string(from: datePicker.date)
        secondTextField.text = text
        guard let textOf = secondTextField.text else { return }
        if !textOf.isEmpty {
            viewModel.filter(text: text) {
                self.filter = true
                DispatchQueue.main.async { [weak self] in
                    self?.tableView.reloadData()
                }
            }
            self.view.endEditing(true)
        } else if textOf.isEmpty {
            filter = false
        }
    }
    @objc fileprivate func cancelDatePicker() {
        self.view.endEditing(true)
    }
    
    
    fileprivate var refresh: UIRefreshControl = {
        let refresh = UIRefreshControl()
        refresh.addTarget(self, action: #selector(refresher(sender:)), for: .valueChanged)
        return refresh
    }()
    
    @objc func editingStart(_ sender: UITextField) {
        tableView.tableFooterView = nil
        guard let text = sender.text else { return }
        if !text.isEmpty {
            search = true
            viewModel.getItems(text: text) { [weak self] in
                self?.tableView.reloadData()
                self?.tableView.stopLoading()
            }
        } else {
            search = false
        }
    }
    
    @objc func check() -> UITapGestureRecognizer {
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        guard let text = firstTextField.text else { return tap }
        text.isEmpty ? (filter = false) : (filter = true)
        return tap
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    @objc func textFieldShouldClear(_ textField: UITextField) -> Bool {
        tableView.tableFooterView = nil
        DispatchQueue.main.async {
            self.view.endEditing(true)
        }
        viewModel.refresh()
        secondTextField.text = nil
        filter = false
        return true
    }
    
    
    fileprivate func layout() {
        tableView.register(UINib(nibName: "ReviewCell", bundle: .main), forCellReuseIdentifier: "Cell")
        tryGetModel()
        tableView.refreshControl = refresh
        view.addGestureRecognizer(check())
        secondTextField.addTarget(self, action: #selector(showDatePicker), for: .touchUpInside)
        secondTextField.addTarget(self, action: #selector(textFieldShouldClear(_:)), for: .editingChanged)
        firstTextField.addTarget(self, action: #selector(editingStart(_:)), for: .editingChanged)
        firstTextField.setLeftPaddingPoints(24)
        secondTextField.setLeftPaddingPoints(95)
        showDatePicker()
    }
    
    fileprivate func getIndicator() {
        if tableView.tableFooterView == nil {
            tableView.tableFooterView = UITableView.indicatorView(tableView)()
        }
    }
        fileprivate func getPage(indexPath: IndexPath) {
            getIndicator()
            tableView.addLoading(indexPath) { [weak self] in
                    self?.viewModel.getItems(index: self?.viewModel.offset ?? 0)
                    self?.viewModel.signal { [weak self] in
                        DispatchQueue.main.async {
                            self?.tableView.reloadData()
                            self?.tableView.stopLoading()
                    }
                }
            }
        }
    }


extension FirstViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let model = viewModel.reviewModel?.count else { return 0 }
        return model
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? ReviewCell else { return UITableViewCell()}
        cell.viewModel = viewModel.cellViewModel(index: indexPath.row)
        return cell
    }
    
}

extension FirstViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let reviewModel = viewModel.reviewModel else { return }
        if indexPath.row == reviewModel.count-1 && viewModel.offset > reviewModel.count-1 {
            if !filter && !search {
                getPage(indexPath: indexPath)
            }
        }
    }
}
