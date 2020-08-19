import UIKit
import MapKit
import CoreLocation    //引入核心定位框架
import SafariServices   //引入safari服務框架

//以定位管理員進行定位，請遵循以下的步驟
//引入地圖協定 1.引入定位管理員相關協定
class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate  //引入地圖協定
{

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var lblDirection: UILabel!       //方向
    @IBOutlet weak var lblAltitude: UILabel!        //高度
    @IBOutlet weak var lblLatitude: UILabel!        //緯度
    @IBOutlet weak var lblLongitude: UILabel!       //經度
    
    
    
    //2.初始化定位管理員以取得使用者位置
    let locationManager = CLLocationManager()
    //3.紀錄定位完成後的目前位置
    var currentLocation:CLLocation!
    //宣告大頭針的空陣列
    var annotations = [MKPointAnnotation]()
    //紀錄點選大頭針的經緯度位置
    var selectedPinLocation:CLLocationCoordinate2D!
    
    //MARK: - Targer Action
    @IBAction func segmentedControlPressed(_ sender: UISegmentedControl)
    {
        switch sender.selectedSegmentIndex {
        case 1:  //衛星
            mapView.mapType = .satellite
        case 2:  //混合
            mapView.mapType = .hybrid
        case 3:  //3D
            //取得目前的經緯度座標
            let ground = currentLocation.coordinate
            //定義觀察3D地標之攝影機的座標位置（需從目前位置偏移一小段距離所以加上0.005）
            let eyeFrom = CLLocationCoordinate2D(latitude: ground.latitude + 0.005, longitude: ground.longitude + 0.005)
            //初始化觀察用的攝影機（第一個參數為攝影機的觀看座標，第二個參數為攝影機所在座標，第三個參數為攝影機的公尺高度）
            let camera = MKMapCamera(lookingAtCenter: ground, fromEyeCoordinate: eyeFrom, eyeAltitude: currentLocation.altitude * 0.8)
            //指定地圖以3D方式呈現
            mapView.mapType = .satelliteFlyover
            //允許可以從斜角觀看地圖（false只能從正上方觀看）
            mapView.isPitchEnabled = true
            //在地圖上加上觀察用攝影機
            mapView.camera = camera
        default:
            mapView.mapType = .standard
        }
        
    }
    
    
    
    
    //MARK: - 自訂函式
    func makeSomeMapPin()
    {
        //宣告大頭針的空陣列
        var annotations = [MKPointAnnotation]()
        //初始化地圖上使用的大頭針
        let annotation1 = MKPointAnnotation()
        //設定大頭針的經緯度
        annotation1.coordinate = CLLocationCoordinate2D(latitude: 24.137426, longitude: 121.275753)
        //設定大頭針的顯示資訊
        annotation1.title = "卡比獸"
        annotation1.subtitle = "南投縣仁愛鄉-武嶺"
        //將大頭針加入陣列
        annotations.append(annotation1)
        
        //初始化地圖上使用的大頭針
        let annotation2 = MKPointAnnotation()
        //設定大頭針的經緯度
        annotation2.coordinate = CLLocationCoordinate2D(latitude: 23.510041, longitude: 120.700458)
        //設定大頭針的顯示資訊
        annotation2.title = "噴火龍"
        annotation2.subtitle = "嘉義縣竹崎鄉-奮起湖"
        //將大頭針加入陣列
        annotations.append(annotation2)
        
        //初始化地圖上使用的大頭針
        let annotation3 = MKPointAnnotation()
        //設定大頭針的經緯度
        annotation3.coordinate = CLLocationCoordinate2D(latitude: 24.120305, longitude: 120.650916)
        //設定大頭針的顯示資訊
        annotation3.title = "吉利蛋"
        annotation3.subtitle = "台中市文心南路-星巴克"
        //將大頭針加入陣列
        annotations.append(annotation3)
        
        //初始化地圖上使用的大頭針
        let annotation4 = MKPointAnnotation()
        //設定大頭針的經緯度
        annotation4.coordinate = CLLocationCoordinate2D(latitude: 24.402551, longitude: 121.161865)
        //設定大頭針的顯示資訊
        annotation4.title = "乘龍"
        annotation4.subtitle = "苗栗縣大湖鄉-雪霸"
        //將大頭針加入陣列
        annotations.append(annotation4)
        
        //初始化地圖上使用的大頭針
        let annotation5 = MKPointAnnotation()
        //設定大頭針的經緯度
        annotation5.coordinate = CLLocationCoordinate2D(latitude: 24.83076, longitude: 121.01079)
        //設定大頭針的顯示資訊
        annotation5.title = "水箭龜"
        annotation5.subtitle = "新竹縣竹北市-竹筍公園"
        //將大頭針加入陣列
        annotations.append(annotation5)
        
        //將大頭針陣列釘到地圖上
        mapView.addAnnotations(annotations)
        
//        //將地圖的中心點設定在第一個大頭針的位置
//        mapView.setCenter(annotations[0].coordinate, animated: false)
    }
    
