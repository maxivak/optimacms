// jquery

import $ from 'jquery';

global.$ = $
global.jQuery = $


//
import 'jquery-ui';

// jquery-ui theme
//import "jquery-ui/jquery-ui.css";
//import "jquery-ui/jquery-ui.theme";

require.context('file-loader?name=[path][name].[ext]&context=node_modules/jquery-ui-dist!jquery-ui-dist', true,    /jquery-ui\.css/ );
require.context('file-loader?name=[path][name].[ext]&context=node_modules/jquery-ui-dist!jquery-ui-dist', true,    /jquery-ui\.theme\.css/ );




// elfinder
require('script-loader!elfinder/js/elfinder.full.js');
require('script-loader!elfinder/js/proxy/elFinderSupportVer1.js');
//require('script-loader!elfinder/js/i18n/elfinder.ru.js');


//require('elfinder');
//require.context('script-loader?name=[path][name].[ext]&context=node_modules/elfinder!elfinder/js', true,    /elfinder\.full\.js/ );

