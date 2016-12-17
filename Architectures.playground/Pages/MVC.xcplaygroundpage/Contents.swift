import Foundation
import UIKit

final class ViewController: UITableViewController {
    let client = ColorItemClient()
    var items: [ColorItem] = [] {
        didSet {
            tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "MVC"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Load", style: .plain, target: self, action: #selector(ViewController.didTapLoadButton))
    }

    func didTapLoadButton() {
        loadItems()
    }

    func loadItems() {
        client.requestItems { items in
            self.items = items
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = ColorItemCell(style: .subtitle, reuseIdentifier: nil)
        let colorItem = items[indexPath.row]

        cell.update(with: colorItem)

        return cell
    }
}

let viewController = ViewController()

// live rendering

import PlaygroundSupport

let navigationController = UINavigationController(rootViewController: viewController)
navigationController.view.frame = CGRect(x: 0, y: 0, width: 375, height: 667)

PlaygroundPage.current.needsIndefiniteExecution = true
PlaygroundPage.current.liveView = navigationController.view
