
### Phát triển EasyWebBuilder

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

### Công nghệ quan trọng đang sử dụng 

#### EasyBuilder 
- Electron để build apps trên windows, mac,  linux
- nodejs, js trong lập trình các tính năng
- [riotjs](http://riotjs.com) cho data binding, component 
- [Semantic ui](https://semantic-ui.com) cho css 
- [json schema editor](https://github.com/jdorn/json-editor) cho Form, Config 
- [monaco editor](https://github.com/Microsoft/monaco-editor) cho code editor

#### EasyWeb
- metalsmith cho static web engine 
    - metalsmith-category
    - metalsmith-tag
    - [metalsmith-permalinks](https://github.com/easywebhub/metalsmith-permalinks)
- handlebarjs cho template engine 
    - handlebar-helpers
    - built-in helpers
