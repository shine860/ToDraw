import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

ColumnLayout {
    id: twoD
    spacing: 10

    property var functionListModel:[""]
    property var color2DList:["red","blue","green","orange","purple","cyan","brown","pink","grey"]

    signal addFunction()
    signal removeFunction(int index)
    signal updateFunction(int index, string newText)
    signal zoomIn()
    signal zoomOut()
    signal resetView()

    Label {
        text: "2D Functions"
        Layout.fillWidth: true
        horizontalAlignment: Text.AlignHCenter
        font.bold: true
        font.pixelSize: 15
        ToolTip {
            visible: tooltip2D.hovered
            text: "每个函数会画一条曲线，颜色不同\n支持: + - * / ^ ( )\n函数: sin, cos, tan, log\n变量: x"
        }
        HoverHandler { id: tooltip2D }
    }


    Button {
        text: "+ Add Function"
        Layout.alignment: Qt.AlignLeft
        onClicked: add2DFunction()
    }

    //画出相应的分割线
    Rectangle {
        Layout.fillWidth: true
        height: 1
        color: "#cccccc"
    }
    //函数列表
    ScrollView {
        Layout.fillWidth: true
        Layout.preferredHeight: 250
        clip: true

        ColumnLayout {
            width: parent.width
            spacing: 8
            Repeater {
                model: functionListModel
                RowLayout {
                    Layout.fillWidth: true
                    spacing: 8
                    Rectangle {
                        width: 20; height: 20; radius: 4
                        color: {
                            if (color2DList && color2DList.length > 0) {
                                return color2DList[index % color2DList.length]
                            }
                        }
                    }
                    TextField {
                        Layout.fillWidth: true
                        text: model.expr
                        placeholderText: "eg: sin(x)"
                        onEditingFinished: {
                            updateFunction(index, text)
                        }
                    }
                    Button {
                        text: "Delete"
                        onClicked: removeFunction(index)
                        enabled: functionListModel.count > 1
                    }
                }
            }
        }
    }
    //画分割线
    Rectangle {
        Layout.fillWidth: true
        height: 1
        color: "#cccccc"
    }

    Label { text: "2D View Control"
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
        Button { text: "Zoom -"
            Layout.fillWidth: true
            onClicked: zoomOut()
        }
        Button {
            text: "Reset View"
            Layout.fillWidth: true
            onClicked: resetView()
        }
    }
    Rectangle {
        Layout.fillWidth: true
        height: 1
        color: "#cccccc"
    }
    Label{

        text:"Show Vector Field"
        font.bold:true
        font.pixelSize: 14
    }

    Button{
        spacing:10
        text:"vector field"
    }
}