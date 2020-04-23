#pragma once

#include <memory>

#include <QAbstractItemModel>
#include <QObject>
#include <QString>
#include <QVariant>

#include "Models/PhysiologyRequest.h"
#include "biogears/engine/Controller/BioGearsSubstances.h"

class BioGearsData : public QAbstractItemModel {
  Q_OBJECT

public:
  enum Categories {
    VITALS = 0,
    CARDIOPULMONARY,
    BLOOD_CHEMISTRY,
    ENERGY_AND_METABOLISM,
    RENAL_FLUID_BALANCE,
    SUBSTANCES,
    CUSTOM,
    TOTAL_CATEGORIES
  };
  Q_ENUMS(Categories)
  enum PhysiologyRequestRoles {
    PrefixRole = Qt::UserRole + 1,
    RequestRole,
    ValueRole,
    UnitRole,
    FullNameRole,
    EnabledRole,
    CustomRole,
    RateRole,
    RowRole,
    NestedRole,
    ChildrenRole,
    ColumnRole
  };
  Q_ENUMS(PhysiologyRequestRoles)

  explicit BioGearsData();
  explicit BioGearsData(QString name, QObject* parent);
  explicit BioGearsData(QString name, BioGearsData* parent);
  ~BioGearsData() override;

  void initialize();
  void initialize_substances(const biogears::BioGearsSubstances&)
  {
  }

  Q_INVOKABLE int categories();
  Q_INVOKABLE BioGearsData* category(int category);

  Q_INVOKABLE QVariant data(int role) const;
  Q_INVOKABLE QVariant data(const QModelIndex& index, int role) const override;
  bool setData(const QModelIndex& index, const QVariant& value, int role = Qt::EditRole);
  Qt::ItemFlags flags(const QModelIndex& index) const override;
  QVariant headerData(int section, Qt::Orientation orientation, int role = Qt::DisplayRole) const override;
  QModelIndex index(int row, int column, const QModelIndex& parent = QModelIndex()) const override;
  QModelIndex parent(const QModelIndex& index) const override;
  int rowCount(const QModelIndex& parent = QModelIndex()) const override;
  int columnCount(const QModelIndex& parent = QModelIndex()) const override;

  QModelIndex index(QAbstractItemModel const* model) const;

  QHash<int, QByteArray> roleNames() const
  {
    QHash<int, QByteArray> roles;
    roles[Qt::DisplayRole] = "name";
    roles[PrefixRole] = "prefix";
    roles[RequestRole] = "request";
    roles[ValueRole] = "value";
    roles[UnitRole] = "unit";
    roles[FullNameRole] = "fullname";
    roles[EnabledRole] = "active";
    roles[CustomRole] = "custom";
    roles[RateRole] = "rate";
    roles[RowRole] = "rows";
    roles[NestedRole] = "nested";
    roles[ChildrenRole] = "rows";
    roles[ColumnRole] = "columns";
    return roles;
  }

  PhysiologyRequest* append(QString prefix, QString name);
  PhysiologyRequest const* child(int row) const;
  PhysiologyRequest* child(int row);

private:
  QString _name;

  BioGearsData* _rootModel = nullptr;
  PhysiologyRequest _rootRequest;

  BioGearsData* _vitals = nullptr;
  BioGearsData* _cardiopulmonary = nullptr;
  BioGearsData* _blood_chemistry = nullptr;
  BioGearsData* _energy_and_metabolism = nullptr;
  BioGearsData* _renal_fluid_balance = nullptr;
  BioGearsData* _substances = nullptr;
  BioGearsData* _customs = nullptr;

  Q_PROPERTY ( QString name MEMBER _name CONSTANT)
};