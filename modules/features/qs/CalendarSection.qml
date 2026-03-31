import QtQuick
import QtQuick.Layouts

Item {
    id: root
    // width: parent?.width ?? 0
    // height: parent?.height ?? 0

    // --- date state ---
    readonly property var today: new Date()
    readonly property int currentDay: today.getDate()
    readonly property int currentMonth: today.getMonth()
    readonly property int currentYear: today.getFullYear()

    // --- grid math ---
    readonly property int firstDayOffset: new Date(currentYear, currentMonth, 1).getDay()
    readonly property int daysInMonth: new Date(currentYear, currentMonth + 1, 0).getDate()
    readonly property int totalCells: firstDayOffset + daysInMonth

    Layout.fillWidth: true
    Layout.fillHeight: true
    // property real cellSize: width / 7
    // Component.onCompleted: console.log("CalendarSection width:", width, parent?.width)

    GridView {
        id: grid
        // Component.onCompleted: console.log("GridView size:", width, height)

        anchors.fill: parent
        cellWidth: Math.floor(parent.width / 7)
        cellHeight: cellWidth  // keep cells square

        interactive: false
        model: root.totalCells

        delegate: Item {
            // Component.onCompleted: console.log("cell size:", width, height)
            required property int index

            readonly property int day: index - root.firstDayOffset + 1
            readonly property bool isValid: index >= root.firstDayOffset
            readonly property bool isToday: isValid && day === root.currentDay

            width: grid.cellWidth
            height: grid.cellHeight

            // today circle
            Rectangle {
                anchors.centerIn: parent
                width: Math.min(parent.width, parent.height) - 8
                height: width
                radius: width / 2
                color: "transparent"
                border.color: isToday ? "#ffffff" : "transparent"
                border.width: 1
                visible: isValid
            }

            Text {
                anchors.centerIn: parent
                text: isValid ? day : ""
                color: isToday ? "#ffffff" : "#888888"
                font.pixelSize: 13
            }
        }
    }
}
