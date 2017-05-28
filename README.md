## EasyWeb based on three important trends:
 
#####  NoSQL: Content Model (replaced for database) 
  + content of website is defined by Content Model and saved in Json format files without database system
  + content corresponding with layout

##### Static Generator
  + webpage and other assets is pre-built by EasyWeb
  + monitor the change and generate real time

##### Micro services:  dynamic API services
  + stateless API services clarified by dynamic features of websites
  + internal and 3rd party services
  
  
### Hướng dẫn sử dụng EasyWebBuilder để phát triên website
  - Xem hướng dẫn tại [đây](http://blog.easywebhub.com/how-to-use-easy-builder-to-build-websites/)
  - Mọi ý kiến đóng góp, bổ sung để cải thiện ứng dụng, hãy tương tác với chúng tôi theo 2 cách
     + tạo vấn đề trong phần issue tại [đây](https://github.com/easywebhub/easyapp/issues/new), yêu cầu có account Github
     + gửi email về cho chúng tôi admin@easywebhub.com

### Tham gia phát triển EasyWebBuilder

### Các phần mềm cần chuẩn bị
- NodeJS , [download](https://nodejs.org/en/)
- Git client,vi dụ [GitExtenstion](https://github.com/gitextensions/gitextensions/releases/latest), và [SourceTree](https://www.sourcetreeapp.com)
#### Install 
 - Clone source code,
    - dùng lệnh `git clone https://github.com/easywebhub/easyapp.git` hoặc git client
 
 - vào thư mục, click vào `Install.cmd` để cài đặt thư viện

#### RUN
 - click vao ```RUN.cmd```

#### Build ra application
pc build app cần chạy command này 1 lần, console quyền admin
```
npm install -g electron-packager
```
để build file chạy script:  ```scripts/EWH-package.bat```
