import Quickshell
import QtQuick

PanelWindow {
  anchors {
    top: true
    left: true
    right: true
  }

  implicitHeight: 30

  Row{
    anchors.centerIn: parent
    StatWidget {
      id: widget
      active: true

      Text {
        text: "75%"
        color: "#ffffff"
      }

      Timer {
        running: true
        repeat: true
        interval: 5000
        onTriggered: widget.active = !widget.active
      }
    }
    StatWidget {
      id: widget2
      active: false

      Text {
        text: "75%"
        color: "#ffffff"
      }

      Timer {
        running: true
        repeat: true
        interval: 7000
        onTriggered: widget2.active = !widget2.active
      }
    }
  }
}
