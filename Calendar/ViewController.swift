//
//  ViewController.swift
//  Calendar
//
//  Created by Peiyun on 2022/12/26.
//

import UIKit

class ViewController: UIViewController,UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    

    @IBOutlet weak var calendar: UICollectionView!
    
    //月份與年份
    @IBOutlet weak var timeLabel: UILabel!
    
    
    //下個月
    @IBAction func nextMonth(_ sender: UIButton) {
        currentMonth += 1
        if currentMonth == 13{
            currentMonth = 1
            currentYear += 1
        }
        setUp()
    }
    //上個月
    @IBAction func lastMonth(_ sender: UIButton) {
        currentMonth -= 1
        if currentMonth == 0{
            currentMonth = 12
            currentYear -= 1
        }
        setUp()
    }
    
    
    //顯示年份
    //呼叫手機內內建的日曆實體Calendar類別(不需初始化)
    var currentYear = Calendar.current.component(.year, from: Date())
    //顯示月份
    var currentMonth = Calendar.current.component(.month, from: Date())
    var months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
    
    
    
    //知道這個月有幾天
    //這種寫法叫computed property，可以計算出來的屬性
    var numberOfDaysInThisMonth:Int{
        let dateComponents = DateComponents(year:currentYear, month: currentMonth)
        let date = Calendar.current.date(from: dateComponents)!
            //設定range
        let range = Calendar.current.range(of: .day, in: .month, for: date)
        //有值則回傳range，無值回傳0
        return range?.count ?? 0

    }
    
    //確認每個月第一天是星期幾
    var whatDayIsIt:Int{
        let dateComponents = DateComponents(year:currentYear, month: currentMonth)
        let date = Calendar.current.date(from: dateComponents)!
        //取得第一天是星期幾
        
        return Calendar.current.component(.weekday, from: date)
    }
    
    //加上有幾格空白
    //ex:一個月的第一天是週五，則return為6(週日為1)，前面有5個空白
    var howManyItemsShouldIAdd:Int{
        return whatDayIsIt - 1
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setUp()
    }

    
    //顯示正確的日期
    
    func setUp() {
        timeLabel.text = months[currentMonth-1] + String( currentYear)
        calendar.reloadData()
        print(whatDayIsIt)
        
    }
    
    
    //UICollectionViewDelegate, UICollectionViewDataSource的方法
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberOfDaysInThisMonth + howManyItemsShouldIAdd
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //看是否有可回收的collectionViewCell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        
        //設定顯示的文字(因collectionView無法跟tableCiew一樣用textLabel顯示文字)
        //subviews:找到contentView的所有物件
        if let textLabel = cell.contentView.subviews[0] as? UILabel{
            //顯示空格
            if indexPath.row < howManyItemsShouldIAdd{
                textLabel.text = ""
            }else{
                //因indexPath.row從0開始，故第一個數顯示1要加一
                textLabel.text = String(indexPath.row + 1 - howManyItemsShouldIAdd)
            }
            
        }
        return cell
    }
    
    
    
    
    //日期的label文字對齊畫面，加入UICollectionViewDelegateFlowLayout
    //cell每個item左右間隔為0
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    //cell每個item上下間隔為0
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    //每個橫列只顯示七個item
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width/7
        return CGSize(width: width, height: 40)
    }
    
    


    
    //解決轉向時會跑版的問題
    //轉向時會執行這個方法
    override func viewWillLayoutSubviews() {
        //先呼叫父類別
        super.viewWillLayoutSubviews()
        //在轉向時重新計算每個cell的大小
        calendar.collectionViewLayout.invalidateLayout()
        calendar.reloadData()
    }

}

