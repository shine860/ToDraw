import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

ApplicationWindow {
    id: root
    width: 1024
    height: 768
    visible: true
    title: qsTr("画图-ToDraw")
    property string currentTool: "pencil"
    property color currentColor: "#000000"


    // 菜单
    menuBar: MenuBar {
        Menu {
            title: qsTr("&File")
            MenuItem { text: qsTr("&New") }
            MenuItem { text: qsTr("&Open"); onTriggered: console.log("Open action triggered") }
            MenuItem { text: qsTr("Save") }
            MenuItem { text: qsTr("Save as") }
            MenuItem { text: qsTr("&Exit"); onTriggered: Qt.quit() }
        }
        Menu {
            title: qsTr("Edit")
            MenuItem { text: qsTr("Cut") }
            MenuItem { text: qsTr("Copy") }
            MenuItem { text: qsTr("Paste") }
        }
        Menu { title: qsTr("Find") }
        Menu {
            title: qsTr("&Help")
            MenuItem { text: qsTr("about") }
        }
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        // 工具栏
        ToolBar {
            Layout.fillWidth: true
            padding: 4
            spacing: 0

            ColumnLayout {
                anchors.fill: parent
                spacing: 4

                RowLayout {
                    Layout.fillWidth: true
                    spacing: 2

                    ToolButton { icon.name: "document-new"; ToolTip.text: "新建"; ToolTip.visible: hovered }
                    ToolButton { icon.name: "document-save"; ToolTip.text: "保存"; ToolTip.visible: hovered }
                    ToolButton { icon.name: "edit-undo"; ToolTip.text: "撤销"; ToolTip.visible: hovered }
                    ToolButton { icon.name: "edit-redo"; ToolTip.text: "重做"; ToolTip.visible: hovered }
                }
                Rectangle {
                    Layout.fillWidth: true
                    height: 1
                    color: "grey"
                }//画分割线

                RowLayout {
                    Layout.fillWidth: true
                    ColumnLayout{
                        spacing:3
                        ComboBox{
                            displayText:"选择"
                            model:ListModel{
                                ListElement{text:"矩形"}
                                ListElement{text:"自由选区"}
                            }
                        }
                    }
                    ColumnLayout {
                        Layout.alignment: Qt.AlignTop
                        spacing: 2
                        Layout.margins: 4

                        RowLayout {
                            spacing: 1
                            ColumnLayout{
                                ToolButton { text: "铅笔"; font.pixelSize:10}
                                ToolButton { text: "图片"; font.pixelSize: 10}
                            }
                            ColumnLayout{
                                ToolButton { text: "填充"; font.pixelSize: 10 }
                                ToolButton { text: "取色"; font.pixelSize: 10 }
                            }
                            ColumnLayout{
                                ToolButton { text: "A"; ToolTip.text: "文本"; ToolTip.visible: hovered; onClicked: root.currentTool = "text" }
                                ToolButton{
                                    text:"放大";font.pixelSize: 10
                                }
                            }
                        }
                        Label { text: "工具"; font.pixelSize: 10; font.bold: true; Layout.alignment: Qt.AlignHCenter }
                    }

                    ToolSeparator { Layout.fillHeight: true; }
                    ColumnLayout {
                        spacing:3
                        ToolButton{
                            text:"画笔"
                            onClicked:brushMenu.open()
                            Menu {
                                id: brushMenu
                                MenuItem { text: "普通笔" }
                                MenuItem { text: "水彩笔" }
                                MenuItem { text: "马克笔" }
                                MenuItem { text: "毛笔" }
                                MenuItem { text: "铅笔" }
                                MenuItem { text: "蜡笔" }
                            }
                        }
                        Label { text: "画笔"; font.pixelSize: 10; font.bold: true;  Layout.alignment: Qt.AlignHCenter }

                    }

                    ToolSeparator { Layout.fillHeight: true;}

                    ColumnLayout {

                        Label { text: "形状"; font.pixelSize: 10; font.bold: true;  Layout.alignment: Qt.AlignHCenter }
                    }

                    ToolSeparator { Layout.fillHeight: true; }

                    ColumnLayout {
                        SpinBox {
                            from: 1; to: 50
                            value: root.currentWidth
                            onValueModified: root.currentWidth = value
                            implicitHeight: 30
                        }
                        Label { text: "粗细"; font.pixelSize: 10; font.bold: true; Layout.alignment: Qt.AlignHCenter }
                    }

                    ToolSeparator { Layout.fillHeight: true; }
                    //颜色
                    ColumnLayout {


                        RowLayout {
                            spacing: 5
                            Rectangle {
                                width: 30; height: 30; radius: 2
                                color: root.currentColor
                            }

                            GridLayout {
                                columns: 10; rowSpacing: 1; columnSpacing: 1
                                Repeater {
                                    model: ["#000000", "#808080", "#800000", "#808000", "#008000", "#008080", "#000080", "#800080", "#ffffff", "#c0c0c0",
                                        "#ff0000", "#ffff00", "#00ff00", "#00ffff", "#0000ff", "#ff00ff", "#ff8000", "#00ff80", "#8000ff", "#ff0080"]
                                    Rectangle {
                                        width: 14; height: 14
                                        color: modelData

                                        border.width: root.currentColor === modelData ? 2 : 1
                                        TapHandler { onTapped: root.currentColor = modelData }
                                    }
                                }
                            }
                        }
                         Label { text: "颜色"; font.pixelSize: 10; font.bold: true;  Layout.alignment: Qt.AlignHCenter }
                    }
                }
            }
        }


        Rectangle {
            Layout.fillWidth: true
            height: 1
            color: "grey"
        }



        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true

            ScrollView {
                anchors.fill: parent
                anchors.margins: 20

                Rectangle {
                    width: 800
                    height: 600
                    color: "white"
                    border.color: "grey"
                    border.width: 1

                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        onPositionChanged: {
                            statusLabel.text = Math.round(mouse.x) + ", " + Math.round(mouse.y) + " 像素"
                        }
                    }
                }
            }
        }

        Rectangle {
            Layout.fillWidth: true
            height: 25
            color: "grey"

            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: 10
                spacing: 20

                Label {
                    id: statusLabel
                    text: "0, 0 像素"
                    font.pixelSize: 12
                }

                Label {
                    text: "800 x 600 像素"
                    font.pixelSize: 12
                    color: "black"
                }

                Label {
                    text: "100%"
                    font.pixelSize: 12
                    color: "black"
                }
            }
        }
    }
}