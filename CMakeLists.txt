cmake_minimum_required(VERSION 4.3.2)
set(CMAKE_EXPERIMENTAL_CXX_IMPORT_STD "451f2fe2-a8a2-47c3-bc32-94786d8fc91b")
set(CMAKE_CXX_MODULE_STD ON)

project(todraw VERSION 0.1 LANGUAGES CXX)
find_package(Analitza6 REQUIRED)
find_package(Qt6 REQUIRED COMPONENTS  Core Gui Quick Quick3D Graphs CanvasPainter)
qt_standard_project_setup(REQUIRES 6.10)

qt_add_executable(appToDraw  WIN32)

qt_add_qml_module(appToDraw
    URI todraw
    VERSION 1.0
    SOURCES     main.cpp
    SOURCES my2dcanvas.h my2dcanvasrenderer.h
    SOURCES my2dcanvas.cpp my2dcanvasrenderer.cpp
    IMPORT_PATH "/usr/lib/qt6/qml"
    IMPORT_PATH "/usr/lib/qt6/qml/org/kde/analitza"
    QML_FILES
        Actions.qml
        Content.qml
        Dialogs.qml
        Window.qml
        calculator.js
        Graph3DViewWrapper.qml
        todraw.js
    NO_IMPORT_SCAN
    QML_FILES vector3d.js

)

# target_include_directories(appToDraw PRIVATE  ./src/)
target_compile_features(appToDraw PRIVATE cxx_std_23)
target_link_libraries(appToDraw
    PRIVATE Qt6::Quick
    Qt6::Core
    Qt6::Gui
    Qt6::Quick
    Qt6::Quick3D
    Qt6::Graphs
    Qt6::CanvasPainter
    KF6::Analitza
)

set(CMAKE_INSTALL_PREFIX "/opt/${PROJECT_NAME}" CACHE PATH "Install path prefix" FORCE)
install(TARGETS appToDraw
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)

# C++ Modules support
set(ToDraw_MODULE_FILES
    # math.cppm                             # 模块文件
)
source_group("ToDraw" FILES ${ToDraw_MODULE_FILES})
target_sources(appToDraw
    PRIVATE FILE_SET cxx_modules TYPE CXX_MODULES
    BASE_DIRS   ${CMAKE_CURRENT_SOURCE_DIR}
    FILES  ${ToDraw_MODULE_FILES}
)
