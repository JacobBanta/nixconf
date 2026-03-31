import QtQuick
import QtQuick.Layouts

Item {
    default property alias content: container.data

    width: ListView.view.width
    height: ListView.view.height

    ColumnLayout {
        id: container
        anchors.fill: parent
        anchors.margins: 12
    }
}
