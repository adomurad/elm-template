#!/bin/sh

set -e

rm -rf ./out
cp -r ./public/ ./out/

js="./out/elm.js"
min="./out/elm.min.js"

elm make --optimize --output=$js "$@"

uglifyjs $js --compress 'pure_funcs=[F2,F3,F4,F5,F6,F7,F8,F9,A2,A3,A4,A5,A6,A7,A8,A9],pure_getters,keep_fargs=false,unsafe_comps,unsafe' | uglifyjs --mangle --output $min



sass="./style/main.scss"
css="./out/style.css"
cssPrefixed="./out/style.pref.css"
cssMin="./out/style.min.css"

sass --no-source-map $sass $css
# concat -o css/style.concat.css css/icon-font.css css/style.comp.css
postcss --no-map --use autoprefixer -b 'last 10 versions' $css -o $cssPrefixed
sass --style compressed --no-source-map $cssPrefixed $cssMin



echo "--------------------------------------------------"
echo "ELM Compiled size: $(wc -c $js | awk '{print $1}') bytes  ($js)"
echo "ELM Minified size: $(wc -c $min | awk '{print $1}') bytes  ($min)"
echo "ELM Gzipped size: $(gzip $min -c | wc -c | awk '{print $1}') bytes"
echo "--------------------------------------------------"
echo "STYLES Compiled size: $(wc -c $css | awk '{print $1}') bytes  ($css)"
echo "STYLES Prefixed size: $(wc -c $cssPrefixed | awk '{print $1}') bytes  ($cssPrefixed)"
echo "STYLES Minified size: $(wc -c $cssMin | awk '{print $1}') bytes  ($cssMin)"
echo "STYLES Gzipped size: $(gzip $cssMin -c | wc -c | awk '{print $1}') bytes"
echo "--------------------------------------------------"

rm $min
rm $css
rm $cssPrefixed