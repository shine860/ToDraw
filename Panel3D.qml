import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

ColumnLayout {
    id: threeD
    spacing: 10

    property alias functionText: function3DInput.text

    signal functionChanged(string newInput)
    signal zoomIn()
    signal zoomOut()
    signal resetView()

    Label {
        text: "3D Function"
        Layout.fillWidth: true
        horizontalAlignment: Text.AlignHCenter
        font.bold: true
        font.pixelSize: 15
        ToolTip {
            visible: tooltip3D.hovered
            text: "支持: + - * / ^ ( )\n函数: sin, cos, tan, log\n变量: x 和 y"
        }
        HoverHandler { id: tooltip3D }
    }

    TextField {
        id: function3DInput
        color: "#333333"
        horizontalAlignment: Text.AlignHCenter
        font.pixelSize: 15
        text: "sin(x)*cos(y)"
        Layout.fillWidth: true
        onEditingFinished: functionChanged(text)
    }
    //画分割线
    Rectangle {
        Layout.fillWidth: true
        height: 1
        color: "#cccccc"
    }
    Label {
        text: "3D View Control"
        font.bold: true
        font.pixelSize: 14
    }

    RowLayout {
        Layout.fillWidth: true
        spacing: 10
        Button {
            text: "Zoom +"
            Layout.fillWidth: true
            onClicked: zoomIn()
        }
        Button {
            text: "Zoom -"
            Layout.fillWidth: true
            onClicked: zoomOut()
        }
        Button {
            text: "Reset View"
            Layout.fillWidth: true
            onClicked: resetView()
        }
    }
}