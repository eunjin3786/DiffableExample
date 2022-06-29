import UIKit

struct Post: Hashable {
    let title: String
    
    let uuid = UUID()
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(uuid)
    }
}

class ViewController2: UIViewController {

    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Row>
    typealias DataSource = UITableViewDiffableDataSource<Section, Row>

    @IBOutlet weak var tableView: UITableView!

    enum Section: CaseIterable {
        case top
        case post
        case bottom
    }
    
    enum Row: Hashable {
        case topMessage(String)
        case postContent(Post)
        case bottomMessage(String)
    }
    
    var dataSource: DataSource!
    
    var posts: [Post] = [
        Post(title: "포스팅 1"),
        Post(title: "포스팅 2"),
        Post(title: "포스팅 3")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        applyInitialSnapshot()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.replaceTopMessage()
        }
    }
    
    private func setupTableView() {
        let cellProvider = { (tableView: UITableView, indexPath: IndexPath, row: Row) -> UITableViewCell? in
            switch row {
            case .topMessage(let message):
                let cell = UITableViewCell() // 예제여서 dequeueReusableCell 안해줌.
                cell.textLabel?.text = message
                return cell
            case .postContent(let post):
                let cell = UITableViewCell() // 예제여서 dequeueReusableCell 안해줌.
                cell.textLabel?.text = post.title
                return cell
            case .bottomMessage(let message):
                let cell = UITableViewCell() // 예제여서 dequeueReusableCell 안해줌.
                cell.textLabel?.text = message
                return cell
            }
        }
        
        let dataSource = DataSource(tableView: tableView, cellProvider: cellProvider)
        tableView.dataSource = dataSource
        self.dataSource = dataSource
    }
    
    func applyInitialSnapshot() {
        var snapshot = Snapshot()
        snapshot.appendSections(Section.allCases)
        snapshot.appendItems([.topMessage("탑 메세지")], toSection: .top)
        snapshot.appendItems(self.posts.map { Row.postContent($0) }, toSection: .post)
        snapshot.appendItems([.bottomMessage("바텀 메세지")], toSection: .bottom)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    func replaceTopMessage() {
        var snapshot = dataSource.snapshot()
        snapshot.deleteItems([.topMessage("탑 메세지")])
        snapshot.appendItems([.topMessage("새로운 탑 메세지")], toSection: .top)
        dataSource.defaultRowAnimation = .none
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}
