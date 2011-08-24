#include <QtGui/QApplication>
#include <QSplashScreen>
#include <QDebug>
#include <QDesktopWidget>
#include "qmlapplicationviewer.h"

int main(int argc, char *argv[])
{
    QApplication app(argc, argv);

    QSplashScreen splash;
    QRect applicationRect = QApplication::desktop()->screenGeometry();

    QPixmap splashPixmap(applicationRect.width(), applicationRect.height());
    splashPixmap.fill(QColor("black"));
    splash.setPixmap(splashPixmap);

    splash.showMessage("Loading...", Qt::AlignHCenter | Qt::AlignVCenter, QColor("white"));

    splash.showFullScreen();

    QmlApplicationViewer viewer;
    viewer.setMainQmlFile(QLatin1String("qml/eDoist/main.qml"));
    viewer.showExpanded();
    splash.finish(&viewer);

    return app.exec();
}
