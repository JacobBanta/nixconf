import QtQuick
import Quickshell
import Quickshell.Wayland

PanelWindow {
    visible: MyState.dropdownOpen
    color: "transparent"
    exclusionMode: ExclusionMode.Ignore
    // height: screen.height - 35

    anchors {
        top: true
        left: true
        right: true
        bottom: true
    }

    MouseArea {
        anchors.fill: parent
        onClicked: MyState.toggleDropdown()
    }
}
