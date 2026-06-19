import Quickshell
import Quickshell.Wayland
import QtQuick
import QtQuick.Layouts
import Quickshell.Services.Notifications

ShellRoot {
    ListModel {
        id: notifList
    }

    NotificationServer {
        id: server
        keepOnReload: true
        onNotification: notif => {
            notifList.append({
                "summary": notif.summary ?? "",
                "body": notif.body ?? "",
                "appName": notif.appName ?? "",
                "expireTimeout": notif.expireTimeout
            });
            notif.tracked = true;
        }
    }

    Repeater {
        model: notifList
        PanelWindow {
            anchors.bottom: true
            anchors.right: true
            margins.bottom: 5 + index * 75
            margins.right: 5
            implicitWidth: 280
            implicitHeight: 60
            color: "transparent"

            Rectangle {
                anchors.fill: parent
                color: "#000000"
                border.color: "#ffffff"
                border.width: 1

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 10
                    spacing: 2

                    Text {
                        text: model.appName.toUpperCase()
                        color: "#555555"
                        font {
                            family: "JetBrains Mono"
                            pixelSize: 10
                        }
                    }

                    Text {
                        text: model.summary
                        color: "#ffffff"
                        font {
                            family: "JetBrains Mono"
                            pixelSize: 11
                            bold: true
                        }
                        elide: Text.ElideRight
                        Layout.fillWidth: true
                    }

                    Text {
                        visible: model.body !== ""
                        text: model.body
                        color: "#aaaaaa"
                        font {
                            family: "JetBrains Mono"
                            pixelSize: 10
                        }
                        elide: Text.ElideRight
                        Layout.fillWidth: true
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: notifList.remove(index)
                }
            }

            Timer {
                interval: model.expireTimeout > 0 ? model.expireTimeout : 4000
                running: true
                onTriggered: notifList.remove(index)
            }
        }
    }
}
