import QtQuick 2.3
import QtQuick.Controls 1.2

ApplicationWindow {
    visible: true
    //width: 640
    //height: 480
    title: qsTr("Hello World")

    menuBar: MenuBar {
        Menu {
            title: qsTr("File")
            MenuItem {
                text: qsTr("&Open")
                onTriggered: console.log("Open action triggered");
            }
            MenuItem {
                text: qsTr("Exit")
                onTriggered: Qt.quit();
            }
        }
    }
    
    Image{
        source: "image://QCVProvider/test"
        //source: "http://qt-project.org/doc/qt-5/images/imageprovider.png"
        cache: false
        anchors.fill:parent
    }
}
