#include <QApplication>
#include <QQmlApplicationEngine>
#include "qcvimageprovider.h"

int main(int argc, char *argv[])
{
    QApplication app(argc, argv);

    QQmlApplicationEngine engine;

    QCVImageProvider *imageProvider = new QCVImageProvider();
    engine.addImageProvider("QCVProvider", imageProvider);

    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));



    return app.exec();
}
