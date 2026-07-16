// File: my2dcanvas.cpp
// Created: suqian2024051604029 3236863614@qq.com      2026-07-16
// Version: 1.0      License: AGPLv3
//     [v0.1.1] suqian2024051604029 3236863614@qq.com   2026-07-16 02:14:30
//         * 完善了基础的2dcanvas部分
// Change Log:
//     [v0.1.2]  黄钰琳2024051604104 <389930006@qq.com>   2026-07-16 02:14:53
//         * 完善了矢量场相关的部分
//     [v0.1.2] lilin2024051604098，2293779871@qq.com    2026-07-16 15:29:12
//         * 有给一些相关改进以及测试意见
#include <QtCanvasPainter>
#include <QCanvasPainterItemRenderer>
#include "my2dcanvas.h"
#include "my2dcanvasrenderer.h"

My2DCanvas::My2DCanvas(QQuickItem *parent)
    : QCanvasPainterItem(parent)
{}

QCanvasPainterItemRenderer *My2DCanvas::createItemRenderer() const
{
    return new My2DCanvasRenderer();
}

void My2DCanvas::setMultiFunctionData(const QVariantList &functionsData)
{
    m_multiFunctionData = functionsData;
    update();
}

QVariantList My2DCanvas::multiFunctionData() const
{
    return m_multiFunctionData;
}

void My2DCanvas::setVectorFieldData(const QVariantList &vectorData)
{
    m_vectorFieldData = vectorData;
    update();
}

QVariantList My2DCanvas::vectorFieldData() const
{
    return m_vectorFieldData;
}
bool My2DCanvas::showVectorField() const
{
    return m_showVectorField;
}

void My2DCanvas::setShowVectorField(bool newShowVectorField)
{
    if (m_showVectorField == newShowVectorField) return;
    m_showVectorField = newShowVectorField;
    emit showVectorFieldChanged();
}

void My2DCanvas::zoomIn()
{
    double cx=(m_xMin + m_xMax) / 2;
    double cy = (m_yMin + m_yMax) / 2;
    double xRange = (m_xMax - m_xMin) * 0.8;
    double yRange = (m_yMax - m_yMin) * 0.8;

    if(xRange < MIN_RANGE || yRange < MIN_RANGE){
        return;
    }

    if(xRange > MAX_RANGE){
        xRange = MAX_RANGE;
    }
    if(yRange > MAX_RANGE){
        yRange = MAX_RANGE;
    }
    setXMin(cx - xRange / 2);
    setXMax(cx + xRange / 2);
    setYMin(cy - yRange / 2);
    setYMax(cy + yRange / 2);
}

void My2DCanvas::zoomOut()
{
    double cx = (m_xMin + m_xMax) / 2;
    double cy = (m_yMin + m_yMax) / 2;
    double xRange = (m_xMax - m_xMin) * 1.25;
    double yRange = (m_yMax - m_yMin) * 1.25;

    if(xRange>MAX_RANGE){
        xRange=MAX_RANGE;
    }
    if (yRange>MAX_RANGE) {
        yRange=MAX_RANGE;
    }

    setXMin(cx-xRange/2);
    setXMax(cx+xRange/2);
    setYMin(cy-yRange/2);
    setYMax(cy+yRange/2);
}

void My2DCanvas::resetView()
{
    setXMin(-5);
    setXMax(5);
    setYMin(-5);
    setYMax(5);
}

double My2DCanvas::xMax() const { return m_xMax; }
void My2DCanvas::setXMax(double newXMax)
{
    if (qFuzzyCompare(m_xMax, newXMax)) return;
    m_xMax = newXMax;
    emit rangeChanged();
    update();
}

double My2DCanvas::xMin() const { return m_xMin; }
void My2DCanvas::setXMin(double newXMin)
{
    if (qFuzzyCompare(m_xMin, newXMin)) return;
    m_xMin = newXMin;
    emit rangeChanged();
    update();
}

double My2DCanvas::yMin() const { return m_yMin; }
void My2DCanvas::setYMin(double newYMin)
{
    if (qFuzzyCompare(m_yMin, newYMin)) return;
    m_yMin = newYMin;
    emit rangeChanged();
    update();
}

double My2DCanvas::yMax() const { return m_yMax; }
void My2DCanvas::setYMax(double newYMax)
{
    if (qFuzzyCompare(m_yMax, newYMax)) return;
    m_yMax = newYMax;
    emit rangeChanged();
    update();
}
