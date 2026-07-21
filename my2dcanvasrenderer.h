// File: my2dcanvasrenderer.h
// Created: suqian2024051604029 3236863614@qq.com      2026-07-16
// Version: 1.0      License: AGPLv3
//     [v0.1.2] suqian2024051604029 3236863614@qq.com   2026-07-16 01:53:05
//         * 完成了最基础的表格的相关绘制以及刻度等功能
// Change Log:
//     [v0.1.1]  黄钰琳2024051604104 <389930006@qq.com>   2026-07-16 01:54:12
//         * 完成了矢量场的相关绘制以及箭头函数这些程序
#pragma once

#include <QCanvasPainterItemRenderer>
#include <QCanvasPainter>
#include <QVector>
#include <QVariantList>

class My2DCanvasRenderer : public QCanvasPainterItemRenderer
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
    void drawScail(QCanvasPainter *p);
    void drawMultiFunctions(QCanvasPainter *p);
    void drawVectorField(QCanvasPainter *p);
    void drawArrow(QCanvasPainter *p, double fromX, double fromY,double toX, double toY, const QString &color);
    void drawRangeInfo(QCanvasPainter *p);

    double m_xMin;
    double m_xMax;
    double m_yMin;
    double m_yMax;
    double m_width;
    double m_height;
    bool m_showVectorField;

    QVariantList m_multiFunctionData;
    QVariantList m_vectorFieldData;
};