//
//  ErrorPresentable.swift
//  movie-app
//
//  Created by Sandor Vlajk on 2025. 05. 06..
//

import Foundation

protocol ErrorPresentable {
    func toAlertModel(_ error: Error) -> AlertModel?
}

extension ErrorPresentable {
    func toAlertModel(_ error: Error) -> AlertModel? {
        guard let error = error as? MovieError else {
            return AlertModel(
                title: NSLocalizedString("unexpectederror.title".localized(), comment: ""),
                message: NSLocalizedString("unexpectederror.message".localized(), comment: ""),
                dismissButtonTitle: NSLocalizedString("dismissbutton.title".localized(), comment: "")
            )
        }
        switch error {
        case .invalidApiKeyError(let message):
            return AlertModel(
                title: NSLocalizedString("apierror.message".localized(), comment: ""),
                message: message,
                dismissButtonTitle: NSLocalizedString("dismissbutton.title".localized(), comment: "")
            )
        case .clientError:
            return AlertModel(
                title: NSLocalizedString("clienterror.title".localized(), comment: ""),
                message: error.localizedDescription,
                dismissButtonTitle: NSLocalizedString("dismissbutton.title".localized(), comment: "")
            )
        case .mappingError:
            return AlertModel(
                title: NSLocalizedString("mappingerror.title".localized(), comment: ""),
                message: NSLocalizedString("mappingerror.message".localized(), comment: ""),
                dismissButtonTitle: NSLocalizedString("dismissbutton.title".localized(), comment: "")
            )
        case .noInternetError:
            return nil
        case .serverError:
            return AlertModel(
                title: NSLocalizedString("servererror.title".localized(), comment: ""),
                message: error.localizedDescription,
                dismissButtonTitle: NSLocalizedString("dismissbutton.title".localized(), comment: "")
            )
        default:
            return AlertModel(
                title: NSLocalizedString("unexpectederror.title".localized(), comment: ""),
                message: NSLocalizedString("unexpectederror.message".localized(), comment: ""),
                dismissButtonTitle: NSLocalizedString("dismissbutton.title".localized(), comment: "")
            )
        }
    }
}
