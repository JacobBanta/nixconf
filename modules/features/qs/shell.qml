import QtQuick
import Quickshell
import Quickshell.Wayland

ShellRoot {
    Dropdown {}
    DropdownOverlay {}

    PanelWindow {
        anchors.top: true
        anchors.left: true
        anchors.right: true
        height: 35
        exclusiveZone: 35
        color: "#1c1c1c"

        Row {
            anchors.left: parent.left
            anchors.leftMargin: 6
            anchors.verticalCenter: parent.verticalCenter
            // anchors.centerIn: parent.left
            spacing: 8

            StatWidget {
                active: true

                Text {
                    text: "clock widget"
                    color: "#ffffff"
                }

                TapHandler {
                    onTapped: MyState.toggleDropdown()
                }
            }
        }
        Row {
            anchors.centerIn: parent
            spacing: 8

            StatWidget {
                active: true
                Text { text: "stat widget"; color: "#ffffff" }
            }
        }
    }
}
