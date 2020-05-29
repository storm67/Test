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
    override func viewDidLoad() {
        super.viewDidLoad()
        layout()
    }
    
    @objc fileprivate func refresher(sender: UIRefreshControl) {
        firstTextField.text = nil
        viewModel.refresh()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.tableView.reloadData()
            sender.endRefreshing()
        }
    }
    fileprivate func tryGetModel() {
        viewModel.getItems(index: viewModel.offset)
        if viewModel.reviewModel != nil {
            DispatchQueue.main.async {
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
        let toolbar = UIToolbar();
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
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        let text = formatter.string(from: datePicker.date)
        secondTextField.text = text
        guard let textOf = secondTextField.text else { return }
        if !textOf.isEmpty {
        filter = true
        viewModel.filter(text: text) {
            DispatchQueue.main.async { [weak self] in
                self?.tableView.reloadData()
            }
        }
        self.view.endEditing(true)
        } else {
        filter = false
        }
}
    @objc fileprivate func cancelDatePicker() {
        //cancel button dismiss datepicker dialog
        self.view.endEditing(true)
    }
    
    
    fileprivate lazy var refresh: UIRefreshControl = {
        let refresh = UIRefreshControl()
        refresh.addTarget(self, action: #selector(refresher(sender:)), for: .valueChanged)
        return refresh
    }()
    
    @objc func editingStart(_ sender: UITextField) {
        guard let text = sender.text else { return }
        if !text.isEmpty {
            filter = true
            viewModel.getItems(text: text) { [weak self] in
                self?.tableView.reloadData()
            }
        } else {
            filter = false
        }
    }

    fileprivate func layout() {
        tableView.register(UINib(nibName: "ReviewCell", bundle: .main), forCellReuseIdentifier: "Cell")
        tryGetModel()
        tableView.refreshControl = refresh
        secondTextField.addTarget(self, action: #selector(showDatePicker), for: .touchUpInside)
        firstTextField.addTarget(self, action: #selector(editingStart(_:)), for: .editingChanged)
        firstTextField.setLeftPaddingPoints(24)
        secondTextField.setLeftPaddingPoints(95)
        showDatePicker()
    }
}
extension FirstViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let model = viewModel.reviewModel?.count else { return 0 }
        return model
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ReviewCell
        cell.viewModel = viewModel.cellViewModel(index: indexPath.row)
        return cell
    }
    
}

extension FirstViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if !filter {
            if indexPath.row == viewModel.reviewModel!.count-1 {
                if viewModel.offset > viewModel.reviewModel!.count-1 {
                    tableView.addLoading(indexPath) { [weak self] in
                        self?.viewModel.getItems(index: self?.viewModel.offset ?? 0)
                        self?.viewModel.signal { [weak self] in
                            DispatchQueue.main.async {
                                self?.tableView.reloadData()
                            }
                        }
                        tableView.stopLoading()
                    }
                }
            }
        }
    }
}
