'use strict';

const path = require('path');
const webpack = require('webpack');
const CopyWebpackPlugin = require('copy-webpack-plugin');
const CleanWebpackPlugin = require('clean-webpack-plugin');

var src = path.resolve(__dirname, 'frontend');
var dist = path.resolve(__dirname, 'dist');

var isProd = process.env.NODE_ENV === 'production';

var plugins = [
    new CopyWebpackPlugin([
        {from:  path.join(src, 'favicon.ico'), to: path.join(dist, 'favicon.ico')}
    ]),
    new webpack.ProvidePlugin({
        $: 'jquery',
        jQuery: 'jquery',
        'window.jQuery': 'jquery',
        Popper: ['popper.js', 'default'],
        // In case you imported plugins individually, you must also require them here:
        Util: "exports-loader?Util!bootstrap/js/dist/util",
        Dropdown: "exports-loader?Dropdown!bootstrap/js/dist/dropdown"
    })
];

if (isProd) {
    plugins.push(new CleanWebpackPlugin([dist]));
}

module.exports = {
    entry:  path.join(src, 'js', 'index.js'),
    output: {
        filename: 'bundle.js',
        path: path.join(dist, 'js')
    },
    plugins: plugins,
    module: {
        rules: [
            {        
                test: /\.css$/,
                use: [
                   'style-loader',
                   'css-loader'
                ]
            },
            {
                test: /\.(scss|sass)$/,
                use: [
                    {
                        loader: 'style-loader', // inject CSS to page
                    }, 
                    {
                        loader: 'css-loader', // translates CSS into CommonJS modules
                    }, 
                    {
                        loader: 'postcss-loader', // Run post css actions
                        options: {
                            plugins: function () { // post css plugins, can be exported to postcss.config.js
                                return [
                                    require('precss'),
                                    require('autoprefixer')
                                ] ;
                            }
                        }
                    }, 
                    {
                          loader: 'sass-loader' // compiles SASS to CSS
                    }
                ]
            },
            {
                test: /\.(png|svg|jpg|gif)$/,
                use: [
                    {
                        loader: 'file-loader',
                        options: {
                            outputPath: '../img/'
                        }
                    }
                ],
            }
        ]
   }
};
