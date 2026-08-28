# ToDraw-函数绘图软件

## 1.项目简介
  ToDraw 是一款基于 Qt6 和 QML 开发的跨平台函数绘图软件，支持 2D 和 3D 函数的可视化，以及矢量场绘制功能。项目灵感来源于 GeoGebra以及algebra，旨在提供轻量级、易用的数学函数图形绘制工具。
## 2.目标用户
  学习函数图像、三角函数、指数对数以及相关矢量场
## 3.功能特性
  2D绘图:多函数同时绘制（支持 + - * / ^ ( ) 及三角函数、对数等），智能网格和刻度生成，鼠标滚轮缩放、拖拽平移，矢量场绘制（基于梯度近似），多种颜色自动分配 
  3D 绘图:基于 Analitza 库的 3D 曲面绘制，多函数叠加显示，鼠标拖拽旋转视角 ，滚轮缩放，3D 矢量场叠加（显式函数），隐式函数矢量场，球面矢量场自动识别
## 4.项目结构
todraw/

├── CMakeLists.txt   

├── main.cpp       

├── Window.qml              # 主窗口

├── Content.qml             # 核心内容布局与逻辑

├── Actions.qml             # 全局动作定义

├── Dialogs.qml             # 对话框集合

├── Graph3DViewWrapper.qml  # 3D视图

├── calculator.js           # 2D数学表达式解析引擎

├── vector3d.js             # 3D矢量场计算引擎

├── todraw.js               # 控制器辅助函数

├── my2dcanvas.h            # 2D画布头文件

├── my2dcanvas.cpp          # 2D画布实现

├── my2dcanvasrenderer.h    # 2D渲染器头文件

└── my2dcanvasrenderer.cpp  # 2D渲染器实现

## 5.安装相关库
'''bash

pacman -S analitza
## 6.体验功能
  克隆之后又一个可执行文件，可以进行执行尝试效果
## 7.联系我们
  如有相关问题、建议，欢迎通过以下方式联系：3236863614@qq.com
