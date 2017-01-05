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

class EditProfileViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    @IBOutlet private weak var usernameTextField: UITextField!
    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var firstNameTextField: UITextField!
    @IBOutlet private weak var lastNameTextField: UITextField!
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

        usernameTextField.rx.text <-> viewModel.username >>> disposeBag
        emailTextField.rx.text <-> viewModel.email >>> disposeBag
        firstNameTextField.rx.text <-> viewModel.firstName >>> disposeBag
        lastNameTextField.rx.text <-> viewModel.lastName >>> disposeBag

        usernameTextField.rx.backgroundColor <- viewModel.usernameBackgroundColor >>> disposeBag
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

import RxCocoa
extension Reactive where Base: UIView {
    var backgroundColor: UIBindingObserver<Base, UIColor?> {
        return UIBindingObserver(UIElement: self.base) { view, color in
            view.backgroundColor = color
        }
    }
}

class EditProfileViewModel {

    let username: Variable<String?>
    let email: Variable<String?>
    let firstName: Variable<String?>
    let lastName: Variable<String?>
    let dateOfBirth: Variable<Date>
    let gender: Variable<Gender>

    let usernameBackgroundColor: Observable<UIColor?>
    let emailBackgroundColor: Observable<UIColor?>
    let dateOfBirthString: Observable<String?>
    let genderString: Observable<String?>

    init(profile: Profile) {
        username = Variable(profile.username)
        email = Variable(profile.email)
        firstName = Variable(profile.firstName)
        lastName = Variable(profile.lastName)
        dateOfBirth = Variable(profile.dateOfBirth)
        gender = Variable(profile.gender)

        let validUsername: Observable<Bool> = username.asObservable().map { username in
            guard let username = username else { return false }
            return username.characters.count > 2
        }
        let validEmail: Observable<Bool> = email.asObservable().map { email in
            guard let email = email else { return false }
            return email.contains("@")
        }

        let errorColorMap: ((Bool) -> UIColor) = { $0 ? UIColor.clear : UIColor.red }
        usernameBackgroundColor = validUsername.map(errorColorMap)
        emailBackgroundColor = validEmail.map(errorColorMap)

        dateOfBirthString = dateOfBirth.asObservable().map { (date) -> String in
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .long
            return dateFormatter.string(from: date)
        }

        genderString = gender.asObservable().map { return $0.displayText }
    }
}

extension EditProfileViewModel: CustomDebugStringConvertible {
    var debugDescription: String {
        let username = self.username.value ?? ""
        let email = self.email.value ?? ""
        let firstName = self.firstName.value ?? ""
        let lastName = self.lastName.value ?? ""
        return "EditProfileViewModel:\n  username: \(username)\n  email: \(email)\n  firstName:\(firstName)\n  lastName: \(lastName)\n  D.O.B: \(dateOfBirth.value)\n  Gender: \(gender.value.displayText)"
    }
}

class Profile {
    var username: String
    var email: String
    var firstName: String?
    var lastName: String?
    var dateOfBirth: Date
    var gender: Gender

    init() {
        username = "dsum"
        email = "foo@bar.com"
        firstName = "Donna"
        lastName = "Summer"
        dateOfBirth = Date()
        gender = .female
    }
}

enum Gender: Int {
    case female = 0
    case male
    case other

    var displayText: String {
        switch self {
        case .female:
            return "Female"
        case .male:
            return "Male"
        case .other:
            return "Other"
        }
    }
}