    //由callout面板所呼叫的函示
    @objc func buttonPress(_ sender:UIButton)
    {
//        if sender.tag == 100
//        {
//            //初始化特定網址物件
//            let url = URL(string: "http://www.taroko.gov.tw")
//            //將網址物件製成safari瀏覽器
//            let safari = SFSafariViewController(url: url!)
//            //以safari瀏覽器開啟特定網址
//            self.show(safari, sender: nil)
//        }
        
        //以點選的大頭針經緯度座標製成導航地圖的目的地地標
        let markDestination = MKPlacemark(coordinate: selectedPinLocation)
        let destMapItem = MKMapItem(placemark: markDestination)
        destMapItem.name = "導航終點"
        //設定選項
        let optionNavi = [MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeDriving]
        destMapItem.openInMaps(launchOptions: optionNavi)
        
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        //3.由定位管理員向使用者要求定位授權
        //向使用者要求定位授權，需配合以下的key＆對應方法
        //方法一
        //Privacy - Location When In Use Usage Description
        //locationManager.requestWhenInUseAuthorization()
        
        //方法二
        //Privacy - Location Always Usage Description
        locationManager.requestAlwaysAuthorization()
        //--------------------------------------------------
        //4.指定定位管理員相關代理事件實作在此類別
        locationManager.delegate = self
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.pausesLocationUpdatesAutomatically = false
        
        
        //--------針對地圖操作相關功能，實作大頭針-----------
        //5.顯示使用者位置，也可以在storyboard上勾選
        mapView.showsUserLocation = true
        //6.指定地圖協定實作在此類別
        mapView.delegate = self
        //在地圖上標上大頭針
        //makeSomeMapPin()  -> 移到定位完成的代理事件裡面8-3
        
//        //初始化大頭針
//        var annotation = MKPointAnnotation()
//        //設定大頭針經緯度
//        annotation.coordinate = CLLocationCoordinate2D(latitude: 24.137426, longitude: 121.275753)
//        //設定大頭針主要資訊
//        annotation.title = "武嶺"
//        //設定大頭針附屬資訊
//        annotation.subtitle = "南投縣仁愛鄉"
//        //將大頭針加入陣列
//        annotations.append(annotation)
//
//        //重新初始化一個大頭針，此步驟不可省略，新增一記憶體配置空間才可以顯示第二根大頭針，不然會是改同一個大頭針的資訊
//        annotation = MKPointAnnotation()
//        //設定大頭針經緯度
//        annotation.coordinate = CLLocationCoordinate2D(latitude: 23.510041, longitude: 120.700458)
//        //設定大頭針主要資訊
//        annotation.title = "奮起湖"
//        //設定大頭針附屬資訊
//        annotation.subtitle = "嘉義縣竹崎鄉"
//        //將大頭針加入陣列
//        annotations.append(annotation)
//
//        //重新初始化一個大頭針，此步驟不可省略，新增一記憶體配置空間才可以顯示第二根大頭針，不然會是改同一個大頭針的資訊
//        annotation = MKPointAnnotation()
//        //設定大頭針經緯度
//        annotation.coordinate = CLLocationCoordinate2D(latitude: 24.402551, longitude: 121.161865)
//        //設定大頭針主要資訊
//        annotation.title = "雪霸國家公園"
//        //設定大頭針附屬資訊
//        annotation.subtitle = "苗栗縣大湖鄉"
//        //將大頭針加入陣列
//        annotations.append(annotation)
//
//        //MKPointAnnotation為MKAnnotation精確類別可以使用，將大頭針插在地圖上
//        mapView.addAnnotations(annotations)
//
//        //移動地圖到第一根大頭針的位置
//        mapView.setCenter(annotations[0].coordinate, animated: false)
        
        //===================在地圖上標示多邊形======================
        //宣告多邊形每個頂點位置的陣列
        var points = [CLLocationCoordinate2D]()
        points.append(CLLocationCoordinate2D(latitude: 24.2013, longitude: 120.5810))
        points.append(CLLocationCoordinate2D(latitude: 24.2044, longitude: 120.6559))
        points.append(CLLocationCoordinate2D(latitude: 24.1380, longitude: 120.6401))
        points.append(CLLocationCoordinate2D(latitude: 24.1424, longitude: 120.5783))
        //製作一個可用於地圖上的多邊形
        let polygon = MKPolygon(coordinates: points, count: points.count)
        //在地圖上加入多邊形圖層，注意：此時為透明，需透過代理事件提供渲染樣式
        mapView.addOverlay(polygon)
        //========================================================
        
        //===================在地圖上標示圓形======================
        //製作一個可用於地圖上的圓形
        let circle = MKCircle(center: CLLocationCoordinate2D(latitude: 24.1100, longitude: 120.5750), radius: 3000)
        //在地圖上加入圓形圖層，注意：此時為透明，需透過代理事件提供渲染樣式
        mapView.addOverlay(circle)
        //========================================================
        
        //7.請定位管理員開始定位
        locationManager.startUpdatingLocation()
        
        //9.請定位管理員開始偵測設備的前方方向（此時會呼叫10 didupdateheading）
        locationManager.startUpdatingHeading()
        
    }

//MARK: - MKMapViewDelegate函數群
    //以系統提供的大頭針樣式來更換預設大頭針的樣式
    /*
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?
    {
//        guard !(annotation is MKUserLocation)  //裡面的變數選擇性綁定外面還要用才會用guard
//        else
//        {
//            //當條件為false進此else段
//            //檢查若為使用者位置的大頭針就離開
//            return nil
//        }
        
        if annotation is MKUserLocation
        {
            return nil
        }
        
        //以pin為ID來取得大頭針的一般樣式MKAnnotationView (轉型為MKPinAnnotationView)
        var annView = mapView.dequeueReusableAnnotationView(withIdentifier: "pin") as? MKPinAnnotationView
         //如果無法以pin為ID取得大頭針的一般樣式
        if annView == nil
        {
           //則以pin為id建立一個大頭針樣式
            annView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "pin")
        }
        
        //修改樣式
        if annotation.title == "武嶺"
        {
            //改大頭針顏色
            annView?.pinTintColor = .green
            
        }
        else if annotation.title == "奮起湖"
        {
            annView?.pinTintColor = .orange
        }
            
        
        //允許點擊大頭針後顯示title & subtitle
        annView?.canShowCallout = true
        //回傳修改後的
        return annView
        
    }
    */
    //<方法二>以自訂圖片來更換預設大頭針的樣式
//    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?
//    {
//        if annotation is MKUserLocation
//        {
//            return nil
//        }
//        //以pin為ID來取得大頭針的一般樣式MKAnnotationView (注意：不需轉型為MKPinAnnotationView)
//        var annView = mapView.dequeueReusableAnnotationView(withIdentifier: "pin") //as? MKPinAnnotationView
//
//        //如果無法以pin為ID來取得大頭針的一半樣式（不是MKPinAnnotationView）
//        if annView == nil
//        {
//            //則以pin為d重新做一個大頭針的一般樣式（不是MKPinAnnotationView）
//            annView = MKAnnotationView(annotation: annotation, reuseIdentifier: "pin")
//        }
//
//        //客製化大頭針圖示
//        annView?.image = UIImage(named: "coffee_to_go.png")
//
//        //設定callout面板
//        if annotation.title == "武嶺"
//        {
//            //增加callout面板左側的圖片附件
//            let imageView = UIImageView(image: UIImage(named: "wuling.jpg"))
//            imageView.contentMode = .scaleAspectFill
//            imageView.clipsToBounds = true
//            imageView.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
//            annView?.leftCalloutAccessoryView = imageView
//            //替換callout面板subtitle資訊為經緯度
//            let label = UILabel()
//            label.numberOfLines = 2     //將label設定為可以顯示兩行資訊
//            label.text = String(format: "緯度：%.02f\n經度：%.02f", annotation.coordinate.latitude,annotation.coordinate.longitude)
//            label.textColor = .darkGray
//            annView?.detailCalloutAccessoryView = label
//            //增加callout面板又側的按鈕附件
//            let button = UIButton(type: .detailDisclosure)
//            button.tag = 100
//            button.addTarget(self, action: #selector(buttonPress(_:)), for: .touchUpInside)
//            annView?.rightCalloutAccessoryView = button
//        }
//
//        //允許點擊大頭針後顯示title & subtitle
//        annView?.canShowCallout = true
//        return annView
//    }
    
