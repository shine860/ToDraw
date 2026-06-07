cmake_minimum_required(VERSION 4.2.3)
set(CMAKE_EXPERIMENTAL_CXX_IMPORT_STD "d0edc3af-4c50-42ea-a356-e2862fe7a444")
# cmake_minimum_required(VERSION 4.3.2)
# set(CMAKE_EXPERIMENTAL_CXX_IMPORT_STD "451f2fe2-a8a2-47c3-bc32-94786d8fc91b")
set(CMAKE_CXX_MODULE_STD ON)

project(ToDraw VERSION 0.1 LANGUAGES CXX)
set(QT_QML_GENERATE_QMLLS_INI ON)

find_package(Qt6 REQUIRED COMPONENTS Core Gui Quick Quick3D Graphs CanvasPainter)
# find_package(Python REQUIRED COMPONENTS Interpreter Development)
qt_standard_project_setup(REQUIRES 6.11)

qt_add_executable(appToDraw  WIN32)
qt_add_qml_module(appToDraw
    URI MyModule
    VERSION 1.0
    SOURCES  main.cpp

    QML_FILES   Window.qml
    SOURCES my2dcanvas.h my2dcanvas.cpp
    SOURCES my2dcanvasrenderer.h my2dcanvasrenderer.cpp

    QML_FILES Content.qml
    QML_FILES Dialog.qml

    QML_FILES Action.qml

)
target_compile_features(appToDraw PRIVATE cxx_std_23)
target_link_libraries(appToDraw PRIVATE
    Qt6::Core
    Qt6::Gui
    Qt6::Quick
    Qt6::Quick3D
    Qt6::Graphs
    Qt6::CanvasPainter
)
# target_link_libraries(appToDraw PRIVATE Python::Python)

set(CMAKE_INSTALL_PREFIX "/opt/${PROJECT_NAME}" CACHE PATH "Install path prefix" FORCE)
install(TARGETS appToDraw
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)

# C++ Modules support
set(TODRAW_MODULE_FILES
    # math.cppm                             # 模块文件
)
source_group("ToDraw" FILES ${TODRAW_MODULE_FILES})
target_sources(appToDraw
    PRIVATE FILE_SET cxx_modules TYPE CXX_MODULES
        BASE_DIRS   ${CMAKE_CURRENT_SOURCE_DIR}
        FILES  ${TODRAW_MODULE_FILES}
)
