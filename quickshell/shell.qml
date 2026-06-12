import Quickshell
import Quickshell.Wayland
import Quickshell.Io
import Quickshell.Hyprland
import QtQuick
import Quickshell.Services.SystemTray
import QtQuick.Layouts

PanelWindow {
    id: root

    // Theme
    property color colCyan: "#0db9d7"
    property color colBlue: "#7aa2f7"
    property color colYellow: "#e0af68"
    property color colBg: "#000000"
    property color colFg: "#ffffff"
    property color colMuted: "#222222"
    property color colActive: "#ffffff"
    property color colInactive: "#555555"
    property string fontFamily: "JetBrains Mono"
    property bool trayOpen: false
    property int pixelSize: 15
    property int fontSize: 14
    property var cavaBars: []

    // System data
    property int cpuUsage: 0
    property int memUsage: 0
    property var lastCpuIdle: 0
    property var lastCpuTotal: 0
    property int memTotal: 0
    property int memAvail: 0
    property int cpuTemp: 0
    property int volume: 0
    property int brightness: 0
    property int brightnessMax: 1
    property int battery: 0
    property string batteryStatus: ""
    // playerctl data
    property string nowTitle: ""
    property string nowArtist: ""
    property bool nowPlaying: false

    // Processes and timers here...
    //volume and brightness
    Process {
        id: volumeReader
        command: ["wpctl", "get-volume", "@DEFAULT_AUDIO_SINK@"]
        running: true
        stdout: SplitParser {
            onRead: data => {
                var match = data.match(/(\d+\.\d+)/);
                if (match)
                    root.volume = Math.round(parseFloat(match[1]) * 100);
            }
        }
    }
    Process {
        id: volumeWatcher
        command: ["pactl", "subscribe"]
        running: true
        stdout: SplitParser {
            onRead: data => {
                if (data.includes("sink") || data.includes("server")) {
                    volumeReader.running = true;
                }
            }
        }
    }

    Process {
        id: brightnessReader
        command: ["brightnessctl", "get"]
        running: true
        stdout: SplitParser {
            onRead: data => root.brightness = parseInt(data.trim())
        }
    }

    Process {
        id: brightnessMaxReader
        command: ["brightnessctl", "max"]
        running: true
        stdout: SplitParser {
            onRead: data => root.brightnessMax = parseInt(data.trim())
        }
    }

    Timer {
        interval: 100
        running: true
        repeat: true
        onTriggered: brightnessReader.running = true
    }

    // CPU
    Timer {
        interval: 2000
        running: true
        repeat: true
        onTriggered: cpuReader.running = true
    }

    Process {
        id: cpuReader
        command: ["cat", "/proc/stat"]
        stdout: SplitParser {
            onRead: data => {
                if (!data.startsWith("cpu "))
                    return;
                var parts = data.trim().split(/\s+/);
                var idle = parseInt(parts[4]);
                var total = parts.slice(1).reduce((a, b) => a + parseInt(b), 0);
                var diffIdle = idle - root.lastCpuIdle;
                var diffTotal = total - root.lastCpuTotal;
                root.cpuUsage = diffTotal > 0 ? Math.round((1 - diffIdle / diffTotal) * 100) : 0;
                root.lastCpuIdle = idle;
                root.lastCpuTotal = total;
                cpuReader.running = false;
            }
        }
    }
    Process {
        id: tempReader
        command: ["cat", "/sys/class/thermal/thermal_zone0/temp"]
        stdout: SplitParser {
            onRead: data => root.cpuTemp = Math.round(parseInt(data.trim()) / 1000)
        }
    }

    Timer {
        interval: 2000
        running: true
        repeat: true
        onTriggered: tempReader.running = true
    }

    // Memory
    Process {
        id: memReader
        command: ["cat", "/proc/meminfo"]
        running: true
        stdout: SplitParser {
            onRead: data => {
                if (data.startsWith("MemTotal:")) {
                    root.memTotal = parseInt(data.split(/\s+/)[1]);
                } else if (data.startsWith("MemAvailable:")) {
                    root.memAvail = parseInt(data.split(/\s+/)[1]);
                    root.memUsage = Math.round((1 - root.memAvail / root.memTotal) * 100);
                }
            }
        }
    }

    Timer {
        interval: 2000
        running: true
        repeat: true
        onTriggered: memReader.running = true
    }
    //battery
    Process {
        id: batteryReader
        command: ["bash", "-c", "cat /sys/class/power_supply/BAT1/capacity"]
        running: true
        stdout: SplitParser {
            onRead: data => root.battery = parseInt(data.trim())
        }
    }

    Process {
        id: batteryStatusReader
        command: ["bash", "-c", "cat /sys/class/power_supply/BAT1/status"]
        running: true
        stdout: SplitParser {
            onRead: data => root.batteryStatus = data.trim()
        }
    }

    Timer {
        interval: 30000
        running: true
        repeat: true
        onTriggered: {
            batteryReader.running = true;
            batteryStatusReader.running = true;
        }
    }

    Process {
        id: playerTitle
        command: ["playerctl", "metadata", "--follow", "--format", "{{title}}"]
        running: true
        stdout: SplitParser {
            onRead: data => root.nowTitle = data.trim()
        }
    }

    Process {
        id: playerArtist
        command: ["playerctl", "metadata", "--follow", "--format", "{{artist}}"]
        running: true
        stdout: SplitParser {
            onRead: data => root.nowArtist = data.trim()
        }
    }

    Process {
        id: playerStatus
        command: ["playerctl", "status", "--follow"]
        running: true
        stdout: SplitParser {
            onRead: data => root.nowPlaying = data.trim() === "Playing"
        }
    }
    Process {
        id: cavaProcess
        command: ["cava", "-p", "/home/diller/.config/cava/quickshell.conf"]
        running: true
        stdout: SplitParser {
            onRead: data => {
                var bars = data.trim().split(";").filter(b => b !== "").map(b => parseInt(b));
                if (bars.length > 0)
                    root.cavaBars = bars;
            }
        }
    }
    anchors.top: true
    anchors.left: true
    anchors.right: true
    implicitHeight: 30
    color: root.colBg

    RowLayout {
        anchors.fill: parent
        anchors.margins: 8
        spacing: 8

        // Workspaces
        Repeater {
            model: 9
            Text {
                property var ws: Hyprland.workspaces.values.find(w => w.id === index + 1)
                property bool isActive: Hyprland.focusedWorkspace?.id === (index + 1)
                text: index + 1
                color: isActive ? root.colFg : (ws ? root.colInactive : root.colMuted)
                font {
                    family: root.fontFamily
                    pixelSize: root.fontSize
                    bold: true
                }
                MouseArea {
                    anchors.fill: parent
                    onClicked: Hyprland.dispatch("workspace " + (index + 1))
                }
            }
        }
        Rectangle {
            visible: root.nowTitle !== ""
            width: 1
            height: 16
            color: root.colMuted
        }

        // Now Playing
        Text {
            visible: root.nowTitle !== ""
            text: (root.nowPlaying ? "▶ " : "⏸ ") + root.nowArtist + " — " + root.nowTitle
            color: root.colFg
            font {
                family: root.fontFamily
                pixelSize: root.fontSize
            }
            elide: Text.ElideRight
            Layout.maximumWidth: 300
        }
        Row {
            spacing: 2
            height: 20
            visible: root.nowPlaying
            anchors.verticalCenter: parent.verticalCenter
            Repeater {
                model: root.cavaBars.length
                Item {
                    width: 3
                    height: 20
                    Rectangle {
                        width: 3
                        height: Math.max(2, (root.cavaBars[index] / 7) * 20)
                        anchors.bottom: parent.bottom
                        color: {
                            var t = root.cavaBars[index] / 7;
                            var v = Math.round(80 + (255 - 80) * t);
                            return Qt.rgba(v / 255, v / 255, v / 255, 1.0);
                        }
                        opacity: 0.6 + (root.cavaBars[index] / 7) * 0.4

                        Behavior on height {
                            NumberAnimation {
                                duration: 80
                                easing.type: Easing.OutCubic
                            }
                        }
                    }
                }
            }
        }
        Rectangle {
            visible: root.nowTitle !== ""
            width: 1
            height: 16
            color: root.colMuted
        }
        Text {
            text: ToplevelManager.activeToplevel ? ToplevelManager.activeToplevel.appId : ""
            color: root.colInactive
            font {
                family: root.fontFamily
                pixelSize: root.fontSize
            }
            elide: Text.ElideRight
            Layout.fillWidth: true
            horizontalAlignment: Text.AlignHCenter
            Component.onCompleted: console.log(JSON.stringify(Hyprland.focusedClient))
        }
        Rectangle {
            width: 1
            height: 16
            color: root.colMuted
        }

        Text {
            text: "CPU: " + cpuUsage + "%" + "/" + cpuTemp + "°C"
            color: root.colFg
            font {
                family: root.fontFamily
                pixelSize: root.fontSize
            }
        }
        Rectangle {
            width: 1
            height: 16
            color: root.colMuted
        }

        // Memory
        Text {
            text: "Mem: " + memUsage + "%"
            color: root.colFg
            font {
                family: root.fontFamily
                pixelSize: root.fontSize
                bold: true
            }
        }
        Rectangle {
            width: 1
            height: 16
            color: root.colMuted
        }

        Text {
            text: "BRI: " + Math.round((root.brightness / root.brightnessMax) * 100) + "%"
            color: root.colFg
            font {
                family: root.fontFamily
                pixelSize: root.fontSize
            }
        }
        Rectangle {
            width: 1
            height: 16
            color: root.colMuted
        }

        Text {
            text: "VOL: " + root.volume + "%"
            color: root.colFg
            font {
                family: root.fontFamily
                pixelSize: root.fontSize
            }
        }
        Rectangle {
            width: 1
            height: 16
            color: root.colMuted
        }

        Text {
            text: (root.batteryStatus === "Charging" ? "CHR " : "BAT ") + root.battery + "%"
            color: root.battery < 20 ? "#ff5555" : root.colFg
            font {
                family: root.fontFamily
                pixelSize: root.fontSize
            }
        }
        Rectangle {
            width: 1
            height: 16
            color: root.colMuted
        }

        Repeater {
            model: SystemTray.items
            delegate: Item {
                width: 16
                height: 16
                Image {
                    anchors.fill: parent
                    source: modelData.icon
                }
                MouseArea {
                    anchors.fill: parent
                    acceptedButtons: Qt.LeftButton | Qt.RightButton
                    onClicked: {
                        if (mouse.button === Qt.RightButton)
                            modelData.secondaryActivate();
                        else
                            modelData.activate();
                    }
                }
            }
        }

        Rectangle {
            width: 1
            height: 16
            color: root.colMuted
        }
        // Clock
        Text {
            id: clock
            color: root.colFg
            font {
                family: root.fontFamily
                pixelSize: root.fontSize
                bold: true
            }
            text: Qt.formatDateTime(new Date(), "ddd, MMM dd - HH:mm")
            Timer {
                interval: 1000
                running: true
                repeat: true
                onTriggered: clock.text = Qt.formatDateTime(new Date(), "ddd, MMM dd - HH:mm:ss")
            }
        }
    }
}
