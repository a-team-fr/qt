import QtQuick 2.3

Rectangle {
    id:container
    property real roll : 0
    property real pitch : 0
    property real yaw : 0
    property bool demo : false
    anchors.fill:parent
    color : "blue"

    property real pitchValue : demo ? demoAngle : pitch
    property real rollValue: demo ? demoAngle*2 : roll
    property real yawValue: demo ? -demoAngle*3 : yaw


    property real demoAngle: 0
    SequentialAnimation on demoAngle {
        loops: Animation.Infinite
        running: demo
        NumberAnimation {
            from: 0
            to: 15
            duration: 3000
        }
        NumberAnimation {
            from: 15
            to: 0
            duration: 3000
        }
    }



    Image{
        source: "qrc:/images/eadi_cache.png"
        //anchors.horizontalCenter : container.horizontalCenter
        //anchors.verticalCenter : container.verticalCenter
        clip: true
        anchors.fill:parent
        width:parent.width
        height:parent.height


        Image{
            id:ring
            rotation: yawValue
            //width:parent.width
            //height:parent.height
            source: "qrc:/images/eadi_couronne.png"
            //anchors.horizontalCenter : parent.horizontalCenter
            //anchors.verticalCenter : parent.verticalCenter
            anchors.fill:parent
        }

        Rectangle{
            id:horizon
            height: parent.height*0.5 + pitchValue * container.height /200
            rotation: rollValue
            width:parent.width *1.5
            color: "red"
            anchors.horizontalCenter : parent.horizontalCenter
            anchors.bottom : parent.bottom
            z:-1
        }
    }

    Column {
        id: column
        anchors.top: parent.top
        anchors.left: parent.left
        width: parent.width

        Text {
            id:  pitchTxt
            text: "Pitch : " + pitchValue.toLocaleString() + "°"
            font.pointSize: 10
            color: "white"
        }
        Text {
            id:  rollTxt
            text: "Roll : " + rollValue.toLocaleString() + "°"
            font.pointSize: 10
            color: "white"
        }
        Text {
            id:  yawTxt
            text: "heading : " + yawValue.toLocaleString() + "°"
            font.pointSize: 10
            color: "white"
        }
    }


}
