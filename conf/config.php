<?PHP  // Moodle configuration file
unset($CFG);
global $CFG;
$CFG = new stdClass();
$CFG->dbtype    = 'mariadb';
$CFG->dblibrary = 'native';
$CFG->dbhost    = 'localhost';
$CFG->dbname    = 'moodle';
$CFG->dbuser    = 'moodle';
$CFG->dbpass    = '123456';
$CFG->prefix    = 'mdl_';
$CFG->dboptions = array(
  'dbpersist' => 0,
  'dbport' => '',
  'dbsocket' => '',
);
$CFG->wwwroot   = 'http://192.168.128.108';
$CFG->dataroot  = '/www/moodledata';
$CFG->directorypermissions = 0777;
$CFG->admin = 'admin';
require_once(dirname(__FILE__) . '/lib/setup.php'); // Do not edit
