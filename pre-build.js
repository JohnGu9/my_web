const util = require('util');
const exec = util.promisify(require('child_process').exec);
const fs = require('fs').promises;
const { existsSync } = require('fs');
const path = require('path');
const minify = require('minify');

async function copyFolderRecursive(source, target) {
  // Check if folder needs to be created or integrated
  if (!existsSync(target)) await fs.mkdir(target);

  // Copy
  if ((await fs.lstat(source)).isDirectory()) {
    const files = await fs.readdir(source);
    for (const file of files) {
      const curSource = path.join(source, file);
      const targetPath = path.join(target, file)
      if ((await fs.lstat(curSource)).isDirectory()) {
        await copyFolderRecursive(curSource, targetPath);
      } else {
        await fs.writeFile(targetPath, await fs.readFile(curSource));
      }
    }
  }
}

async function main() {
  console.log('build flutter app...')
  const { stdout } = await exec('cd flutter && flutter build web --release --dart-define=FLUTTER_WEB_CANVASKIT_URL=/');
  console.log(stdout);

  console.log('merge flutter to root reactjs project...');

  // copy app file
  const targetPath = path.join(__dirname, 'public', 'flutter');
  const sourcePath = path.join(__dirname, 'flutter', 'build', 'web');
  if (existsSync(targetPath)) await fs.rmdir(targetPath, { recursive: true });
  await copyFolderRecursive(sourcePath, targetPath);
  await fs.rename(path.join(__dirname, 'public', 'flutter', 'canvaskit.js'), path.join(__dirname, 'public', 'canvaskit.js'));
  await fs.rename(path.join(__dirname, 'public', 'flutter', 'canvaskit.wasm'), path.join(__dirname, 'public', 'canvaskit.wasm'));

  // minify js and css
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
  const native = await minify('./public/flutter/native.js', options);
  await fs.writeFile('./public/flutter/native.js', native, 'utf8');
  const preload = await minify('./public/flutter/preload.css', options);
  await fs.writeFile('./public/flutter/preload.css', preload, 'utf8');

  // change html base url
  const flutterIndex = './public/flutter/index.html';
  const indexBuffer = await fs.readFile(flutterIndex, 'utf8');
  const indexData = indexBuffer.toString();
  const indexResult = indexData.replace('"/"', '"/flutter/"');
  await fs.writeFile(flutterIndex, indexResult, 'utf8');
}

main();

