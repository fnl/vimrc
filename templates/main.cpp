#include <fstream>
#include <iostream>

#include <boost/any.hpp>
#include <boost/filesystem.hpp>
#include <boost/log/expressions.hpp>
#include <boost/log/support/date_time.hpp>
#include <boost/log/trivial.hpp>
#include <boost/log/utility/setup/common_attributes.hpp>
#include <boost/log/utility/setup/console.hpp>
#include <boost/log/utility/setup/file.hpp>
#include <boost/program_options.hpp>

#include "version.hpp"

using namespace std;
namespace po = boost::program_options;
namespace blog = boost::log;

void Process(istream &input) {
  string line;

  while (getline(input, line)) {
    cout << line << '\n';
  }
}

inline void PrintUsage(const po::options_description desc, string prog) {
  cout << "Usage: " << prog << " [options] FILE..." << endl;
  cout << "  app description..." << endl;
  cout << desc << endl;
  cout << "Version: " << VERSION_MAJOR << "." << VERSION_MINOR << endl;
}

inline void PrintVariableMap(const po::variables_map vm) {
  for (po::variables_map::const_iterator it = vm.begin(); it != vm.end();
       it++) {
    cerr << "> " << it->first;

    if (((boost::any)it->second.value()).empty()) {
      cerr << "(empty)";
    }
    if (vm[it->first].defaulted() || it->second.defaulted()) {
      cerr << "(default)";
    }
    cerr << "=";

    bool is_char;
    try {
      boost::any_cast<const char *>(it->second.value());
      is_char = true;
    } catch (const boost::bad_any_cast &) {
      is_char = false;
    }
    bool is_str;
    try {
      boost::any_cast<string>(it->second.value());
      is_str = true;
    } catch (const boost::bad_any_cast &) {
      is_str = false;
    }
    bool is_log;
    try {
      boost::any_cast<blog::trivial::severity_level>(it->second.value());
      is_log = true;
    } catch (const boost::bad_any_cast &) {
      is_log = false;
    }

    const type_info &ti = ((boost::any)it->second.value()).type();
    if (ti == typeid(int)) {
      cerr << vm[it->first].as<int>() << endl;
    } else if (ti == typeid(bool)) {
      cerr << vm[it->first].as<bool>() << endl;
    } else if (ti == typeid(double)) {
      cerr << vm[it->first].as<double>() << endl;
    } else if (is_log) {
      cerr << vm[it->first].as<blog::trivial::severity_level>() << endl;
    } else if (is_char) {
      cerr << vm[it->first].as<const char *>() << endl;
    } else if (is_str) {
      string temp = vm[it->first].as<string>();
      if (temp.size()) {
        cerr << temp << endl;
      } else {
        cerr << "true" << endl;
      }
    } else { // Assumes that the only remainder is vector<string>
      try {
        vector<string> vect = vm[it->first].as<vector<string>>();
        uint i = 0;
        for (vector<string>::iterator oit = vect.begin(); oit != vect.end();
             oit++, ++i) {
          cerr << "\r> " << it->first << "[" << i << "]=" << (*oit) << endl;
        }
      } catch (const boost::bad_any_cast &) {
        cerr << "UnknownType(" << ((boost::any)it->second.value()).type().name()
             << ")" << endl;
      }
    }
  }
}

int main(int ac, const char *const av[]) {
  boost::filesystem::path path = av[0];
  blog::trivial::severity_level log_severity;
  blog::sources::severity_logger<blog::trivial::severity_level> logger;
  po::options_description desc("Options");
  po::positional_options_description p;
  po::variables_map vm;
  int error_count = 0;
  int some_option = 0;
  bool flag = false;

  desc.add_options()("help,h", "produce this help message")(
      "log-severity,l", po::value<blog::trivial::severity_level>(&log_severity)
                            ->default_value(blog::trivial::warning),
      "log level (debug|info|warning*|error|fatal)")(
      "log-file", po::value<string>(), "log to file instead CLOG")(
      "compression,c", po::value<int>(), "set compression level")(
      "flag,f", po::bool_switch(&flag), "set flag")(
      "optimization,o", po::value<int>(&some_option)->default_value(10),
      "optimization level")("include-path,i", po::value<vector<string>>(),
                            "include path")(
      "file,f", po::value<vector<string>>(), "input FILE");

  p.add("file", -1);

  try {
    po::store(po::command_line_parser(ac, av).options(desc).positional(p).run(),
              vm);
    po::notify(vm);
  } catch (po::error &e) {
    BOOST_LOG_SEV(logger, blog::trivial::fatal) << e.what();
    return -1;
  }

  if (vm.count("help")) {
    PrintUsage(desc, path.stem().string());
    return 0;
  }

  blog::add_common_attributes();

  if (vm.count("log-file")) {
    blog::add_file_log(
        vm["log-file"].as<string>(),
        blog::keywords::format =
            (blog::expressions::stream
             << "["
             << blog::expressions::format_date_time<boost::posix_time::ptime>(
                    "TimeStamp", "%Y-%m-%d %H:%M:%S")
             << "] [" << blog::trivial::severity << "] "
             << blog::expressions::smessage));
  } else {
    blog::add_console_log(
        std::clog,
        blog::keywords::format =
            (blog::expressions::stream
             << "["
             << blog::expressions::format_date_time<boost::posix_time::ptime>(
                    "TimeStamp", "%H:%M:%S")
             << "] [" << blog::trivial::severity << "] "
             << blog::expressions::smessage));
  }

  blog::core::get()->set_filter(blog::trivial::severity >= log_severity);
  BOOST_LOG_SEV(logger, blog::trivial::info) << "logging severity set to "
                                             << log_severity;

  if (blog::trivial::debug == log_severity) {
    BOOST_LOG_SEV(logger, blog::trivial::debug)
        << "detected options and arguments";
    PrintVariableMap(vm);
  }

  try {
    vector<string> files = vm["file"].as<vector<string>>();

    for (vector<string>::iterator it = files.begin(); it != files.end(); ++it) {
      cerr << "> processing " << *it << endl;
      ifstream infile{*it};

      if (infile.is_open()) {
        Process(infile);
        infile.close();
      } else {
        BOOST_LOG_SEV(logger, blog::trivial::error) << "unable to open " << *it;
        error_count++;
      }
    }
  } catch (const boost::bad_any_cast &) {
    cerr << "> processing STDIN" << endl;
    cout.flush();
    Process(cin);
  }

  return error_count;
}