    //<方法三>以自訂圖片來更換預設大頭針
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?
    {
        //如果是使用者位置不做更換大頭針
        if annotation is MKUserLocation
        {
            return nil
        }
        
        //以pin為ID來取得大頭針的一般樣式MKAnnotationView(注意不要轉型為MKPinAnnotationView)
        var annView = mapView.dequeueReusableAnnotationView(withIdentifier: "pin")
        if annView == nil
        {
            annView = MKAnnotationView(annotation: annotation, reuseIdentifier: "pin")
        }
        
        //1.設定大頭針樣式與主標題描述的神奇寶貝相同
        annView?.image = UIImage(named: "\(annotation.title!!).png")
        //2.增加call out面板左側圖片附件
        let imageView = UIImageView(image: annView?.image)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        annView?.leftCalloutAccessoryView = imageView
        //3.替換callout面板的subtitle資訊為經緯度資訊和距離
        //將目前的大頭針製成CLLocation類別實體（計算與目前的距離使用）
        let pinLocation = CLLocation(latitude: annotation.coordinate.latitude, longitude: annotation.coordinate.longitude)
        
        //格式化緯度、經度與目前位置的距離
        let strLatitude = String(format: "%.5f", annotation.coordinate.latitude)
        let strLongitutr = String(format: "%.5f", annotation.coordinate.longitude)
        let strDistance = String(format: "%.2f 公里", pinLocation.distance(from: currentLocation)/1000)
        
        //將顯示文字設定給callout面板的subtitle資訊
        let label = UILabel()
        label.numberOfLines = 3     //將label設定為可以顯示兩行資訊
        label.text = String(format: "緯度：\(strLatitude)\n經度：\(strLongitutr)\n距離：\(strDistance)")
        annView?.detailCalloutAccessoryView = label

        
        //4.增加callout面板右側的按鈕附件
        let button = UIButton(type: .roundedRect)
        button.bounds = CGRect(x: 0, y: 0, width: 50, height: 20)
        button.setTitle("導航", for: .normal)
        button.addTarget(self, action: #selector(buttonPress(_:)), for: .touchUpInside)
        annView?.rightCalloutAccessoryView = button
        
//        if annotation.title! == "卡比獸"
//        {
//            //設定大頭針樣式與主標題描述的神奇寶貝相同
//            annView?.image = UIImage(named: "卡比獸.png")
//            //設定call out面板左側圖片附件
//            let imageView = UIImageView(image: annView?.image)
//            imageView.contentMode = .scaleAspectFill
//            imageView.clipsToBounds = true
//            imageView.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
//            annView?.leftCalloutAccessoryView = imageView
//        }
//        else if annotation.title == "噴火龍"
//        {
//            annView?.image = UIImage(named: "噴火龍.png")
//            let imageView = UIImageView(image: annView?.image)
//            imageView.contentMode = .scaleAspectFill
//            imageView.clipsToBounds = true
//            imageView.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
//            annView?.leftCalloutAccessoryView = imageView
//        }
//        else if annotation.title == "乘龍"
//        {
//            annView?.image = UIImage(named: "乘龍.png")
//            let imageView = UIImageView(image: annView?.image)
//            imageView.contentMode = .scaleAspectFill
//            imageView.clipsToBounds = true
//            imageView.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
//            annView?.leftCalloutAccessoryView = imageView
//        }
//        else if annotation.title == "吉利蛋"
//        {
//            annView?.image = UIImage(named: "吉利蛋.png")
//            let imageView = UIImageView(image: annView?.image)
//            imageView.contentMode = .scaleAspectFill
//            imageView.clipsToBounds = true
//            imageView.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
//            annView?.leftCalloutAccessoryView = imageView
//        }
//        else if annotation.title == "水箭龜"
//        {
//            annView?.image = UIImage(named: "水箭龜.png")
//            let imageView = UIImageView(image: annView?.image)
//            imageView.contentMode = .scaleAspectFill
//            imageView.clipsToBounds = true
//            imageView.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
//            annView?.leftCalloutAccessoryView = imageView
//        }
//        else
//        {
//            annView?.image = UIImage(named: "coffee_to_go.png")
//        }
        
        annView?.canShowCallout = true
        return annView
    }
    
    //回傳地圖圖層的渲染樣式
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer
    {
        //取得地圖圖層中多邊形的渲染樣式（一開始為全透明）
        if overlay is MKPolygon
        {
            let renderPolygon = MKPolygonRenderer(overlay: overlay)
            //設定多邊形範圍內填滿顏色
            renderPolygon.fillColor = UIColor.systemRed.withAlphaComponent(0.1)
            //設定多邊形編框顏色
            renderPolygon.strokeColor = UIColor.systemRed.withAlphaComponent(0.5)
            //設定線條粗細
            renderPolygon.lineWidth = 3
            //回傳多邊形的渲染樣式
            return renderPolygon
        }
        else if overlay is MKCircle
        {
            //取得地圖圖層中圓形的渲染樣式（一開始為全透明）
            let renderCircle = MKCircleRenderer(overlay: overlay)
            //設定圓形範圍內填滿顏色
            renderCircle.fillColor = UIColor.systemRed.withAlphaComponent(0.1)
            //設定圓形編框顏色
            renderCircle.strokeColor = UIColor.systemRed.withAlphaComponent(0.5)
            //設定線條粗細
            renderCircle.lineWidth = 3
            //回傳圓形的渲染樣式
            return renderCircle
        }
        
        //回傳預設的透明樣式
        return MKOverlayRenderer()
    }
    
    //當地圖範圍即將變動時
    func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool)
    {
        print("**********regionWillChangeAnimated 地圖範圍即將變動***********")
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool)
    {
        print("**********regionDidChangeAnimated 地圖範圍已經完成變動***********")
    }
    
