// File: my2dcanvas.h
// Created: suqian2024051604029 3236863614@qq.com      2026-07-16
// Version: 1.0      License: AGPLv3
// [v0.1.2] suqian2024051604029 3236863614@qq.com   2026-07-16 01:41:01
//         * 完成了最基础版本的2d状态栏的功能和一些基础数据的展示（实际上直接使用的重构功能,同时添加了表格的约束范围
// Change Log:
//     [v0.1.1]  黄钰琳2024051604104 <389930006@qq.com>   2026-07-16 01:47:21
//         * 主要是添加和完善了2d绘制矢量场的功能，有相关的数据和信号
#include <QtCanvasPainter>
#include <QCanvasPainterItem>
#include <QtQml/qqmlregistration.h>
#include <QVector>
#include <QPointF>
#include <QVariantList>

class My2DCanvas : public QCanvasPainterItem
{
    Q_OBJECT
    QML_ELEMENT
    Q_PROPERTY(double xMin READ xMin WRITE setXMin NOTIFY rangeChanged)
    Q_PROPERTY(double xMax READ xMax WRITE setXMax NOTIFY rangeChanged)
    Q_PROPERTY(double yMin READ yMin WRITE setYMin NOTIFY rangeChanged)
    Q_PROPERTY(double yMax READ yMax WRITE setYMax NOTIFY rangeChanged)
    Q_PROPERTY(bool showVectorField READ showVectorField WRITE setShowVectorField NOTIFY showVectorFieldChanged)

public:
    explicit My2DCanvas(QQuickItem *parent = nullptr);
    static constexpr double MAX_RANGE = 1000;
    static constexpr double MIN_RANGE = 0.01;
    Q_INVOKABLE void zoomIn();
    Q_INVOKABLE void zoomOut();
    Q_INVOKABLE void resetView();

    Q_INVOKABLE void setMultiFunctionData(const QVariantList &functionsData);
    QVariantList multiFunctionData() const;

    Q_INVOKABLE void setVectorFieldData(const QVariantList &vectorData);
    QVariantList vectorFieldData() const;
    bool showVectorField() const;
    void setShowVectorField(bool newShowVectorField);

    double xMax() const;
    void setXMax(double newXMax);
    double xMin() const;
    void setXMin(double newXMin);
    double yMin() const;
    void setYMin(double newYMin);
    double yMax() const;
    void setYMax(double newYMax);


signals:
    void rangeChanged();

    void showVectorFieldChanged();

protected:
    QCanvasPainterItemRenderer *createItemRenderer() const override;

private:
    double m_xMin;
    double m_xMax;
    double m_yMin;
    double m_yMax;
    QVariantList m_multiFunctionData;
    QVariantList m_vectorFieldData;
    bool m_showVectorField = false;
};