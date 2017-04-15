import UIKit
import KeyboardManager

class ViewController: UIViewController {

    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet fileprivate weak var textField: UITextField!
    private let keyboardManager = KeyboardManager(notificationCenter: NotificationCenter.default)

    override func viewDidLoad() {
        super.viewDidLoad()
        textField.delegate = self
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")

        keyboardManager.bindToKeyboardNotifications(scrollView: tableView)
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return 20
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = "Cell \(indexPath.row)"
        return cell
    }

    func tableView(_: UITableView, didSelectRowAt _: IndexPath) {
        textField.resignFirstResponder()
    }
}

extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
}
