#pragma once
#include <functional>
#include <map>
#include <memory>
#include <vector>

#include <QFileDialog>
#include <QMessageBox>
#include <QString>
#include <QVariant>
#include <QtQuick>

#include <dirent.h>

#include <biogears/cdm/Serializer.h>
#include <biogears/cdm/scenario/SEAction.h>
#include <biogears/cdm/scenario/SEScenario.h>
#include <biogears/container/concurrent_queue.h>
#include <biogears/engine/BioGearsPhysiologyEngine.h>
#include <biogears/engine/Controller/BioGearsEngine.h>
#include <biogears/framework/scmp/scmp_channel.h>
#include <biogears/threading/runnable.h>
#include <biogears/threading/steppable.h>

#include "BioGearsData.h"
#include "EventTree.h"
#include "Logger.h"
#include "PatientConditions.h"
#include "PatientMetrics.h"
#include "PatientState.h"
#include "Urinalysis.h"
#include "Models/DataRequestTree.h"

namespace biogears {
class SEScalar;
class SEUnitScalar;
class SESubstance;
class SESubstanceCompound;
class SEUrinalysis;
class SEComprehensiveMetabolicPanel;
}

namespace bgui {

class Scenario : public QObject, public biogears::Runnable {

  Q_OBJECT
  Q_PROPERTY(double time_s READ get_simulation_time NOTIFY timeAdvance)
  Q_PROPERTY(double isRunning READ is_running NOTIFY runningToggled)
  Q_PROPERTY(double isPaused READ is_paused NOTIFY pausedToggled)
  Q_PROPERTY(double isThrottled READ is_throttled NOTIFY throttledToggled)

  Q_PROPERTY(QtLogForward* feeds READ getLogForward NOTIFY loggerChanged)
public:
  Scenario(QObject* parent = Q_NULLPTR);
  Scenario(QString name, QObject* parent = Q_NULLPTR);
  virtual ~Scenario();

  using ActionQueue = biogears::ConcurrentQueue<std::unique_ptr<biogears::SEAction>>;
  using ActionChannel = biogears::scmp::Channel<ActionQueue>;
  using ActionSource = biogears::scmp::Source<ActionQueue>;

  using AssessmentQueue = biogears::ConcurrentQueue<biogears::SEPatientAssessment*>;
  using AssessmentChannel = biogears::scmp::Channel<AssessmentQueue>;
  using AssessmentSource = biogears::scmp::Source<AssessmentQueue>;

  Q_INVOKABLE QString patient_name();
  Q_INVOKABLE QString environment_name();

  Q_INVOKABLE Scenario& patient_name(QString);
  Q_INVOKABLE Scenario& environment_name(QString);

  //Load, new, and save functions
  Q_INVOKABLE void create_compound(QVariantMap compoundData);
  Q_INVOKABLE QVariantMap edit_compound();
  Q_INVOKABLE void export_compound();
  Q_INVOKABLE void create_environment(QVariantMap environmentData);
  Q_INVOKABLE QVariantMap edit_environment();
  Q_INVOKABLE void export_environment();
  Q_INVOKABLE QVariantMap load_environment_action(QString enviroActionName);
  Q_INVOKABLE void create_nutrition(QVariantMap nutrition);
  Q_INVOKABLE QVariantMap edit_nutrition();
  Q_INVOKABLE void export_nutrition();
  Q_INVOKABLE QVariantMap load_nutrition_for_meal(QString nutritionName); //Load existing nutrion file into ConsumeMeal action dialog
  Q_INVOKABLE void create_patient(QVariantMap patient); //Create and save a new patient
  Q_INVOKABLE QVariantMap edit_patient();
  Q_INVOKABLE void export_patient(); //Export current patient (uses save_patient)
  Q_INVOKABLE Scenario& load_patient(QString);
  Q_INVOKABLE bool create_scenario(EventTree* events, QVariantList requests, QString sampling);
  Q_INVOKABLE void edit_scenario();
  Q_INVOKABLE bool load_scenario();
  Q_INVOKABLE void create_substance(QVariantMap substanceData);
  Q_INVOKABLE QVariantMap edit_substance();
  Q_INVOKABLE void export_substance();
  Q_INVOKABLE void export_state(bool saveAs);
  Q_INVOKABLE void save_plots(QString location, QString name);
  Q_INVOKABLE void load_state();

