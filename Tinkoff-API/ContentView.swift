import UIKit


struct News: Decodable {
  let title: String
  let description: String
  let url: String
}

class NewsViewController: UITableViewController {

    var news = [News]()
    
    var selectedNews: News?

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchNews()
    }

    func fetchNews() {
        // Выполняем API-запрос для получения списка новостей
        let url = URL(string: "https://your-api.com/news")!
        let task = URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            guard let data = data else { return }

            // Распарсиваем полученные данные
            let decoder = JSONDecoder()
            do {
                let newsResponse = try decoder.decode([News].self, from: data)
                self?.updateUI(with: newsResponse)
            } catch {
                print("Error decoding JSON: \(error)")
            }
        }
        task.resume()
    }

    func updateUI(with news: [News]) {
        DispatchQueue.main.async { [weak self] in
            self?.news = news
            self?.tableView.reloadData()
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return news.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsCell", for: indexPath)
        let newsItem = news[indexPath.row]
        cell.textLabel?.text = newsItem.title
        cell.detailTextLabel?.text = newsItem.description
        return cell
    }


    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowNewsDetail" {
            let destinationVC = segue.destination as! NewsViewController
            let selectedIndex = tableView.indexPathForSelectedRow!
            destinationVC.selectedNews = news[selectedIndex.row]
        }
    }

}



