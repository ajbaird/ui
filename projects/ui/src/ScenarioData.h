#pragma once
#include <string>
#include <fstream>
#include <iostream>
#include <vector>
#include <boost/algorithm/string/split.hpp>
#include <boost/algorithm/string/classification.hpp>

class ScenarioData
{
public:
	ScenarioData();
	~ScenarioData();

	std::vector<std::string>& getHeaders();
	void setHeaders();
	void setDataSeries(std::string &y_header);
	void setScenario(std::string &file_name);
	std::vector<double>& getXSeries();
	std::vector<double>& getYSeries();

private:
	std::string file_name_;
	std::vector<std::string> headers_vector_;
	std::vector<double> x_data_;
	std::vector<double> y_data_;
};
