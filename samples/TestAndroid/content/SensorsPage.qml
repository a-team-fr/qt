/****************************************************************************
**
** Copyright (C) 2013 Digia Plc and/or its subsidiary(-ies).
** Contact: http://www.qt-project.org/legal
**
** This file is part of the Qt Quick Controls module of the Qt Toolkit.
**
** $QT_BEGIN_LICENSE:BSD$
** You may use this file under the terms of the BSD license as follows:
**
** "Redistribution and use in source and binary forms, with or without
** modification, are permitted provided that the following conditions are
** met:
**   * Redistributions of source code must retain the above copyright
**     notice, this list of conditions and the following disclaimer.
**   * Redistributions in binary form must reproduce the above copyright
**     notice, this list of conditions and the following disclaimer in
**     the documentation and/or other materials provided with the
**     distribution.
**   * Neither the name of Digia Plc and its Subsidiary(-ies) nor the names
**     of its contributors may be used to endorse or promote products derived
**     from this software without specific prior written permission.
**
**
** THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
** "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
** LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
** A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
** OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
** SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
** LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
** DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
** THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
** (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
** OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE."
**
** $QT_END_LICENSE$
**
****************************************************************************/




import QtSensors 5.3
import QtQuick 2.2
import QtQuick.Controls 1.2



