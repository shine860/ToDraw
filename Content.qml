// File: Content.qml
// Created: huangyulin2024051604104 389930006@qq.com      2026-06-22
// Version: 1.0      License: AGPLv3
//写了有关于2d部分的content

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtGraphs
import MyModule 1.0
import "calculator.js" as Calc

Item {
    id: contentRoot
    property alias dialogs: _dialogs
    property int currentGraphMode: 0

    property var function2DList: [""]
    property var color2DList: ["red","blue","green","orange","purple","cyan","brown","pink","grey"]

    Dialogs { id: _dialogs }

    property bool needUpdate2D: false
    Timer {
        id: update2DTimer
        interval: 80
        onTriggered: {
            if (needUpdate2D && currentGraphMode === 0) {
                create2DPoints()
                needUpdate2D = false
            }
        }
    }

    ListModel {
        id: function2DListModel
        ListElement { expr: "" }
    }
    //中间面板

    function create2DPoints() {
        var allFunctionsData = []

        for (var j = 0; j < function2DList.length; j++) {
            var expr = function2DList[j]
            if (expr === "") continue

            var points = []
            var numPoints = 2000 //取2000个点
            var xMin = plotCanvas.xMin
            var xMax = plotCanvas.xMax

            for (var i = 0; i <= numPoints; ++i) {
                var t = i / numPoints
                var x = xMin + t * (xMax - xMin)

                try {
                    var y = Calc.calculate(expr.replace(/x/g, "(" + x + ")"))
                    points.push(Qt.point(x, y))

                } catch(e) {
                    //
                }
            }

            if (points.length > 0) {
                allFunctionsData.push({"points": points,
                                        "color": color2DList[j % color2DList.length],
                                        "expr": expr
                                      })
            }
        }
        plotCanvas.setMultiFunctionData(allFunctionsData)
    }
    function updateGraphs() {
        currentGraphMode === 0 ? create2DPoints() : create3DPoints()
    }

    function add2DFunction() {
        function2DList.push("")
        function2DListModel.append({"expr": ""})
        if (currentGraphMode === 0) create2DPoints()
    }

    function remove2DFunction(i) {
        if (function2DList.length <= 1) return
        function2DList.splice(i, 1)
        function2DListModel.remove(i)
        if (currentGraphMode === 0) create2DPoints()
    }

    function update2DFunction(idx, txt) {
        if (txt === "") return
        function2DList[idx] = txt
        function2DListModel.setProperty(idx, "expr", txt)
        if (currentGraphMode === 0) create2DPoints()
    }
    RowLayout {
        anchors.fill: parent

        // 左侧控制面板
        Rectangle {
            id: features
            Layout.preferredWidth: parent.width / 4
            Layout.fillHeight: true

            color: "white"
            border.color: "grey"
            border.width: 1

            ColumnLayout {
                anchors.fill: parent
                spacing: 15
                anchors.margins: 10

                // 模式选择
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
                        updateGraphs()
                    }
                }
                //话分割线
                Rectangle {
                    Layout.fillWidth: true
                    height: 1
                    color: "#cccccc"
                }

                // 2D 面板
                Panel2D {
                    visible: currentGraphMode === 0
                    Layout.fillWidth: true
                    functionListModel: function2DListModel
                    color2DList: contentRoot.color2DList
                    onAddFunction: add2DFunction()
                    onRemoveFunction: function(index){
                        remove2DFunction(index)
                    }
                    onUpdateFunction: function(index,newText){
                        update2DFunction(index, newText)
                    }
                    onZoomIn: {
                        plotCanvas.zoomIn()
                        needUpdate2D = true
                        update2DTimer.start()
                    }
                    onZoomOut: {
                        plotCanvas.zoomOut()
                        needUpdate2D = true
                        update2DTimer.start()
                    }
                    onResetView: {
                        plotCanvas.resetView()
                        needUpdate2D = true
                        update2DTimer.start()
                    }
                }
                //让空间靠顶部排列，把剩余空间留到底部
                Item { Layout.fillHeight: true }
            }
        }

        // 右侧绘图区域
        StackLayout {
            id: graphsContainer
            Layout.fillWidth: true
            Layout.fillHeight: true
            currentIndex: currentGraphMode

            // 2D 视图
            Item {
                My2DCanvas {
                    id: plotCanvas
                    anchors.fill: parent
                    xMin: -5; xMax: 5; yMin: -5; yMax: 5
                    onXMinChanged: {
                        if (currentGraphMode === 0) {
                            needUpdate2D = true
                            update2DTimer.start() }
                    }
                    onXMaxChanged: {
                        if (currentGraphMode === 0) {
                            needUpdate2D = true
                            update2DTimer.start() } }
                    onYMinChanged: {
                        if (currentGraphMode === 0) {
                            needUpdate2D = true
                            update2DTimer.start() }
                    }
                    onYMaxChanged: {
                        if (currentGraphMode === 0) {
                            needUpdate2D = true
                            update2DTimer.start() }
                    }
                }
                WheelHandler {
                    id:wheehlandler
                    acceptedDevices: PointerDevice.Mouse | PointerDevice.TouchPad
                    onWheel: (event) => {
                                 if (event.angleDelta.y > 0){

                                     plotCanvas.zoomIn()
                                 }
                                 else{

                                     plotCanvas.zoomOut()
                                 }
                                 needUpdate2D = true
                                 update2DTimer.start()
                             }
                }
            }


    Component.onCompleted: updateGraphs()
}