  Q_INVOKABLE double get_simulation_time();

  Q_INVOKABLE void restart(QString patient_file);
  Q_INVOKABLE bool pause_play();
  Q_INVOKABLE void speed_toggle(int speed);
  Q_INVOKABLE void run() final;
  Q_INVOKABLE void stop() final;
  Q_INVOKABLE void join() final;
  Q_INVOKABLE void step();

  Q_INVOKABLE QVariantList get_drugs();
  Q_INVOKABLE QVariantList get_volatile_drugs();
  Q_INVOKABLE QVariantList get_compounds();
  Q_INVOKABLE QVariantList get_transfusion_products();
  Q_INVOKABLE QVariantList get_components();
  Q_INVOKABLE QVariantList get_nutrition();

  Q_INVOKABLE QtLogForward* getLogForward();

  bool is_running() const;
  bool is_paused() const;
  bool is_throttled() const;

public: //Action Factory Interface;
  Q_INVOKABLE void create_hemorrhage_action(QString compartment, double ml_Per_min);

  Q_INVOKABLE void create_ards_action(double severity);
  Q_INVOKABLE void create_asthma_action(double severity);
  Q_INVOKABLE void create_consume_meal_action(QString mealName, double carbs_g, double fat_g, double protein_g, double sodium_mg, double calcium_mg, double water_mL);
  Q_INVOKABLE void create_environment_action(QString enviroName, int surroundingType, double airDensity_kg_Per_m3, double airVelocity_m_Per_s, double ambientTemperature_C, double atmpshpericPressure_Pa, double clothingResistance_clo, double emissivity, double meanRadiantTemperature_C, double relativeHumidity, double respirationAmbientTemperature_C, double gasFractionO2, double gasFractionCO2, double gasFractionCO, double gasFractionN2, double concentrationSarin, double concentrationFireParticulate);
  Q_INVOKABLE void create_substance_bolus_action(QString substance, int route, double dose_mL, double concentration_ug_Per_mL);
  Q_INVOKABLE void create_substance_oral_action(QString substance, int route, double dose_mg);
  Q_INVOKABLE void create_substance_infusion_action(QString substance, double concentration_ug_Per_mL, double rate_mL_Per_min);
  Q_INVOKABLE void create_substance_compound_infusion_action(QString compound, double bagVolume_mL, double rate_mL_Per_min);
  Q_INVOKABLE void create_blood_transfusion_action(QString compound, double bagVolume_mL, double rate_mL_Per_min);
  Q_INVOKABLE void create_burn_action(double tbsa);
  Q_INVOKABLE void create_infection_action(QString compartment, int severity, double mic_mg_Per_L);
  Q_INVOKABLE void create_exercise_action(int type, double weight_kg, double property_1, double property_2);
  Q_INVOKABLE void create_pain_stimulus_action(double severity, QString location);
  Q_INVOKABLE void create_tension_pneumothorax_action(double severity, int type, int side);
  Q_INVOKABLE void create_airway_obstruction_action(double severity);
  Q_INVOKABLE void create_bronchoconstriction_action(double severity);
  Q_INVOKABLE void create_traumatic_brain_injury_action(double severity, int type);
  Q_INVOKABLE void create_acute_stress_action(double severity);
  Q_INVOKABLE void create_apnea_action(double severity);
  Q_INVOKABLE void create_cardiac_arrest_action(bool state);
  Q_INVOKABLE void create_needle_decompression_action(int state, int side);
  Q_INVOKABLE void create_tourniquet_action(QString compartment, int level);
  Q_INVOKABLE void create_inhaler_action();
  Q_INVOKABLE void create_anesthesia_machine_action(int connection, int primaryGas, int source, double pMax_cmH2O, double peep_cmH2O, double reliefPressure_cmH2O, double inletFlow_L_Per_min, double respirationRate_Per_min, double ieRatio, double o2Fraction, double bottle1_mL, double bottle2_mL, QString leftSub, double leftSubFraction, QString rightSub, double rightSubFraction);

