const { execSync } = require('child_process');
const fs = require('fs');

console.log('running pre-build.js')
execSync('cd flutter && flutter build web --release --dart-define=FLUTTER_WEB_CANVASKIT_URL=/',
  (err, stdout) => {
    if (err) return;
    console.log(`${stdout}`);
  });

execSync('rm -rf public/flutter');
execSync('cp -rf flutter/build/web public/flutter');
execSync('mv -f public/flutter/canvaskit.* public');

const flutterIndex = 'public/flutter/index.html';
fs.readFile(flutterIndex, 'utf8', function (err, data) {
  if (err) return console.log(err);
  const result = data.replace('"/"', '"/flutter/"');
  fs.writeFile(flutterIndex, result, 'utf8', function (err) {
    if (err) return console.log(err);
  });
});