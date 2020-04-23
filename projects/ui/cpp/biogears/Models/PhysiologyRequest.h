#pragma once

#include <QAbstractItemModel>
#include <QString>
#include <QVariant>
#include <QVector>

#include <biogears/cdm/properties/SEScalar.h>
#include <biogears/cdm/properties/SEUnitScalar.h>

class PhysiologyRequest {
public:
  PhysiologyRequest();
  PhysiologyRequest(QString prefix, QString name, bool active = false, PhysiologyRequest* parent = nullptr);
  ~PhysiologyRequest();

  QString name() const;
  void name(const QString&);

  bool active() const;
  void active(bool value);

  int rate() const;
  void rate(int value);

  int nested() const;
  void nested(int value);

  int rows() const;
  int columns() const;

  bool enabled() const;
  void enabled(bool);

  bool custom() const;
  void custom(std::function<double(void)>&& value, std::function<QString(void)>&& unit);

  biogears::SEUnitScalar const * unit_scalar() const;
  void unit_scalar(biogears::SEUnitScalar*);

  biogears::SEScalar const* scalar() const;
  void scalar(biogears::SEScalar*);

  PhysiologyRequest const* parent() const;
  PhysiologyRequest* parent();
  PhysiologyRequest* child(int row);
  PhysiologyRequest const* child(int row) const;

  QString header(int col) const;
  PhysiologyRequest* append(QString prefix, QString name, bool active = false);
  void modify(int row, const biogears::SEUnitScalar* data);
  void modify(int row, const biogears::SEScalar* data);
  void modify(int row, int refreshRate);
  void modify(int row, bool enabled);

  QVariant data(int role) const;

  bool operator==(const PhysiologyRequest& rhs)
  {
    return _name == rhs._name
      && _prefix == rhs._prefix;
  }
  bool operator!=(const PhysiologyRequest& rhs)
  {
    return !(*this == rhs);
  }
  void scalar(biogears::SEScalar const* given)
  {
    _value = given;
    _unit = nullptr;
  };
  void unit_scalar(biogears::SEUnitScalar const* given)
  {
    _unit = given;
    _value = nullptr;
  };

private:
  PhysiologyRequest* _parent = nullptr;

  QVector<PhysiologyRequest> _children;
  QString _prefix;
  QString _name;
  bool _active = false;
  bool _custom = false;
  bool _nested = false;
  int _refresh_rate = 1;
  biogears::SEScalar const* _value = nullptr;
  biogears::SEUnitScalar const* _unit = nullptr;

  std::function<double(void)> _customValueFunc;
  std::function<QString(void)> _customUnitFunc;
};