

// core
import tinymce from 'tinymce/tinymce'
import 'tinymce/themes/modern/theme'


// plugins
import 'tinymce/plugins/advlist/plugin'
import 'tinymce/plugins/autolink/plugin'
import 'tinymce/plugins/lists/plugin'
import 'tinymce/plugins/image/plugin'
import 'tinymce/plugins/charmap/plugin'
import 'tinymce/plugins/print/plugin'
import 'tinymce/plugins/paste/plugin'
import 'tinymce/plugins/link/plugin'
import 'tinymce/plugins/autoresize/plugin'

import 'tinymce/plugins/preview/plugin'
import 'tinymce/plugins/anchor/plugin'
import 'tinymce/plugins/searchreplace/plugin'
import 'tinymce/plugins/visualblocks/plugin'

import 'tinymce/plugins/code/plugin'
import 'tinymce/plugins/fullscreen/plugin'
import 'tinymce/plugins/insertdatetime/plugin'
import 'tinymce/plugins/media/plugin'

import 'tinymce/plugins/table/plugin'
import 'tinymce/plugins/contextmenu/plugin'
import 'tinymce/plugins/media/plugin'




// skins
//require.context('tinymce/skins', true, /.*/);

//require.context('file?name=[path][name].[ext]&context=node_modules/tinymce!tinymce/skins',    true,    /.*/ );
require.context('file-loader?name=[path][name].[ext]&context=node_modules/tinymce!tinymce/skins', true,    /.*/ );
