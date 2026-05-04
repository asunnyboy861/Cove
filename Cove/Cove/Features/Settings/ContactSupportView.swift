import SwiftUI

struct ContactSupportView: View {
    @State private var emailSubject = ""
    @State private var emailBody = ""
    @State private var includeDiagnostics = true
    @State private var showSentConfirmation = false

    var body: some View {
        Form {
            Section("How can we help?") {
                TextField("Subject", text: $emailSubject)
                TextField("Describe your issue...", text: $emailBody, axis: .vertical)
                    .lineLimit(5...12)
            }

            Section("Options") {
                Toggle("Include diagnostic info", isOn: $includeDiagnostics)
            }

            Section {
                Button {
                    sendSupportEmail()
                } label: {
                    HStack {
                        Spacer()
                        Text("Send Message")
                            .fontWeight(.semibold)
                        Spacer()
                    }
                }
                .disabled(emailSubject.isEmpty || emailBody.isEmpty)
            }

            Section("Other Ways to Reach Us") {
                Link(destination: URL(string: "https://asunnyboy861.github.io/Cove/support.html")!) {
                    Label("Support Page", systemImage: "globe")
                }
                Link(destination: URL(string: "https://github.com/asunnyboy861/Cove/issues")!) {
                    Label("GitHub Issues", systemImage: "chevron.left.forwardslash.chevron.right")
                }
            }
        }
        .navigationTitle("Contact Support")
        .tint(.coveTeal)
        .alert("Message Sent!", isPresented: $showSentConfirmation) {
            Button("OK") {}
        } message: {
            Text("We'll get back to you within 24 hours.")
        }
    }

    private func sendSupportEmail() {
        let subject = emailSubject.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let body = emailBody.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let diagnostics = includeDiagnostics ? "\n\n---\nApp: Cove v1.0.0\nOS: iOS \(UIDevice.current.systemVersion)\nDevice: \(UIDevice.current.model)" : ""
        let fullBody = (body + diagnostics).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""

        if let url = URL(string: "mailto:support@coveapp.dev?subject=\(subject)&body=\(fullBody)") {
            UIApplication.shared.open(url)
        }
        showSentConfirmation = true
    }
}
