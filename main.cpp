#include <QGuiApplication>
#include <QQmlApplicationEngine>


int main(int argc, char *argv[])
{

    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;
    // qmlRegisterType<My2DCanvas>("MyCanvasModule", 1, 0, "My2DCanvas");
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreationFailed,
                     &app, []() { QCoreApplication::exit(-1); },
                     Qt::QueuedConnection);
    engine.loadFromModule("MyModule", "Window");

    return QGuiApplication::exec();
}
