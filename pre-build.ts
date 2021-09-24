import util = require('util');
import child_process = require('child_process');
const exec = util.promisify(child_process.exec);
import { promises as fs, existsSync } from 'fs';
import path = require('path');
import minify = require('minify');

async function copyFolderRecursive(source: string, target: string) {
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
  const options: minify.Options = {
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
  const nativeJsPath = path.join('public', 'flutter', 'native.js');
  const nativeSource = await minify(nativeJsPath, options);
  await fs.writeFile(nativeJsPath, nativeSource, 'utf8');
  const preloadCssPath = path.join('public', 'flutter', 'preload.css');
  const preloadSource = await minify(preloadCssPath, options);
  await fs.writeFile(preloadCssPath, preloadSource, 'utf8');

  // change html base url
  const indexPath = path.join('public', 'flutter', 'index.html');
  const indexBuffer = await fs.readFile(indexPath, 'utf8');
  const indexData = indexBuffer.toString();
  const indexSource = indexData.replace('"/"', '"/flutter/"');
  await fs.writeFile(indexPath, indexSource, 'utf8');
}

main();

