// File: my2dcanvasrenderer.cpp
// Created: suqian2024051604029 3236863614@qq.com      2026-07-16
// Version: 1.0      License: AGPLv3
// Change Log:
//     [v0.1.1] suqian2024051604029 3236863614@qq.com   2026-07-16 02:15:49
//         * 完善了基础的渲染器
//     [v0.1.2]  黄钰琳2024051604104 <389930006@qq.com>   2026-07-16 02:16:06
//         * 完善2d矢量场相关的绘画功能
#include "my2dcanvasrenderer.h"
#include "my2dcanvas.h"
#include <QString>
#include <QtMath>
#include <QColor>
#include <QPointF>
#include <cmath>

//同步数据
void My2DCanvasRenderer::synchronize(QCanvasPainterItem *item)
{
    My2DCanvas *canvas = static_cast<My2DCanvas *>(item);
    if(canvas){
        m_xMin=canvas->xMin();
        m_xMax=canvas->xMax();
        m_yMin=canvas->yMin();
        m_yMax=canvas->yMax();
        m_width=width();
        m_height=height();
        m_multiFunctionData=canvas->multiFunctionData();
        m_vectorFieldData=canvas->vectorFieldData();
        m_showVectorField=canvas->showVectorField();
    }
}

void My2DCanvasRenderer::paint(QCanvasPainter *p)
{
    if(m_width<=0||m_height<=0) return;
    if(m_xMax<=m_xMin||m_yMax<=m_yMin) return;

    // 白色背景
    p->setFillStyle(QColorConstants::White);
    p->fillRect(0, 0, m_width, m_height);

    drawGrid(p);
    drawAxes(p);
    drawScail(p);
    drawMultiFunctions(p);

    // 画矢量场
    if(m_showVectorField && !m_vectorFieldData.isEmpty()){ drawVectorField(p); }

    drawRangeInfo(p);
}

//转化成像素坐标
double My2DCanvasRenderer::toCanvasX(double x) const
{
    return (x-m_xMin)/(m_xMax-m_xMin)*m_width;
}

double My2DCanvasRenderer::toCanvasY(double y) const
{
    return m_height-(y-m_yMin)/(m_yMax-m_yMin)*m_height;
}
//步长
double My2DCanvasRenderer::adjustStepSize(double step) const
{
    if(step <= 0) return 1.0;
    double magnitude = 1.0;
    while(step / magnitude >= 10){
        magnitude *= 10;
    }
    while(step / magnitude < 1){
        magnitude /= 10;
    }
    double ratio = step / magnitude;

    if (ratio<1.5) return magnitude;
    if (ratio<3.5) return 2.0*magnitude;
    if (ratio<7.0) return 5.0*magnitude;
    return 10.0*magnitude;
}

//画网格
void My2DCanvasRenderer::drawGrid(QCanvasPainter *p)
{
    double xRange=m_xMax-m_xMin;
    double yRange=m_yMax-m_yMin;
    if(xRange<=0||yRange <= 0) return;
    double xStep=adjustStepSize(xRange / 10.0);
    double yStep=adjustStepSize(yRange / 10.0);

    p->setLineWidth(1);
    p->setStrokeStyle(QColor(200, 200, 200, 200));

    if(xStep>0){
        double xStart=std::floor(m_xMin/xStep)*xStep;
        int xCount=static_cast<int>(std::floor((m_xMax - xStart)/xStep)) + 1;

        for(int i=0;i<xCount;++i){
            double x=xStart+i*xStep;
            if (x>m_xMax+xStep*0.001) break;
            if (x>-xStep*0.1&&x<xStep*0.1) continue;

            double cx = toCanvasX(x);
            if(cx >= 0 && cx <= m_width){
                p->beginPath();
                p->moveTo(cx, 0);
                p->lineTo(cx, m_height);
                p->stroke();
            }
        }
    }
    if(yStep>0){
        double yStart=std::floor(m_yMin/yStep)*yStep;
        int yCount=static_cast<int>(std::floor((m_yMax-yStart)/yStep)) + 1;

        for(int j=0;j<yCount;++j){
            double y=yStart+j*yStep;
            if (y>m_yMax+yStep*0.001) break;
            if (y>-yStep*0.1&&y<yStep*0.1) continue;
            double cy = toCanvasY(y);
            if(cy >= 0 && cy <= m_height){
                p->beginPath();
                p->moveTo(0, cy);
                p->lineTo(m_width, cy);
                p->stroke();
            }
        }
    }
}

