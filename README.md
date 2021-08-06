# flutter_app

A new Flutter application.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

##
搭建了基础框架，写了几个空白界面，可以考虑基于这个来继续写，也可以参考本项目和其他flutter app模板来新开一个项目
参考的是这个空壳模板：https://github.com/xuexiangjys/flutter_template

## 运行

* 查看一下版本号是否正确
```
flutter --version
```

* 运行以下命令查看是否需要安装其它依赖项来完成安装
```
flutter doctor
```

* 运行启动您的应用
```
flutter packages get 
flutter run
```

或者直接AS打开选择设备之后run



新的服务器地址：106.14.157.113:4000

通过api网关，目前把所有api端口绑定在9922，可以用106.14.157.113:9922/{api的路径}来请求，

例如http://106.14.157.113:9922/core-metadata/api/v1/deviceservice


根目录下包含docker-compose yml 文件，用来本地启动后端服务.

```
Docker-compose up
```

