//
//  MulltipleMarkersViewController.swift
//  Adbusters
//
//  Created by MacBookAir on 12/9/18.
//  Copyright © 2018 MacBookAir. All rights reserved.
//

import UIKit

var multipleMarkersImageCache = NSCache<AnyObject, AnyObject>()

class MulltipleMarkersViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var imageUrlString: String?
    var tasks = [URLSessionDataTask]()
    
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        tableView.separatorColor = UIColor.white
    }
    
    @IBAction func goToMapTapped(_ sender: Any) {
        multipleMarkerDate = [AdModel]()
        multipleMarkersImageCache = NSCache<AnyObject, AnyObject>()
        for task in tasks {
            task.cancel()
        }
        dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return multipleMarkerDate.count
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MyAdsViewTableViewCell
        if multipleMarkerDate.count == 0 {
            return cell
        }
        cell.title.text = multipleMarkerDate[indexPath.row].party?.name
        cell.type.text = getTypeText(multipleMarkerDate[indexPath.row].type!)
        cell.politician.text = multipleMarkerDate[indexPath.row].person?.name
        cell.date.text = convertDate(dateStr: multipleMarkerDate[indexPath.row].created_date!)
        let images = multipleMarkerDate[indexPath.row].images!
        
        if (images.count > 0) {
            let urlString = images[0].image!
            let imageKey = urlString + "\(multipleMarkerDate[indexPath.row].id!)"
            imageUrlString = urlString + "\(multipleMarkerDate[indexPath.row].id!)"

            if let imageFromCache = multipleMarkersImageCache.object(forKey: imageKey as AnyObject) as? UIImage {
                cell.adImageView.image = imageFromCache
            } else {
                if let url = URL(string: urlString) {
                    let task = URLSession.shared.dataTask(with: url, completionHandler: { (data, _, error) -> Void in
                        guard let data = data, error == nil else {
                            print("\nerror on download \(error ?? "" as! Error)")
                            return
                        }

                        if let imageToCache = UIImage(data: data) {
                            DispatchQueue.main.async(execute: {
                                if self.imageUrlString == imageKey {
                                    cell.adImageView.image = imageToCache
                                }
                                multipleMarkersImageCache.setObject(imageToCache, forKey: self.imageUrlString as AnyObject)
                            })
                        } else {
                            cell.adImageView.image = UIImage(named: "logo_violet")
                        }
                    })

                    task.resume()
                    tasks.append(task)
                }
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCell:UITableViewCell = tableView.cellForRow(at: indexPath as IndexPath)!
        selectedCell.contentView.backgroundColor = UIColor(white: 1, alpha: 0.3)
        
        setCurrent(index: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160.0
    }
    
    func setCurrent(index: Int) {
        setSingleMarkerData(party: multipleMarkerDate[index].party!.name!, politician: multipleMarkerDate[index].person!.name!, date: convertDate(dateStr: multipleMarkerDate[index].created_date!), comment: multipleMarkerDate[index].comment!, type: multipleMarkerDate[index].type!, images: multipleMarkerDate[index].images ?? [AdImage]())
        performSegue(withIdentifier: "goToSingleMarkerView", sender: nil)
    }
}

extension UIImageView {
    func downloadImageFrom(link:String, contentMode: UIView.ContentMode) {
        URLSession.shared.dataTask(with: URL(string:link)!, completionHandler: {
            (data, response, error) -> Void in
            DispatchQueue.main.async {
                self.contentMode =  contentMode
                if let data = data { self.image = UIImage(data: data) }
            }
        }).resume()
    }
}
