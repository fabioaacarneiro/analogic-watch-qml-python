import QtQuick
import QtQuick.Controls

ApplicationWindow {
    id: applicationWindow
    visible: true
    width: 400
    height: 400
    title: 'Clock'
    flags: Qt.FramelessWindowHint | Qt.Window
    property var hms: {
        'hours': 0,
        'minutes': 0,
        'seconds': 0
    }
    property QtObject backend
    color: 'transparent'

    Button {
        id: close
        text: ' X '
        onClicked: applicationWindow.close()

        contentItem: Text {
            text: close.text
            font: close.font
            opacity: enabled ? 1 : 0.3
            color: close.down ? '#000' : '#555'
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            elide: Text.ElideRight
        }

        background: Rectangle {
            implicitWidth: 40
            implicitHeight: 40
            opacity: enabled ? 1 : 0.3
            border.color: control.down ? '#f00' : '#f55'
            border.width: 2
            radius: 40
        }
    }
        
    Image {
        id: clockface
        sourceSize.width: parent.width
        fillMode: Image.PreserveAspectFit
        source: '../assets/img/clockface.png'

        Image {
            x: clockface.width / 2 - width / 2
            y: (clockface.height / 2) - height / 2
            scale: clockface.width / 465
            source: '../assets/img/hour.png'
            antialiasing: true
            transform: Rotation {
                origin.x: 12.5
                origin.y: 166
                angle: (hms.hours * 30) + (hms.minutes * 0.5)
            }
        }

        Image {
            x: clockface.width / 2 - width / 2
            y: clockface.height / 2 - height / 2
            scale: clockface.width / 465
            source: '../assets/img/minute.png'
            antialiasing: true
            transform: Rotation  {
                origin.x: 5.5
                origin.y: 201
                angle: hms.minutes * 6
                Behavior on angle {
                    SpringAnimation {
                        spring: 1
                        damping: 0.2
                        modulus: 360
                    }
                }
            }
        }

        Image {
            x: clockface.width / 2 - width / 2
            y: clockface.height / 2 - height / 2
            scale: clockface.width / 465
            source: '../assets/img/second.png'
            antialiasing: true
            transform: Rotation  {
                origin.x: 2
                origin.y: 202
                angle: hms.seconds * 6
                Behavior on angle {
                    SpringAnimation {
                        spring: 3
                        damping: 0.2
                        modulus: 360
                    }
                }
            }
        }
        
        Image {
            x: clockface.width / 2 - width / 2
            y: clockface.height / 2 - height / 2
            scale: clockface.width / 465
            source: '../assets/img/cap.png'
        }
    }

    Connections {
        target: backend

        function onHms(hours, minutes, seconds) {
            hms = {
                'hours': hours,
                'minutes': minutes,
                'seconds': seconds
            }
        }
    }
}