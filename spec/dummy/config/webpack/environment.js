const { environment } = require('@rails/webpacker');

const merge = require('webpack-merge')
const webpack = require('webpack');


//const erb =  require('./loaders/erb')

//environment.loaders.append('erb', erb)


// resolve-url-loader must be used before sass-loader
environment.loaders.get('sass').use.splice(-1, 0, {
    loader: 'resolve-url-loader',
    options: {
        attempts: 1
    }
});


// Add an additional plugin of your choosing : ProvidePlugin

environment.plugins.prepend('Provide', new webpack.ProvidePlugin({
        $: 'jquery',
        JQuery: 'jquery',
        jquery: 'jquery',
        'window.Tether': "tether",
        Popper: ['popper.js', 'default'], // for Bootstrap 4
    })
)

//
//const envConfig = module.exports = environment

const aliasConfig = {
    'jquery': 'jquery/src/jquery',
    'jquery-ui': 'jquery-ui-dist/jquery-ui.js',
    //'elfinder': 'elfinder/js/elfinder.full.js'

};

environment.config.set('resolve.alias', aliasConfig);



//module.exports = merge(envConfig, aliasConfig)


//
module.exports = environment;
