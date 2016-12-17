import Foundation
import UIKit

protocol ColorItemListView: class {
    var items: [ColorItem] { get set }
}

protocol ColorItemListViewPresenter: class {
    init(view: ColorItemListView, client: ColorItemClient)
    func loadItems()
}

final class ViewController: UITableViewController, ColorItemListView {
    var presenter: ColorItemListViewPresenter!
    var items: [ColorItem] = [] {
        didSet {
            tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "MVP"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Load", style: .plain, target: self, action: #selector(ViewController.didTapLoadButton))
    }

    func didTapLoadButton() {
        presenter.loadItems()
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

final class ColorItemListPresenter: ColorItemListViewPresenter {
    weak var view: ColorItemListView!
    let client: ColorItemClient

    required init(view: ColorItemListView, client: ColorItemClient) {
        self.view = view
        self.client = client
    }

    func loadItems() {
        client.requestItems { items in
            self.view.items = items
        }
    }
}

let client = ColorItemClient()
let view = ViewController()
let presenter = ColorItemListPresenter(view: view, client: client)
view.presenter = presenter

// live rendering

import PlaygroundSupport

let navigationController = UINavigationController(rootViewController: view)
navigationController.view.frame = CGRect(x: 0, y: 0, width: 375, height: 667)

PlaygroundPage.current.needsIndefiniteExecution = true
PlaygroundPage.current.liveView = navigationController.view
