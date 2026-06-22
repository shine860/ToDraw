// File: Content.qml
// Created: suqian2024051604029 3236863614@qq.com      2026-06-22
// Version: 1.0      License: AGPLv3
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtGraphs
import QtQuick3D
import QtQuick3D.Helpers
import MyModule 1.0
import "calculator.js" as Calc

Item {
    id: contentRoot
    property alias dialogs: _dialogs
    property int currentGraphMode: 0

    property var function2DList: [""]
    property var color2DList: ["red","blue","green","orange","purple","cyan","brown","pink","grey"]
    property string function3D: "sin(x)*cos(y)"

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
    //存储所有3D数据点
    ListModel {
        id: surfaceDataModel
    }

    ListModel {
        id: function2DListModel
        ListElement { expr: "" }
    }
    //中间面板


    function create3DPoints() {
        if (!function3D || function3D === "") return
        surfaceDataModel.clear()
        var expr = function3D
        for (var i = 0; i <= 50; i++) {
            var x = -5 + (i / 50) * 10
            for (var j = 0; j <= 50; j++) {
                var z = -5 + (j / 50) * 10
                try {
                    var filled = expr.replace(/x/g, "(" + x + ")").replace(/y/g, "(" + z + ")")
                    var y = Calc.calculate(filled)
                    surfaceDataModel.append({"x": x, "y": y, "z": z})
                } catch(e) {
                    console.log("3D calc error:", e.toString())
                }
            }
        }
    }

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

                // 3D 面板
                Panel3D {
                    visible: currentGraphMode === 1
                    Layout.fillWidth: true
                    functionText: function3D
                    onFunctionChanged:function(newInput) {
                        function3D = newInput
                        create3DPoints()
                    }
                    onZoomIn: {
                        surfaceGraph.cameraZoomLevel+=10
                    }
                    onZoomOut: {
                        surfaceGraph.cameraZoomLevel -=10
                    }
                    onResetView: {
                        surfaceGraph.cameraXRotation = 30
                        surfaceGraph.cameraYRotation = 45
                        surfaceGraph.cameraZoomLevel = 80
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

            // 3D 视图
            Item {
                id:surface3Dview
                Surface3D {
                    id: surfaceGraph
                    anchors.fill: parent
                    shadowQuality: Graphs3D.ShadowQuality.None //禁止使用阴影,提高性能
                    msaaSamples: 8 //用于消除图形边缘的锯齿,值越大，图形边缘越平滑
                    cameraZoomLevel: 80//当前相机的缩放级别

                    maxCameraZoomLevel:200
                    minCameraZoomLevel: 10
                    axisX {
                        min: -5
                        max: 5
                        segmentCount: 10
                    }
                    axisZ {
                        min: -5
                        max: 5
                        segmentCount: 10
                    }
                    axisY {
                        min: -5
                        max: 5
                        segmentCount: 10
                    }
                    theme: GraphsTheme {
                        colorStyle: GraphsTheme.ColorStyle.RangeGradient
                        plotAreaBackgroundVisible: false
                    }
                    rotationEnabled: true
                    zoomEnabled: true
                    Surface3DSeries {
                        id:surfaceSeries
                        ItemModelSurfaceDataProxy {
                            id:surfaceProxy
                            itemModel: surfaceDataModel
                            columnRole: "x"
                            yPosRole: "y"
                            rowRole: "z"
                        }
                    }
                    Component.onCompleted: {
                        cameraXRotation = 30
                        cameraYRotation = 45
                        create3DPoints()
                    }
                }
            }
        }
    }


    Component.onCompleted: updateGraphs()
}