import QtQuick 2.3
import QtQuick.Window 2.2
import QtQuick.Controls 1.2

import "content"

ApplicationWindow {
    visible: true
    width: 800
    height: 1280

    Rectangle {
        color: "#212126"
        anchors.fill: parent
    }

    toolBar: BorderImage {
        border.bottom: 8
        source: "images/toolbar.png"
        width: parent.width
        height: 100

        Rectangle {
            id: backButton
            width: opacity ? 60 : 0
            anchors.left: parent.left
            anchors.leftMargin: 20
            opacity: stackView.depth > 1 ? 1 : 0
            anchors.verticalCenter: parent.verticalCenter
            antialiasing: true
            height: 60
            radius: 4
            color: backmouse.pressed ? "#222" : "transparent"
            Behavior on opacity { NumberAnimation{} }
            Image {
                anchors.verticalCenter: parent.verticalCenter
                source: "images/navigation_previous_item.png"
            }
            MouseArea {
                id: backmouse
                anchors.fill: parent
                anchors.margins: -10
                onClicked: stackView.pop()
            }
        }

        Text {
            font.pixelSize: 72
            Behavior on x { NumberAnimation{ easing.type: Easing.OutCubic} }
            x: backButton.x + backButton.width + 20
            anchors.verticalCenter: parent.verticalCenter
            color: "white"
            text: stackView.depth > 1 ? "Retour au menu principal" : "Menu principal"
            MouseArea {
                anchors.fill: parent
                onClicked: stackView.pop()
            }
        }
    }

    ListModel {
        id: pageModel
        ListElement {
            title: "IHM"
            page: "content/TabBarPage.qml"
        }
        ListElement {
            title: "Capteurs"
            page: "content/SensorsPage.qml"
        }
        ListElement {
            title: "Caméra"
            page: "content/CameraPage.qml"
        }
        ListElement {
            title: "GPS"
            page: "content/GPSPage.qml"
        }
    }

    StackView {
        id: stackView
        anchors.fill: parent
        // Implements back key navigation
        focus: true
        Keys.onReleased: if (event.key === Qt.Key_Back && stackView.depth > 1) {
                             stackView.pop();
                             event.accepted = true;
                         }

        initialItem: Item {
            width: parent.width
            height: parent.height
            ListView {
                model: pageModel
                anchors.fill: parent
                delegate: AndroidDelegate {
                    text: title
                    onClicked: stackView.push(Qt.resolvedUrl(page))
                }
            }
        }
    }

}
