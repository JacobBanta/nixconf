import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland

PanelWindow {
    id: root

    // --- public API ---
    property real anchorX: 0
    property color backgroundColor: "#1c1c1c"
    property color borderColor: "#444444"
    property int animationDuration: 200

    // --- window setup ---
    visible: panel.y > -420
    exclusionMode: ExclusionMode.Ignore
    WlrLayershell.layer: WlrLayer.Overlay
    color: "transparent"

    anchors.top: true
    anchors.left: true
    margins.top: 35

    width: 380
    height: panel.height + 16 // margin below bar

    focusable: true

    // --- inner panel ---
    Rectangle {
        id: panel

        width: root.width - 24
        height: 420
        x: root.anchorX - 12
        y: MyState.dropdownOpen ? 8 : -height  // 8px gap below bar

        color: root.backgroundColor
        radius: 12
        border.color: root.borderColor
        border.width: 1

        clip: true

        Behavior on y { NumberAnimation { duration: root.animationDuration; easing.type: Easing.OutCubic } }

        // --- section switcher ---
        ColumnLayout {
            anchors.fill: parent
            spacing: 0

            // tab buttons
            RowLayout {
                Layout.fillWidth: true
                Layout.preferredHeight: 50
                Layout.leftMargin: 18
                Layout.rightMargin: 6
                spacing: 4

                Repeater {
                    model: ["Clock", "Media", "Stats"]

                    Rectangle {
                        required property string modelData
                        required property int index

                        Layout.fillWidth: true
                        height: 32
                        radius: 8
                        color: MyState.currentSection === index ? "#333333" : "transparent"

                        Behavior on color { ColorAnimation { duration: 150 } }

                        Text {
                            anchors.centerIn: parent
                            text: parent.modelData
                            color: "#ffffff"
                        }

                        HoverHandler { id: tabHover }
                        TapHandler { onTapped: MyState.goToSection(index) }
                    }
                }
            }

            // section content
            ListView {
                id: sectionView

                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.leftMargin: 12
                // height: parent.height - 80

                orientation: ListView.Horizontal
                snapMode: ListView.SnapOneItem
                interactive: false
                highlightMoveDuration: root.animationDuration
                currentIndex: MyState.currentSection

                model: 3

                delegate: Item {
                    required property int index
                    width: ListView.view.width
                    height: ListView.view.height

                    Loader {
                        anchors.fill: parent
                        source: ["CalendarSection.qml", "MediaSection.qml", "StatsSection.qml"][index]
                    }
                }
            }
        }

        // escape to close
        Shortcut {
            sequence: "Escape"
            onActivated: MyState.toggleDropdown()
        }
    }
}
