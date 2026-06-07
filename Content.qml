// content.qml
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtGraphs
import QtQuick3D
import QtQuick3D.Helpers
import MyModule 1.0

Item {
    id: contentRoot
    property alias dialogs: _dialogs
    property int currentGraphMode: 0
    property var functionList: [""]

    Dialogs{
        id:_dialogs
    }

    // 函数列表操作
    function addFunctionRow(initialText = "") {
        functionList = [...functionList, initialText]
    }

    function removeFunctionRow(index) {
        if (functionList.length <= 1) return
        let newList = []
        for (let i = 0; i < functionList.length; i++) {
            if (i !== index) newList.push(functionList[i])
        }
        functionList = newList
    }

    function updateFunctionRow(index, newText) {
        let newList = []
        for (let i = 0; i < functionList.length; i++) {
            newList.push(i === index ? newText : functionList[i])
        }
        functionList = newList
    }

    // 左侧控制面板
    Rectangle {
        id: features
        width: parent.width / 4
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        color: "#ffffff"
        border.color: "grey"
        border.width: 1

        ColumnLayout {
            anchors.fill: parent
            spacing: 15
            anchors.margins: 10

            ComboBox {
                id: graphTypes
                currentIndex: 0
                Layout.preferredHeight: 35
                Layout.fillWidth: true

                model: ListModel {
                    ListElement { text: "2D Module" }
                    ListElement { text: "3D Module" }
                }

                onCurrentIndexChanged: {
                    currentGraphMode = currentIndex
                }
            }

            Rectangle {
                Layout.fillWidth: true
                height: 1
                color: "#cccccc"
            }

            ColumnLayout {
                Layout.fillWidth: true
                spacing: 10

                Label {
                    text: "Function"
                    Layout.fillWidth: true
                    horizontalAlignment: Text.AlignHCenter
                    font.bold: true
                    font.pixelSize: 15

                    ToolTip {
                        visible: tooltip.hovered
                        text: "Supported operators: '+', '-', '*', '/', '%', '^'.\nSupported functions: 'sin', 'cos', 'tan', 'log', 'exp', 'sqrt'.\nx and y are the only supported arguments."
                    }
                    HoverHandler { id: tooltip }
                }

                Button {
                    text: "+ addFunction"
                    Layout.alignment: Qt.AlignLeft
                    onClicked: addFunctionRow("")
                }

                Rectangle {
                    Layout.fillWidth: true
                    height: 1
                    color: "#cccccc"
                }

                Repeater {
                    model: functionList

                    RowLayout {
                        Layout.fillWidth: true
                        spacing: 8

                        TextField {
                            Layout.fillWidth: true
                            text: modelData
                            placeholderText: "input function"
                            onEditingFinished: {
                                updateFunctionRow(index, text)
                                // if (currentGraphMode === 0 && index === 0) {
                                //     // plotCanvas.setFunction(text)
                                // }
                            }
                        }

                        Button {
                            text: "delete"
                            onClicked: removeFunctionRow(index)
                        }
                    }
                }
            }

            // 2D 模式控制
            ColumnLayout {
                visible: currentGraphMode === 0
                spacing: 10

                Rectangle {
                    Layout.fillWidth: true
                    height: 1
                    color: "#cccccc"
                }

                Label { text: "2D view control"; font.bold: true; font.pixelSize: 14 }

                RowLayout {
                    Layout.fillWidth: true
                    spacing: 10
                    Button { text: "Big +"; Layout.fillWidth: true; onClicked: plotCanvas.zoomIn() }
                    Button { text: "Small -"; Layout.fillWidth: true; onClicked: plotCanvas.zoomOut() }
                    Button { text: "reset"; Layout.fillWidth: true; onClicked: plotCanvas.resetView() }
                }
            }

            // 3D 模式控制
            ColumnLayout {
                visible: currentGraphMode === 1
                spacing: 10

                Rectangle {
                    Layout.fillWidth: true
                    height: 1
                    color: "#cccccc"
                }

                Label { text: "3D view Module"; font.bold: true; font.pixelSize: 14 }

                RowLayout {
                    Layout.fillWidth: true
                    spacing: 10
                    Button {
                        text: "Big +"
                        Layout.fillWidth: true
                        onClicked: {
                            surfaceGraph.cameraZoomLevel += 10
                            if (surfaceGraph.cameraZoomLevel > 200) surfaceGraph.cameraZoomLevel = 200
                        }
                    }
                    Button {
                        text: "small -"
                        Layout.fillWidth: true
                        onClicked: {
                            surfaceGraph.cameraZoomLevel -= 10
                            if (surfaceGraph.cameraZoomLevel < 10) surfaceGraph.cameraZoomLevel = 10
                        }
                    }
                    Button {
                        text: "reset"
                        Layout.fillWidth: true
                        onClicked: {
                            surfaceGraph.cameraXRotation = 30
                            surfaceGraph.cameraYRotation = 45
                            surfaceGraph.cameraZoomLevel = 80
                        }
                    }
                }
            }

            Item {
                Layout.fillHeight: true
            }
        }
    }

    // 右侧绘图区域
    StackLayout {
        id: graphsContainer
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        anchors.left: features.right
        currentIndex: currentGraphMode

        // 2D 视图
        Item{
            My2DCanvas {
                id: plotCanvas
                anchors.fill: parent
                xMin: -5
                xMax: 5
                yMin: -5
                yMax: 5
            }
        }
        // 3D 视图
        Item{
            id:surface3Dview

            Surface3D {
                id: surfaceGraph
                anchors.fill: parent
                shadowQuality: Graphs3D.ShadowQuality.None
                msaaSamples: 8
                cameraZoomLevel: 80

                axisX.min: -5
                axisX.max: 5
                axisX.labelFormat: "%.1f"
                axisX.segmentCount: 10

                axisZ.min: -5
                axisZ.max: 5
                axisZ.labelFormat: "%.1f"
                axisZ.segmentCount: 10

                axisY.min: -5
                axisY.max: 5
                axisY.labelFormat: "%.1f"
                axisY.segmentCount: 10

                theme: GraphsTheme {
                    colorStyle: GraphsTheme.ColorStyle.RangeGradient
                    plotAreaBackgroundVisible: false
                }

                rotationEnabled: true
                zoomEnabled: true

                Component.onCompleted: {
                    cameraXRotation = 30
                    cameraYRotation = 45
                }
            }
        }
    }

    // 滚轮控制
    WheelHandler {
        id: wheelHandler
        acceptedDevices: PointerDevice.Mouse | PointerDevice.TouchPad
        enabled: currentGraphMode === 0
        onWheel: (event) => {
                     if (event.angleDelta.y > 0) {
                         plotCanvas.zoomIn()
                     } else {
                         plotCanvas.zoomOut()
                     }
                 }
    }
}

