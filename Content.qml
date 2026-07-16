// File: Content.qml
// Created: suqian2024051604029 3236863614@qq.com      2026-07-16
// Version: 1.0      License: AGPLv3
//     [v0.1.2] suqian2024051604029 3236863614@qq.com   2026-07-16 02:00:46
//         * 主要是完善了最开始比较基础的content.qml
// Change Log:
//     [v0.1.1]  黄钰琳2024051604104 <389930006@qq.com>  2026-07-16 02:01:39
//         * 主要是添加了2d函数相关计算函数以及与2d矢量场相关的函数
// Change Log:
//     [v0.1.1] lilin2024051604098，2293779871@qq.com   2026-07-16 02:02:29
//         * 主要是完善了3d的画图功能，因为这里引用了第三方库，矢量场我们暂时确实没有找到办法来画三维场中的箭头
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtGraphs
import QtQuick3D
import QtQuick3D.Helpers
import todraw 1.0
import "calculator.js" as Calc


// 主内容组件：左侧控制面板 + 右侧2D/3D绘图区
Item {
    id: contentRoot
    property alias dialogs: _dialogs
    property alias plotCanvas: plotCanvas//这两个都是为了导出图片
    property alias graphsContainer: graphsContainer

    property int currentGraphMode: 0

    property var function2DList: [""]
    property var color2DList: ["red","blue","green","orange","purple","cyan","brown","pink","grey"]

    property bool needUpdate2D: false
    property bool needUpdateVector: false

    property string function3D: "sin(x)*cos(y)"
    Dialogs { id: _dialogs }

    Timer {
        id: update2DTimer
        interval: 80
        onTriggered: {
            if (needUpdate2D && currentGraphMode === 0) {
                create2DPoints()
                needUpdate2D = false
            }
            if (needUpdateVector && currentGraphMode === 0) {
                create2DVectorField()
                needUpdateVector = false
            }
        }
    }

    ListModel {
        id: function2DListModel
        ListElement { expr: "" }
    }

    // 3D函数的ListModel
    ListModel {
        id: function3DListModel
        ListElement { expr: "sin(x)*cos(y)" }
    }



    //更新所有图形
    function updateGraphs() {
        if(currentGraphMode === 0){
            create2DPoints()
            if (plotCanvas.showVectorField) {
                create2DVectorField()
            }
        }else if(currentGraphMode===1){
            refresh3DView()
        }
    }


    // -------- 3D函数管理 --------

    // 将单变量函数转为3D函数（补上另一个变量）
    // 例如 "sin(x)" → "sin(x)+0*y"

    function autoConvertTo3D(expr){ //保证输入一个变量的函数也可以显示
        if(!expr || expr.trim() === "") return expr;

        var t = expr.trim();
        var hasX = /x/.test(t);
        var hasY = /y/.test(t);

        if(hasX && hasY) return t;
        if(hasX && !hasY){
            return t + "+0*y";
        }
        if(!hasX && hasY){
            return t + "+0*x";
        }
        if(!hasX && !hasY){
            return t + "+0*x+0*y";
        }
        return t;
    }


    // 刷新3D视图：重新加载并传入所有3D函数
    function refresh3DView() {
        graph3DLoader.active = false
        graph3DLoader.active = true

        // 让loader加载完
        var waitAndLoad = function(){
            var view = graph3DLoader.item
            if(!view){
                Qt.callLater(waitAndLoad, 100)
                return
            }
            // 收集所有函数
            var funcs = []
            for(var i=0;i<function3DListModel.count;i++){
                var expr=function3DListModel.get(i).expr
                if (expr&&expr.trim() !== "") {
                    var fixed=autoConvertTo3D(expr.trim())
                    funcs.push(fixed)
                }
            }
            console.log("Functions:", funcs)
            if(funcs.length > 0){
                view.addFunctions(funcs)
            }
        }
        Qt.callLater(waitAndLoad, 150)
    }

    function add3DFunction() {
        function3DListModel.append({"expr": ""})
        console.log("Added new 3D function input, total:", function3DListModel.count)
    }

    function remove3DFunction(index) {
        if(function3DListModel.count<=1) return
        function3DListModel.remove(index)
        refresh3DView()
    }

    function update3DFunction(index, newText) {
        function3DListModel.setProperty(index, "expr", newText)
        refresh3DView()
    }

    function create3DPoints() {
        refresh3DView()
    }
    //布局
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
                        if (currentGraphMode === 0) {
                            create2DPoints()
                            if (plotCanvas.showVectorField) {
                                create2DVectorField()
                            }
                        } else {
                            refresh3DView()
                        }
                    }
                }

                Rectangle {
                    Layout.fillWidth: true
                    height: 1
                    color: "#cccccc"
                }



                //3D模式
                ColumnLayout {
                    visible: currentGraphMode === 1
                    spacing: 10

                    Label {
                        text: "3D Functions"
                        Layout.fillWidth: true
                        horizontalAlignment: Text.AlignHCenter
                        font.bold: true
                        font.pixelSize: 15
                        ToolTip {
                            visible: tooltip3D.hovered
                            text: "支持多个 3D 函数同时显示\n"
                        }
                        HoverHandler { id: tooltip3D }
                    }

                    Button {
                        text: "+ Add 3D Function"
                        Layout.alignment: Qt.AlignLeft
                        onClicked: add3DFunction()
                    }

                    Rectangle {
                        Layout.fillWidth: true
                        height: 1
                        color: "#cccccc"
                    }

                    ScrollView {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 150
                        clip: true

                        ColumnLayout {
                            width: parent.width
                            spacing: 8

                            Repeater {
                                model: function3DListModel
                                RowLayout {
                                    Layout.fillWidth: true
                                    spacing: 8

                                    TextField {
                                        Layout.fillWidth: true
                                        text: model.expr
                                        placeholderText: "eg: sin(x)*cos(y)"
                                        onEditingFinished: {
                                            update3DFunction(index, text)
                                        }
                                    }

                                    Button {
                                        text: "Delete"
                                        onClicked: remove3DFunction(index)
                                        enabled: function3DListModel.count > 1
                                    }
                                }
                            }
                        }
                    }

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
                            onClicked: {
                                if (graph3DLoader.item) {
                                    graph3DLoader.item.zoomIn()
                                }
                            }
                        }
                        Button {
                            text: "Zoom -"
                            Layout.fillWidth: true
                            onClicked: {
                                if (graph3DLoader.item) {
                                    graph3DLoader.item.zoomOut()
                                }
                            }
                        }
                        Button {
                            text: "Reset View"
                            Layout.fillWidth: true
                            onClicked: {
                                if (graph3DLoader.item) {
                                    graph3DLoader.item.resetView()
                                }
                            }
                        }
                    }
                }

                Item { Layout.fillHeight: true }
            }
        }

        //右侧绘图区域
        StackLayout {
            id: graphsContainer
            Layout.fillWidth: true
            Layout.fillHeight: true
            currentIndex: currentGraphMode



            // 3D 视图
            Item {
                id: surface3Dview

                Loader {
                    id: graph3DLoader
                    anchors.fill: parent
                    sourceComponent: graph3DComponent
                }

                Component {
                    id: graph3DComponent
                    Graph3DViewWrapper {
                        id: graph3DWrapper
                        anchors.fill: parent
                        onReady: {
                            var validFunctions = []
                            for (var i = 0; i < function3DListModel.count; i++) {
                                var expr = function3DListModel.get(i).expr
                                if (expr && expr.trim() !== "") {
                                    validFunctions.push(expr.trim())
                                }
                            }
                            if (validFunctions.length > 0) {
                                graph3DWrapper.addFunctions(validFunctions)
                            }
                        }
                    }
                }
            }
        }
    }

    // 组件加载完成时，默认进入2D模式
    Component.onCompleted: {
        currentGraphMode = 0
        create2DPoints()
        console.log("Content.qml loaded")
    }
}