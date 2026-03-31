import QtQuick
import QtQuick.Layouts

Rectangle {
  id: root

  // --- public API ---
  property bool active: true
  property color backgroundColor: "#1c1c1c"
  property color borderColor: "#444444"
  property color borderHoverColor: "#888888"
  property real borderWidth: 1
  property real cornerRadius: 12
  property real scaleFactor: 1.05
  property int animationDuration: 200

  default property alias content: container.data

  // --- layout ---
  visible: opacity > 0
  opacity: active ? 1 : 0
  width: active ? implicitWidth : 0
  implicitWidth: container.implicitWidth + 24
  implicitHeight: container.implicitHeight + 12

  Behavior on opacity { NumberAnimation { duration: root.animationDuration } }
  Behavior on width   { NumberAnimation { duration: root.animationDuration } }

  // --- appearance ---
  color: backgroundColor
  radius: cornerRadius
  border.color: hoverHandler.hovered ? borderHoverColor : borderColor
  border.width: borderWidth

  Behavior on border.color { ColorAnimation { duration: root.animationDuration } }

  // --- hover ---
  scale: hoverHandler.hovered ? scaleFactor : 1.0
  transformOrigin: Item.Center

  Behavior on scale { NumberAnimation { duration: root.animationDuration } }

  HoverHandler { id: hoverHandler }

  // --- content ---
  RowLayout {
    id: container
    anchors.centerIn: parent
  }
}
