import Foundation
import UIKit

protocol ColorItemListViewModelProtocol: class {
    var items: [ColorItem] { get }
    var itemsDidChange: ((ColorItemListViewModelProtocol) -> Void)? { get set }
    init(client: ColorItemClient)
    func loadItems()
}

final class ViewController: UITableViewController {
    var viewModel: ColorItemListViewModelProtocol! {
        didSet {
            viewModel.itemsDidChange = { viewModel in
                self.items = viewModel.items
            }
        }
    }
    var items: [ColorItem] = [] {
        didSet {
            tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "MVVM"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Load", style: .plain, target: self, action: #selector(ViewController.didTapLoadButton))
    }

    func didTapLoadButton() {
        viewModel.loadItems()
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

final class ColorItemListViewModel: ColorItemListViewModelProtocol {
    let client: ColorItemClient
    var items: [ColorItem] = [] {
        didSet {
            itemsDidChange?(self)
        }
    }
    var itemsDidChange: ((ColorItemListViewModelProtocol) -> Void)?

    required init(client: ColorItemClient) {
        self.client = client
    }

    func loadItems() {
        client.requestItems { items in
            self.items = items
        }
    }
}

let client = ColorItemClient()
let view = ViewController()
let viewModel = ColorItemListViewModel(client: client)
view.viewModel = viewModel

// live rendering

import PlaygroundSupport

let navigationController = UINavigationController(rootViewController: view)
navigationController.view.frame = CGRect(x: 0, y: 0, width: 375, height: 667)

PlaygroundPage.current.needsIndefiniteExecution = true
PlaygroundPage.current.liveView = navigationController.view