void My2DCanvasRenderer::drawAxes(QCanvasPainter *p)
{
    p->setLineWidth(2);
    p->setStrokeStyle(QColorConstants::Black);

    double y0=toCanvasY(0);
    if(y0>=0&&y0<=m_height){
        p->beginPath();
        p->moveTo(0, y0);
        p->lineTo(m_width, y0);
        p->stroke();
    }

    double x0=toCanvasX(0);
    if(x0>=0&&x0<=m_width){
        p->beginPath();
        p->moveTo(x0, 0);
        p->lineTo(x0, m_height);
        p->stroke();
    }
}

//画刻度
void My2DCanvasRenderer::drawScail(QCanvasPainter *p)
{
    // 计算步长
    double xStep=adjustStepSize((m_xMax-m_xMin)/10.0);
    double yStep=adjustStepSize((m_yMax-m_yMin)/10.0);

    //设置画笔
    p->setStrokeStyle(QColor(50, 50, 50));
    p->setLineWidth(1.5);
    p->setFillStyle(QColor(50, 50, 50));
    p->setFont(QFont("Arial", 10));

    // 获取坐标轴位置
    double x0 = toCanvasX(0);
    double y0 = toCanvasY(0);
    int tickLength = 6;

    //计算起始位置
    double xStart=std::floor(m_xMin/xStep) * xStep;
    double yStart=std::floor(m_yMin/yStep) * yStep;

    //X轴刻度
    if(xStep>0 && y0>=0 && y0<=m_height){
        int xCount=static_cast<int>(std::floor((m_xMax-xStart)/xStep))+1;

        for(int i=0;i<xCount;++i){
            double x=xStart+i*xStep;
            if(x>m_xMax+xStep*0.001) break;

            if(x>-xStep*0.1&&x<xStep*0.1) continue;

            double cx=toCanvasX(x);
            if(cx>=0 && cx<=m_width){
                // 画刻度线
                p->beginPath();
                p->moveTo(cx, y0 - tickLength);
                p->lineTo(cx, y0 + tickLength);
                p->stroke();
                // 画刻度数值
                QString label = QString::number(x, 'g', 3);
                // 居中
                if(x >= 0){ label = " " + label; }
                p->fillText(label, cx - 10, y0 + tickLength + 16);
            }
        }
    }

    // Y轴刻度
    if (yStep>0&&x0>=0&&x0<=m_width) {
        int yCount=static_cast<int>(std::floor((m_yMax - yStart) / yStep)) + 1;

        for(int j= 0;j<yCount;++j){
            double y = yStart+j*yStep;
            if(y>m_yMax + yStep*0.001) break;

            if(y>-yStep*0.1&&y<yStep*0.1) continue;

            double cy = toCanvasY(y);
            if(cy>= 0&& cy<=m_height){
                // 画刻度线
                p->beginPath();
                p->moveTo(x0-tickLength,cy);
                p->lineTo(x0+tickLength,cy);
                p->stroke();

                // 画刻度数值
                QString label = QString::number(y, 'g', 3);
                p->fillText(label, x0 - 25, cy + 4);
            }
        }
    }

    p->fillText("0", x0 + 4, y0 - 4);
}

