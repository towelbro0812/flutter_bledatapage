# 2023 旺宏晶矽獎二組

## 寫給協作開發者的話
所有程式碼皆放在lib資料夾內，關於裡面的每一個檔案的說明
1. **main.dart** :主程式，放置掃描藍芽設備與權限控制的頁面
2. **ble_process**:控制動態申請手機的一個程式碼，因為太攏長所以獨立拉出一頁
3. **\psges\ble_page.dart**:這是能夠接收藍芽輸入的一個監聽式動態頁面
4. **\psges\non_ble_page.dart**:這是能沒接收藍芽輸入的一個輪播資料頁面(晚點放)
5. **\psges\ble_widget.dart**:這是設備頁面下方那個有顏色的方塊的頁面

目前就這些東西，有補充我會持續增加
