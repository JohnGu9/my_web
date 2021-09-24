const util = require('util');
const exec = util.promisify(require('child_process').exec);
const fs = require('fs').promises;
const minify = require('minify');

const options = {
  html: {
  },
  css: {
    compatibility: '*',
  },
  js: {
    ecma: 5,
  },
  img: {
    maxSize: 4096,
  },
};

async function main() {
  console.log('running pre-build.js')
  const { stdout } = await exec('cd flutter && flutter build web --release --dart-define=FLUTTER_WEB_CANVASKIT_URL=/');
  console.log(stdout);


  console.log('merge flutter to root reactjs project');
  // TODO: use js code to modify files rather than system command
  await exec('rm -rf ./public/flutter');
  await exec('cp -rf ./flutter/build/web public/flutter');
  await exec('mv -f ./public/flutter/canvaskit.* public');


  const native = await minify('./public/flutter/native.js', options);
  await fs.writeFile('./public/flutter/native.js', native, 'utf8');


  const preload = await minify('./public/flutter/preload.css', options);
  await fs.writeFile('./public/flutter/preload.css', preload, 'utf8');


  const flutterIndex = './public/flutter/index.html';
  const indexBuffer = await fs.readFile(flutterIndex, 'utf8');
  const indexData = indexBuffer.toString();
  const indexResult = indexData.replace('"/"', '"/flutter/"');
  await fs.writeFile(flutterIndex, indexResult, 'utf8');
}

main();