//画函数曲线
void My2DCanvasRenderer::drawMultiFunctions(QCanvasPainter *p)
{
    if(m_multiFunctionData.isEmpty()) return;

    for(int i=0;i<m_multiFunctionData.size();++i){
        QVariantMap funcData = m_multiFunctionData[i].toMap();
        QList<QVariant> pointsVar = funcData["points"].toList();
        QString color=funcData["color"].toString();
        if (pointsVar.isEmpty()) continue;

        p->setStrokeStyle(QColor(color));
        p->setLineWidth(2);
        p->beginPath();

        bool firstPoint = true;
        int pointCount=pointsVar.size();
        for(int j = 0;j<pointCount; ++j){
            QPointF point = pointsVar[j].toPointF();
            double cx = toCanvasX(point.x());
            double cy = toCanvasY(point.y());
            if(cx>=0 && cx<=m_width && cy>=0 && cy<=m_height){
                if(firstPoint){
                    p->moveTo(cx, cy);
                    firstPoint = false;
                }else{
                    p->lineTo(cx, cy);
                }
            }else{
                firstPoint = true;
            }
        }
        p->stroke();
    }
}

//矢量场绘制
void My2DCanvasRenderer::drawVectorField(QCanvasPainter *p)
{
    if(m_vectorFieldData.isEmpty()) return;

    for(int i = 0; i < m_vectorFieldData.size(); i++){
        QVariantMap vecData = m_vectorFieldData[i].toMap();
        double fromX = vecData["fromX"].toDouble();
        double fromY = vecData["fromY"].toDouble();
        double toX = vecData["toX"].toDouble();
        double toY = vecData["toY"].toDouble();
        QString color = vecData["color"].toString();
        drawArrow(p, fromX, fromY, toX, toY, color);
    }
}

//画箭头函数
void My2DCanvasRenderer::drawArrow(QCanvasPainter *p,double fromX,double fromY,double toX,double toY,const QString &color)
{
    // 坐标转换
    double canvasFromX = toCanvasX(fromX);
    double canvasFromY = toCanvasY(fromY);
    double canvasToX = toCanvasX(toX);
    double canvasToY = toCanvasY(toY);

    if((canvasFromX<0 && canvasToX<0) || (canvasFromX>m_width && canvasToX>m_width)
        || (canvasFromY<0 && canvasToY<0) || (canvasFromY>m_height && canvasToY>m_height)){
        return;
    }

    //计算方向和长度
    double dx = canvasToX-canvasFromX;
    double dy = canvasToY-canvasFromY;
    double length = std::sqrt(dx * dx + dy * dy);

    if(length < 6.0){
        p->setStrokeStyle(QColor(color));
        p->setLineWidth(1.5);
        p->beginPath();
        p->moveTo(canvasFromX, canvasFromY);
        p->lineTo(canvasToX, canvasToY);
        p->stroke();
        return;
    }

    //计算箭头方向
    double angle = std::atan2(dy, dx);
    double arrowSize = 6.0;
    double arrowAngle = M_PI/6.0;

    //计算箭头头的两个翼
    double leftX=canvasToX-arrowSize*std::cos(angle-arrowAngle);
    double leftY=canvasToY-arrowSize*std::sin(angle-arrowAngle);
    double rightX=canvasToX-arrowSize*std::cos(angle+arrowAngle);
    double rightY=canvasToY-arrowSize*std::sin(angle+arrowAngle);

    //画箭杆
    p->setStrokeStyle(QColor(color));
    p->setLineWidth(1.8);
    p->beginPath();
    p->moveTo(canvasFromX, canvasFromY);
    p->lineTo(canvasToX, canvasToY);
    p->stroke();

    p->setLineWidth(1.5);
    // 左
    p->beginPath();
    p->moveTo(canvasToX, canvasToY);
    p->lineTo(leftX, leftY);
    p->stroke();

    // 右
    p->beginPath();
    p->moveTo(canvasToX, canvasToY);
    p->lineTo(rightX, rightY);
    p->stroke();
}

void My2DCanvasRenderer::drawRangeInfo(QCanvasPainter *p)
{
    p->setFont(QFont("Arial", 11));
    p->setFillStyle(QColorConstants::Gray);

    QString info = QString("x: [%1, %2]  y: [%3, %4]")
                       .arg(m_xMin, 0, 'f', 2)
                       .arg(m_xMax, 0, 'f', 2)
                       .arg(m_yMin, 0, 'f', 2)
                       .arg(m_yMax, 0, 'f', 2);

    p->fillText(info, 10, 25);
}