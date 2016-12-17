import Foundation
import UIKit
import Chameleon

struct ColorItem {
    let name: String
    let color: UIColor
}

final class ColorItemClient {
    func requestItems(completion: (([ColorItem]) -> Void)?) {
        completion?([
            ColorItem(name: "red", color: UIColor.flatRed()),
            ColorItem(name: "orange", color: UIColor.flatOrange()),
            ColorItem(name: "yellow", color: UIColor.flatYellow()),
            ColorItem(name: "green", color: UIColor.flatGreen()),
            ColorItem(name: "blue", color: UIColor.flatSkyBlue()),
        ])
    }
}

protocol ColorItemListView: UITableViewDataSource {
    var items: [ColorItem] { get set }
}

protocol ColorItemListViewPresenter {
    init(view: ColorItemListView, client: ColorItemClient)
    func loadItems()
}

final class ColorItemCell: UITableViewCell {
    let colorView = UIView()
    let nameLabel = UILabel()

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        addSubview(colorView)
        addSubview(nameLabel)

        colorView.layer.cornerRadius = 3.0
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func update(with colorItem: ColorItem) {
        colorView.backgroundColor = colorItem.color
        nameLabel.text = colorItem.name
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        colorView.frame = CGRect(x: 8, y: (frame.height - 32) / 2, width: 32, height: 32)
        nameLabel.frame = CGRect(x: colorView.frame.maxX + 8, y: (frame.height - 21) / 2, width: 200, height: 21)
    }
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

// live rendering

import PlaygroundSupport

let client = ColorItemClient()
let view = ViewController()
let presenter = ColorItemListPresenter(view: view, client: client)
view.presenter = presenter

let navigationController = UINavigationController(rootViewController: view)
navigationController.view.frame = CGRect(x: 0, y: 0, width: 375, height: 667)

PlaygroundPage.current.needsIndefiniteExecution = true
PlaygroundPage.current.liveView = navigationController.view