  Q_INVOKABLE QString patient_name_and_time();
  Q_INVOKABLE QString get_patient_state_files();
  Q_INVOKABLE QList<QString> get_nested_patient_state_list();
  Q_INVOKABLE QString get_patient_state_files(std::string patient);
  Q_INVOKABLE QString get_patient_state_files(QString patient);
  Q_INVOKABLE bool file_exists(QString file);
  Q_INVOKABLE bool file_exists(std::string file);

  Q_INVOKABLE void request_urinalysis();
  Q_INVOKABLE void request_blood_panel();

signals:
  void patientMetricsChanged(PatientMetrics* metrics);
  void patientStateChanged(PatientState patientState);
  void patientConditionsChanged(PatientConditions conditions);
  void urinalysis_completed(Urinalysis* urinalysis); 

  void dataRequestModelChanged(DataRequestTree* requestTree);
  void timeAdvance(double time_s);
  void loadScenarioToBuilder(EventTree* events, QVariantList requests, QString sampling);
  void loadScenarioToControls(EventTree* events);
  void substanceActivated(QModelIndex subIndex);
  void physiologyChanged(BioGearsData* model);
  void stateLoad(QString stateBaseName);
  void newStateAdded();
  void runningToggled(bool isRunning);
  void pausedToggled(bool isPaused);
  void throttledToggled(bool isThrottled);
  void loggerChanged();

protected:
  PatientMetrics* get_physiology_metrics();
  PatientState get_physiology_state();
  PatientConditions get_physiology_conditions();

  void setup_physiology_model();
  void configure_physiology_model();
  void setup_data_request_tree();
  void setup_physiology_substances(BioGearsData*);
  void setup_physiology_lists();
  void remake_engine();
  void physiology_thread_main();
  void physiology_thread_step();

  void export_environment(const biogears::SEEnvironmentalConditions* environment);
  void export_compound(const biogears::SESubstanceCompound* compound);
  void export_nutrition(const biogears::SENutrition* nutrition);
  void export_patient(const biogears::SEPatient* patient);
  void export_substance(const biogears::SESubstance* substance);

private:
  bool _initialized = false;
  std::thread _thread;
  biogears::Logger _logger;
  std::unique_ptr<biogears::BioGearsEngine> _engine;
  std::shared_ptr<biogears::SEUrinalysis> _urinalysis;
  std::unique_ptr<Urinalysis> _urinalysis_qml;
  std::shared_ptr<biogears::SEComprehensiveMetabolicPanel> _blood_panel;
  std::string _scenario_name;
  ActionChannel _action_queue;
  AssessmentChannel _assessment_queue;

  std::vector<biogears::SESubstance*> _substance_queue;

  std::mutex _engine_mutex;

  std::unique_ptr<PatientMetrics> _current_metrics;
  std::unique_ptr<PatientConditions> _current_conditions;
  std::unique_ptr<PatientState> _current_state;

  std::atomic<bool> _running;
  std::atomic<bool> _paused;
  std::atomic<bool> _throttle;

  QVariantList _drugs_list; //Subs with PK/PD data
  QVariantList _volatile_drugs_list; //Gaseous subs with PK/PD that can be added to ventilator
  QVariantList _compounds_list; //Compounds
  QVariantList _transfusions_list; //Blood products
  QVariantList _components_list; //Subs that can be components of compounds
  QVariantList _ambient_gas_list; //Gases that can be added to environment
  QVariantList _ambient_aerosol_list; //Aerosolized liquids that can be added to environment
  QVariantList _nutrition_list;

  BioGearsData* _physiology_model;
  DataRequestTree* _data_request_tree;

  QtLogForward* _consoleLog;

  std::unique_ptr<biogears::SEScalar> _new_respiratory_cycle;
};
}
