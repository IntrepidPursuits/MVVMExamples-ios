//
//  EditProfileViewController.swift
//  TwoWayBinding
//
//  Created by Benjamin Wu on 11/28/16.
//  Copyright © 2016 Intrepid Pursuits. All rights reserved.
//

import UIKit
import RxSwift
import Intrepid

/**
 NOTE: Normally you would extract this into its own file, but it lives here for
 the purpose of discovery.  This is how easy it is to make a reactive extension.
 RxCocoa has plenty of examples, so if you need to create a custom one, you can
 reference that codebase as a launching point.
 */
import RxCocoa
extension Reactive where Base: UIView {
    var backgroundColor: UIBindingObserver<Base, UIColor?> {
        return UIBindingObserver(UIElement: self.base) { view, color in
            view.backgroundColor = color
        }
    }
}

class EditProfileViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var dateOfBirthTextField: UITextField!
    @IBOutlet private weak var genderTextField: UITextField!
    @IBOutlet private weak var logButton: UIButton!

    let profile = Profile()
    let viewModel: EditProfileViewModel

    let datePicker = UIDatePicker()
    let genderPicker = UIPickerView()

    private let disposeBag = DisposeBag()
    private let dismissTapGesture = UITapGestureRecognizer()

    init(profile: Profile) {
        viewModel = EditProfileViewModel(profile: profile)
        super.init(nibName: nil, bundle: nil)
    }

    override convenience init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        self.init(profile: Profile())
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        dismissTapGesture.addTarget(self, action: #selector(EditProfileViewController.endEditing))
        view.addGestureRecognizer(dismissTapGesture)

        emailTextField.rx.text <-> viewModel.email >>> disposeBag

        emailTextField.rx.backgroundColor <- viewModel.emailBackgroundColor >>> disposeBag

        configureDateOfBirthField()
        configureGenderField()

        logButton.rx.tap.subscribe { _ in
            print(self.viewModel)
        } >>> disposeBag
    }

    private func configureDateOfBirthField() {
        datePicker.datePickerMode = .date
        dateOfBirthTextField.inputView = datePicker
        datePicker.rx.date <-> viewModel.dateOfBirth >>> disposeBag
        dateOfBirthTextField.rx.text <- viewModel.dateOfBirthString >>> disposeBag
    }

    private func configureGenderField() {
        // TODO: Create RxDatasource for this.
        // TODO: Extend the delegate proxy to include titleForRow:forComponent:
        genderPicker.dataSource = self
        genderPicker.delegate = self
        genderPicker.rx.itemSelected.map { (row, component) -> Gender in
            let gender = Gender(rawValue: row)
            return gender ?? .other
            }.bindTo(viewModel.gender) >>> disposeBag

        genderTextField.inputView = genderPicker
        genderTextField.rx.text <- viewModel.genderString >>> disposeBag
    }

    dynamic private func endEditing() {
        view.endEditing(true)
    }

    // MARK: UIPickerViewDataSource

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 3
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    // MARK: UIPickerViewDelegate

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let gender =  Gender(rawValue: row) ?? .other
        return gender.displayText
    }
}
