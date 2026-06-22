// File: my2dcanvas.cpp
// Created: suqian2024051604029 3236863614@qq.com      2026-06-22
// Version: 1.0      License: AGPLv3

#include "my2dcanvas.h"
#include "my2dcanvasrenderer.h"

My2DCanvas::My2DCanvas(QQuickItem *parent)
    : QCanvasPainterItem(parent)
{}

QCanvasPainterItemRenderer *My2DCanvas::createItemRenderer() const
{
    return new My2DCanvasRenderer();
}



void My2DCanvas::zoomIn()
{
    double cx = (m_xMin + m_xMax) / 2;
    double cy = (m_yMin + m_yMax) / 2;
    double xRange = (m_xMax - m_xMin) * 0.8;
    double yRange = (m_yMax - m_yMin) * 0.8;

    if (xRange < MIN_RANGE || yRange < MIN_RANGE) {
        return;
    }

    if (xRange > MAX_RANGE) {
        xRange = MAX_RANGE;
    }
    if (yRange > MAX_RANGE) {
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

    if (xRange > MAX_RANGE) {
        xRange = MAX_RANGE;
    }
    if (yRange > MAX_RANGE) {
        yRange = MAX_RANGE;
    }

    setXMin(cx - xRange / 2);
    setXMax(cx + xRange / 2);
    setYMin(cy - yRange / 2);
    setYMax(cy + yRange / 2);
}

void My2DCanvas::resetView()
{
    setXMin(-5);
    setXMax(5);
    setYMin(-5);
    setYMax(5);
}
void My2DCanvas::setMultiFunctionData(const QList<QVariant> &functionsData)
{
    m_multiFunctionData = functionsData;
    update();
}
QList<QVariant> My2DCanvas::multiFunctionData() const
{
    return m_multiFunctionData;
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
