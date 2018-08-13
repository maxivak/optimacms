const webpack = require("webpack");

const config = {
    context: __dirname + "/app/javascript/packs",

    entry: {
        application: ["application.js"],
    },

    output: {
        path: __dirname + "/public/packs",
        //filename: "[name]-[hash].js",
    },

    /*
     output: {
     path: __dirname + "/public/packs",
     filename: js_output_template,
     },

     */

    module: {
        loaders: [
            {
                test: /\.js$/,
                exclude: /node_modules/,
                loader: 'babel',
                query: {
                    presets: ['es2015']
                }
            },


            {
                test: /\.css$/,
                use: [ 'style-loader', 'css-loader' ]
            },
            {
                test: /\.scss$/,
                use: [
                    {
                        loader: "style-loader" // creates style nodes from JS strings
                    },
                    {
                        loader: "css-loader" // translates CSS into CommonJS
                    },
                    {
                        loader: "sass-loader" // compiles Sass to CSS
                    }
                ]
            },


            {
                test: /\.(jpg|png|gif|svg)$/,
                exclude: /node_modules/,
                loader: 'file-loader'
            },


            // file-loader(for images)
            /*
            {
                test: /\.(jpg|png|gif|svg)$/,
                use: [
                    {
                        loader: 'file-loader',
                        options: {
                            name: '[name].[ext]',
                            outputPath: './assets/media/'
                        }
                    }
                ]
            },
            */

            // file-loader(for fonts)
            {
                test: /\.(woff|woff2|eot|ttf|otf)$/,
                use: ['file-loader']
            },


            // tinymce
            {
                test: require.resolve('tinymce/tinymce'),
                loaders: [
                    'imports?this=>window',
                    'exports?window.tinymce'
                ]
            },
            {
                test: /tinymce\/(themes|plugins)\//,
                loaders: [
                    'imports?this=>window'
                ]
            },

            // elfinder





        ]
    },
    resolve: {
        alias: {
            //'jquery-ui': 'jquery-ui-dist/jquery-ui.js',

            // bind version of jquery-ui
            //"jquery-ui": "jquery-ui/jquery-ui.js",
            // bind to modules;
            //modules: path.join(__dirname, "node_modules"),

        }
    },
    plugins: [
        /*
        new webpack.ProvidePlugin({
            $: 'jquery',
            JQuery: 'jquery',
            jquery: 'jquery',
            'window.Tether': "tether",
            Popper: ['popper.js', 'default'], // for Bootstrap 4
        }),
        */

        //new webpack.optimize.UglifyJsPlugin(),

    ]
};

module.exports = config