    //點選特定的大頭針時
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView)
    {
        selectedPinLocation = view.annotation?.coordinate
    }
    
//MARK: - CLLocationManagerDelegate
    //8.定位管理員完成定位時
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        print("定位完成的目前位置\(locations.first!)")
        //8-1紀錄目前位置
        currentLocation = locations.first!
        
        //8-2顯示定位資訊
        lblAltitude.text = String(format: "%.5f", currentLocation.altitude)
        lblLatitude.text = String(format: "%.5f", currentLocation.coordinate.latitude)
        lblLongitude.text = String(format: "%.5f", currentLocation.coordinate.longitude)
        
        //8-3在地圖上釘上大頭針
        makeSomeMapPin()
        
        //8-4設定地圖顯示範圍，以使用者目前的位置經緯度座標為中心，延伸500公尺框出一個範圍
        let viewRegion = MKCoordinateRegion(center: currentLocation.coordinate, latitudinalMeters: 100000, longitudinalMeters: 100000)
        
        //8-5 將地圖調整到顯示範圍
        mapView.setRegion(viewRegion, animated: true)
        //8-6 停止定位對應start
        locationManager.stopUpdatingLocation()
        
        
    }
    
    //10.定位管理員完成前方方位偵測時
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading)
    {
        print("方位值：\(newHeading.trueHeading)")
        //取得方位值
        let doubleDirection = newHeading.trueHeading
        
        if doubleDirection < 0
        {
            lblDirection.text = "no value"
        }
        else if doubleDirection >= 0 && doubleDirection < 46
        {
            lblDirection.text = "東北"
        }
        else if doubleDirection >= 46 && doubleDirection < 91
        {
            lblDirection.text = "東"
        }
        else if doubleDirection >= 91 && doubleDirection < 136
        {
            lblDirection.text = "東南"
        }
        else if doubleDirection >= 136 && doubleDirection < 181
        {
            lblDirection.text = "南"
        }
        else if doubleDirection >= 181 && doubleDirection < 226
        {
            lblDirection.text = "西南"
        }
        else if doubleDirection >= 226 && doubleDirection < 271
        {
            lblDirection.text = "西"
        }
        else if doubleDirection >= 271 && doubleDirection < 316
        {
            lblDirection.text = "西北"
        }
        else
        {
            lblDirection.text = "北"
        }
    }
    
}

