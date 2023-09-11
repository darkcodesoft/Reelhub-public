//
//  MailView.swift
//  Reelhub
//
//  Created by Teddy Moussignac on 4/3/23.
//

import SwiftUI
import MessageUI
import DeviceKit

struct MailView: UIViewControllerRepresentable {
    @EnvironmentObject var userStore: UserStore
    @Binding var isShowing: Bool
    @Binding var result: Result<MFMailComposeResult, Error>?
    
    var recipient = String.helpEmail
    var subject = String.contactUs
    
    // Message boddy
    var messageBody = """
    <br/>
    <br/>
    <br/>
    ------------------------------
    <br/>
    model: \(Device.current.model ?? "")
    <br/>
    version: \(Device.current.systemVersion ?? "")
    <br/>
    -------------------------------
    <br/>
    Reelhub App version: \(Bundle.main.infoDictionary?["CFBundleShortVersionString"] ?? "")
    <br/>
    -------------------------------
    <br/>
    """
    
    class Coordinator: NSObject, MFMailComposeViewControllerDelegate {

        @Binding var isShowing: Bool
        @Binding var result: Result<MFMailComposeResult, Error>?

        init(isShowing: Binding<Bool>,
             result: Binding<Result<MFMailComposeResult, Error>?>) {
            _isShowing = isShowing
            _result = result
        }

        func mailComposeController(_ controller: MFMailComposeViewController,
                                   didFinishWith result: MFMailComposeResult,
                                   error: Error?) {
            defer {
                isShowing = false
            }
            guard error == nil else {
                self.result = .failure(error!)
                return
            }
            self.result = .success(result)
        }
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(isShowing: $isShowing,
                           result: $result)
    }

    func makeUIViewController(context: UIViewControllerRepresentableContext<MailView>) -> MFMailComposeViewController {
        let vc = MFMailComposeViewController()
        vc.setToRecipients([recipient])
        vc.setCcRecipients([userStore.user?.email ?? ""])
        vc.setSubject(subject)
        vc.setMessageBody(messageBody, isHTML: true)
        vc.mailComposeDelegate = context.coordinator
        return vc
    }

    func updateUIViewController(_ uiViewController: MFMailComposeViewController,
                                context: UIViewControllerRepresentableContext<MailView>) {

    }
}
