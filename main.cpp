// File: main.cpp
// Created: suqian2024051604029 3236863614@qq.com      2026-07-16
// Version: 1.0      License: AGPLv3
//强制导入了三方库的路径

#include <QGuiApplication>
#include <QQmlApplicationEngine>

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;
    engine.addImportPath("/usr/lib/qt6/qml");
    engine.addImportPath("/usr/lib/qt6/qml/org/kde/analitza");
    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);
    engine.loadFromModule("todraw", "Window");

    return QCoreApplication::exec();
}
