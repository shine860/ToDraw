#pragma once

#include <QtCanvasPainter>
#include <QCanvasPainterItem>
#include <QtQml/qqmlregistration.h>
#include <QVariant>

class My2DCanvas : public QCanvasPainterItem
{
    Q_OBJECT
    QML_ELEMENT
    Q_PROPERTY(double xMin READ xMin WRITE setXMin NOTIFY rangeChanged)
    Q_PROPERTY(double xMax READ xMax WRITE setXMax NOTIFY rangeChanged)
    Q_PROPERTY(double yMin READ yMin WRITE setYMin NOTIFY rangeChanged)
    Q_PROPERTY(double yMax READ yMax WRITE setYMax NOTIFY rangeChanged)

public:
    explicit My2DCanvas(QQuickItem *parent = nullptr);

    Q_INVOKABLE void zoomIn();
    Q_INVOKABLE void zoomOut();
    Q_INVOKABLE void resetView();

    Q_INVOKABLE void setMultiFunctionData(const QList<QVariant> &functionsData);
    static constexpr double MAX_RANGE = 1000;
    static constexpr double MIN_RANGE = 0.01;

    QList<QVariant> multiFunctionData() const;

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

protected:
    QCanvasPainterItemRenderer *createItemRenderer() const override;

private:
    double m_xMin;
    double m_xMax;
    double m_yMin;
    double m_yMax;
    QList<QVariant> m_multiFunctionData;
};