//-------------------------------------------------------------------------------------------
//- Copyright 2018 Applied Research Associates, Inc.
//- Licensed under the Apache License, Version 2.0 (the "License"); you may not use
//- this file except in compliance with the License. You may obtain a copy of the License
//- at:
//- http://www.apache.org/licenses/LICENSE-2.0
//- Unless required by applicable law or agreed to in writing, software distributed under
//- the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
//- CONDITIONS OF ANY KIND, either express or implied. See the License for the
//-  specific language governing permissions and limitations under the License.
//-------------------------------------------------------------------------------------------

//!
//! \author Steven A White
//! \date   August 21st 2018
//!
//!
//! \brief Primary window of BioGears UI

#include "ScenarioToolbar.h"
//External Includes
#include <QtWidgets>

namespace biogears_ui {

struct ScenarioToolbar::Implementation : public QObject {

public:
  Implementation(QWidget* parent);
  Implementation(const Implementation&);
  Implementation(Implementation&&);

  Implementation& operator=(const Implementation&);
  Implementation& operator=(Implementation&&);

public:
  QComboBox* patients;
  QComboBox* enviroments;
  QComboBox* timelines;
};
//-------------------------------------------------------------------------------
ScenarioToolbar::Implementation::Implementation(QWidget* parent)
  : patients(new QComboBox(parent))
  , enviroments(new QComboBox(parent))
  , timelines(new QComboBox(parent))

{
  //Toolbar Patient
  patients->addItem(tr("Select a Patient"));
  patients->addItem(tr("New Patient"));
  patients->addItem(tr("Austin Baird"));
  patients->addItem(tr("Nathan Tatum"));
  patients->addItem(tr("Load patient from file..."));
  //Toolbar Enviroments
  enviroments->addItem(tr("Select an Environment"));
  enviroments->addItem(tr("New Environment"));
  enviroments->addItem(tr("desert"));
  enviroments->addItem(tr("jungle"));
  enviroments->addItem(tr("Load environment from file..."));
  //Toolbar timelines
  timelines->addItem(tr("New Timeline"));
  timelines->addItem(tr("Select a Timeline"));
  timelines->addItem(tr("Pool exercise"));
  timelines->addItem(tr("Mardi Gras Asthma Attack"));
  timelines->addItem(tr("Load timeline from file..."));
}
//-------------------------------------------------------------------------------
ScenarioToolbar::Implementation::Implementation(const Implementation& obj)

{
  *this = obj;
}
//-------------------------------------------------------------------------------
ScenarioToolbar::Implementation::Implementation(Implementation&& obj)
{
  *this = std::move(obj);
}
//-------------------------------------------------------------------------------
ScenarioToolbar::Implementation& ScenarioToolbar::Implementation::operator=(const Implementation& rhs)
{
  if (this != &rhs) {
  }
  return *this;
}
//-------------------------------------------------------------------------------
ScenarioToolbar::Implementation& ScenarioToolbar::Implementation::operator=(Implementation&& rhs)
{
  if (this != &rhs) {
  }
  return *this;
}
//-------------------------------------------------------------------------------
ScenarioToolbar::ScenarioToolbar(QWidget* parent)
  : QToolBar(tr("Simulation"),parent)
  , _impl(this)
{
  addWidget(_impl->patients);
  addSeparator();
  addWidget(_impl->enviroments);
  addSeparator();
  addWidget(_impl->timelines);
  addSeparator();

  QIcon launchIcon = QIcon::fromTheme("Launch", QIcon(":/img/play.png"));
  QAction* action = new QAction(launchIcon, tr("&Launch"), this);
  action->setStatusTip(tr("Run current simulation"));
  addAction(action);
 
  QIcon pauseIcon = QIcon::fromTheme("Pause", QIcon(":/img/pause.png"));
  action = new QAction(pauseIcon, tr("&Pause"), this);
  action->setStatusTip(tr("Pause running simulation"));
  addAction(action);

  connect(_impl->patients, QOverload<int>::of(&QComboBox::activated), this, &ScenarioToolbar::patientChanged);
  connect(_impl->enviroments, QOverload<int>::of(&QComboBox::activated), this, &ScenarioToolbar::envonmentChanged);
  connect(_impl->timelines, QOverload<int>::of(&QComboBox::activated), this, &ScenarioToolbar::timelineChanged);
}
//-------------------------------------------------------------------------------
ScenarioToolbar::~ScenarioToolbar()
{
  _impl = nullptr;
}
//-------------------------------------------------------------------------------
int ScenarioToolbar::patientListSize() { return _impl->patients->count(); }
//-------------------------------------------------------------------------------
int ScenarioToolbar::envrionmentListSize() { return _impl->enviroments->count(); }
//-------------------------------------------------------------------------------
int ScenarioToolbar::timelineListSize() { return _impl->timelines->count(); }
//-------------------------------------------------------------------------------
//!
//! \brief returns a ScenarioToolbar* which it retains no ownership of
//!        the caller is responsible for all memory management

auto ScenarioToolbar::create(QWidget* parent) -> ScenarioToolbarPtr
{
  return new ScenarioToolbar(parent);
}
}