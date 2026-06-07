#pragma once

#include <QCanvasPainterItemRenderer>
#include <QCanvasPainter>

class My2DCanvasRenderer:public QCanvasPainterItemRenderer
{

    QML_ELEMENT
public:
    My2DCanvasRenderer() = default;
    void synchronize(QCanvasPainterItem *item) override;
    void paint(QCanvasPainter *p) override;

private:
    double toCanvasX(double x) const;
    double toCanvasY(double y) const;
    double adjustStepSize(double step) const;
    void drawGrid(QCanvasPainter *p);
    void drawAxes(QCanvasPainter *p);
    void drawRangeInfo(QCanvasPainter *p);
    double m_xMin;
    double m_xMax;
    double m_yMin;
    double m_yMax;
    double m_width;
    double m_height;
};
