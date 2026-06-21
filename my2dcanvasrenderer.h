#pragma once

#include <QCanvasPainterItemRenderer>
#include <QCanvasPainter>
#include <QVariant>

class My2DCanvasRenderer : public QCanvasPainterItemRenderer
{
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
    void drawScail(QCanvasPainter *p);
    void drawMultiFunctions(QCanvasPainter *p);
    void drawRangeInfo(QCanvasPainter *p);

    double m_xMin;
    double m_xMax;
    double m_yMin;
    double m_yMax;
    double m_width;
    double m_height;

    QList<QVariant> m_multiFunctionData;
};