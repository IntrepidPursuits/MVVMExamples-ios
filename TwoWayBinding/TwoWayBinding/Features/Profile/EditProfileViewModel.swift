//
//  EditProfileViewModel.swift
//  TwoWayBinding
//
//  Created by Benjamin Wu on 3/6/17.
//  Copyright © 2017 Intrepid Pursuits. All rights reserved.
//

import Foundation
import RxSwift

class EditProfileViewModel {
    let email: Variable<String?>
    let dateOfBirth: Variable<Date>
    let gender: Variable<Gender>

    let emailBackgroundColor: Observable<UIColor?>
    let dateOfBirthString: Observable<String?>
    let genderString: Observable<String?>

    init(profile: Profile) {
        email = Variable(profile.email)
        dateOfBirth = Variable(profile.dateOfBirth)
        gender = Variable(profile.gender)

        let validEmail: Observable<Bool> = email.asObservable().map { email in
            guard let email = email else { return false }
            return email.contains("@")
        }

        emailBackgroundColor = validEmail.map { $0 ? UIColor.clear : UIColor.red }

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
        let email = self.email.value ?? ""
        return "EditProfileViewModel:\n  email: \(email)\n  D.O.B: \(dateOfBirth.value)\n  Gender: \(gender.value.displayText)"
    }
}
