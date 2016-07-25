#### Install 
 - Cài đặt [nodejs](https://nodejs.org/en/)
 - Download zip folder of this repository
 - click vào ```INSTALL.cmd``` 

#### RUN
 - click vao ```RUN.cmd```
 
### Hướng dẫn Sử dụng cơ bản

Nên chạy với chế độ debug ```DEBUB.cmd``` để dễ dàng refresh (Ctrl + R hoặc F5)

#### 1. Login
 - Chỉ cần click vào ```Sign in for EasyWeb``` mà không cần account
    (điều chỉnh sẽ bổ sung sau)
 
#### 2. Chọn 1 website
 - Tạo mới site, sau khi xong cần refresh app, chạy lại để thấy site mới tạo (sẽ FIX)
 - copy source vào thư mục ```/sites/``` refresh để hiển thị
#### 3. Điều chỉnh nội dung
 - xem hình đính kèm
 ![](https://raw.githubusercontent.com/easywebhub/easyapp/master/documents/ewa-editor.png)

#### 4. public lên github
 1. tạo 1 repo mới hoàn toàn trên github
 - init account trên easyApp
 - Chạy Install, wath bằng tay,
 - Chạy Sync để lưu code trên github
 - Chạy Deploy để public code lên github.io

#### 5. Điều chỉnh để hoạt động tốt trên github.io/xxx  url
do github.io/repo-name nên cần điều chỉnh trong global.json cho phù hợp và build lại

 ![](https://raw.githubusercontent.com/easywebhub/easyapp/master/documents/ewa-github-url.png)
 
 #### 6. Build ra application
pc build app cần chạy command này 1 lần, console quyền admin
```
npm install -g electron-packager
```
để build file chạy script:  ```scripts/EWH-package.bat```