Item {
    width: parent.width
    height: parent.height
    id:mainWindow

    TiltSensor {
        id: tilt
        active: true
    }

    AmbientLightSensor {
        id: ambientlight
        active: true

        onReadingChanged: {
            if (reading.lightLevel === AmbientLightReading.Unknown)
                ambiantLightTxt.text = "Ambient light: Unknown";
            else if (reading.lightLevel === AmbientLightReading.Dark)
                ambiantLightTxt.text = "Ambient light: Dark";
            else if (reading.lightLevel === AmbientLightReading.Twilight)
                ambiantLightTxt.text = "Ambient light: Twilight";
            else if (reading.lightLevel === AmbientLightReading.Light)
                ambiantLightTxt.text = "Ambient light: Light";
            else if (reading.lightLevel === AmbientLightReading.Bright)
                ambiantLightTxt.text = "Ambient light: Bright";
            else if (reading.lightLevel === AmbientLightReading.Sunny)
                ambiantLightTxt.text = "Ambient light: Sunny";
        }

    }
    LightSensor {
        id: light
        active: true
    }

    ProximitySensor {
        id: proxi
        active: true
    }

    Compass{
        //This sensor is not supported for Android with Qt 5.3
        id: bous
        active: true
        dataRate:1
        onReadingChanged: {
            boussoleTxt.text = "Boussole :" + reading.azimuth +"° - CL:" + reading.calibrationLevel
        }
    }


    OrientationSensor{
        id:orient
        active:true
        onReadingChanged: {
            if (reading.orientation == OrientationReading.Undefined)
                orientTxt.text = "Orientation: Unknown";
            else if (reading.orientation == OrientationReading.TopUp)
                orientTxt.text = "Orientation: Coté haut en haut";
            else if (reading.orientation == OrientationReading.TopDown)
                orientTxt.text = "Orientation: Coté haut en bas";
            else if (reading.orientation == OrientationReading.LeftUp)
                orientTxt.text = "Orientation: Coté gauche en haut";
            else if (reading.orientation == OrientationReading.RightUp)
                orientTxt.text = "Orientation: Coté droit en haut";
            else if (reading.orientation == OrientationReading.FaceUp)
                orientTxt.text = "Orientation: Face en haut";
            else if (reading.orientation == OrientationReading.FaceDown)
                orientTxt.text = "Orientation: Face en bas";
        }
    }

    AmbientTemperatureSensor{
        id:thermo
        active:true
    }

    RotationSensor{
        id:rot
        active:true
    }

    Gyroscope{
        id:gyro
        active:true
    }

    //property real rollValue:0
    //property real pitchValue:0

    Magnetometer{
        id:magneto
        active:true
        onReadingChanged: {
            //warning : basic (not tilt corrected compass)
            var y = magneto.reading.x
            var x = magneto.reading.y
            var z = magneto.reading.z

            var heading = 0
            if (y>0)
                heading = 90 - (Math.atan2(x,y)) * 180.0 / Math.PI
            else if (y<0)
                heading = 270 - (Math.atan2(x,y)) * 180.0 / Math.PI
            else if (x < 0)
                heading = 180.0
            else
                heading = 0.0
            eadi.yaw = heading


        }
    }

    Accelerometer {
        id: accel
        dataRate: 100
        active:true

        onReadingChanged: {

            //this part is for computing the pitch&Roll
            //ref : http://developer.nokia.com/community/wiki/How_to_get_pitch_and_roll_from_accelerometer_data_on_Windows_Phone
            var Gx = accel.reading.x / 9.81
            var Gy = accel.reading.y / 9.81
            var Gz = accel.reading.z / 9.81
            // pitch = arctan (-Gx/Gz)
            var pitch = Math.atan2(-Gy,Gz)* 180.0 / Math.PI
            eadi.pitch = (pitch >=0) ? (180.0 - pitch):(-pitch -180.0)
            // roll = arctan ( Gy/(sqrt(Gx²-Gz²))
            if (Math.abs(Gy) != Math.abs(Gz))
                eadi.roll = Math.atan2( Gx, Math.sqrt( Gy*Gy- Gz*Gz)) * 180.0 / Math.PI


            //This part is to make the blue bubble moving
            var newX = (bubble.x + calcRoll(accel.reading.x, accel.reading.y, accel.reading.z) * .1)
            var newY = (bubble.y - calcPitch(accel.reading.x, accel.reading.y, accel.reading.z) * .1)

            if (isNaN(newX) || isNaN(newY))
                return;

            if (newX < 0)
                newX = 0

            if (newX > mainWindow.width - bubble.width)
                newX = mainWindow.width - bubble.width

            if (newY < 18)
                newY = 18

            if (newY > mainWindow.height - bubble.height)
                newY = mainWindow.height - bubble.height

                bubble.x = newX
                bubble.y = newY
        }

    }

    function calcPitch(x,y,z) {
        return -(Math.atan(y / Math.sqrt(x * x + z * z)) * 57.2957795);
    }
    function calcRoll(x,y,z) {
         return -(Math.atan(x / Math.sqrt(y * y + z * z)) * 57.2957795);
    }

    /*Image {
        id: bubble
        source: "content/Bluebubble.svg"
        smooth: true
        property real centerX: mainWindow.width / 2
        property real centerY: mainWindow.height / 2
        property real bubbleCenter: bubble.width / 2
        x: centerX - bubbleCenter
        y: centerY - bubbleCenter

        Behavior on y {
            SmoothedAnimation {
                easing.type: Easing.Linear
                duration: 100
            }
        }
        Behavior on x {
            SmoothedAnimation {
                easing.type: Easing.Linear
                duration: 100
            }
        }
    }
    */
    Column {
        id: column
        anchors.top: parent.top
        anchors.left: parent.left
        width: parent.width
        anchors.margins: 7

        Text {
            id:  boussoleTxt
            text: "Boussole : unknown"
            font.pointSize: 12
            color: "white"
        }
        Text {
            id:  thermotxt
            text: "température ambiante :" + thermo.reading.temperature +"°C"
            font.pointSize: 12
            color: "white"
        }
        Text {
            id:  magnetoTxt
            text: "Magneto x :"+ magneto.reading.x +"- y :"+magneto.reading.y+"- z :"+magneto.reading.z
            font.pointSize: 12
            color: "white"
        }
        Text {
            id:  orientTxt
            text: "Orientation : unknown"
            font.pointSize: 12
            color: "white"
        }
        Text {
            id:  gyroTxt
            text: "Gyro x :"+gyro.reading.x+"- y :"+gyro.reading.y+"- z :"+gyro.reading.z
            font.pointSize: 12
            color: "white"
        }
        Text {
            id:  rotationTxt
            text: "Rotation x :"+rot.reading.x+"- y :"+rot.reading.y+"- z :"+rot.reading.z
            font.pointSize: 12
            color: "white"
        }
        Text {
            id:  ambiantLightTxt
            font.pointSize: 12
            color: "white"
        }
        Text {
            id:  lightTxt
            text: "Luminosité : " + light.reading.illuminance
            font.pointSize: 12
            color: "white"
        }
        Text {
            id: proxitext
            font.pointSize: 12
            color: "white"
            text: "Proximity: " +
                  (proxi.active ? (proxi.reading.near ? "Near" : "Far") : "Unknown")
        }

    }

    Rectangle{
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: column.bottom
        width:600
        height:600
        EADI {
            id: eadi
            //demo:true
            //roll: rollValue
            //pitch: pitchValue
            //yaw:rot.reading.z
        }
    }



    Rectangle {
            id: bubble
            color: "blue"
            width: 84
            height : 84
            radius: 84


            //source: "content/Bluebubble.svg"
            smooth: true
            property real centerX: mainWindow.width / 2
            property real centerY: mainWindow.height / 2
            property real bubbleCenter: bubble.width / 2
            x: centerX - bubbleCenter
            y: centerY - bubbleCenter

            Behavior on y {
                SmoothedAnimation {
                    easing.type: Easing.Linear
                    duration: 100
                }
            }
            Behavior on x {
                SmoothedAnimation {
                    easing.type: Easing.Linear
                    duration: 100
                }
            }
        }
}

//source à télécharger:
//http://memsblog.wordpress.com/2012/03/23/source-form-for-ecompass-software-and-4-and-7-element-magnetic-routines-yes/

// src : http://circuitcellar.com/cc-blog/implement-a-tilt-and-interference-compensated-electronic-compass/
/*void eCompass(float Bx, float By, float Bz, float Gx, float Gy, float Gz)
{

    //http://cache.freescale.com/files/sensors/doc/fact_sheet/eCompassFS.pdf

    // calculate roll angle Phi (-180deg -> 180deg)
    Phi = atan2(Gy,Gz)*RadToDeg;
    var sinAngle = sin(Phi * DegToRad);
    var cosAngle = cos(Phi * DegTORad);
    //de-rotate by rollangle phi
    Bfy = By

}*/
