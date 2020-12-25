const delay = ms => new Promise(res => setTimeout(res, ms))

// declare [bindFunction] and [onInvokeMethod] in Dart side.
const dartFunctions = {}
function bindFunction(name, fn) { dartFunctions[name] = fn }

function onInvokeMethod(obj) {
    switch (obj.method) {
        case 'isMobile':
            return isMobile(obj.arguments);

        case 'isIOS':
            return isIOS(obj.arguments);

        case 'openFileDialog':
            return openFileDialog(obj.arguments);

        case 'alert':
            return alert(obj.arguments);

        case 'reload':
            return reload(obj.arguments);

        case 'upgrade':
            return upgrade(obj.arguments);

        case 'openDevTool':
            return openDevTool(obj.arguments);

        case 'setLogParseFunction':
            return eval('logParseFunction = ' + obj.arguments);// register function

        case 'getBrowserType':
            return getBrowserType(obj.arguments);

        case 'installPWA':
            return installPWA(obj.arguments);

        default:
            return console.log('NoSuchMethod');
    };
}

const invokeDartMethod = (method, args) => { return dartFunctions[method](args) }

class LogParseResult {
    constructor(obj) {
        this.src = obj.src
        this.dst = obj.dst
        this.srcInfo = obj.srcInfo
        this.dstInfo = obj.dstInfo
        this.intermediate = obj.intermediate
        this.ueName = obj.ueName
    }
}
const _errorResult = new LogParseResult({
    src: null,
    dst: null,
    srcInfo: null,
    dstInfo: null,
    intermediate: null,
    ueName: null
})
function logParseFunctionWrapper(line) {
    try {
        return new LogParseResult(logParseFunction(line))
    } catch (error) {
        return _errorResult
    }
}

class FileDescriptor {
    constructor(name, uint8List) {
        this.name = name
        this.data = uint8List
    }
}

let deferredPrompt;

window.addEventListener('beforeinstallprompt', (e) => {
    // Stash the event so it can be triggered later.
    deferredPrompt = e;
});

const installPWA = (args) => {
    deferredPrompt.prompt();
    deferredPrompt.userChoice.then((choiceResult) => { args.callback(choiceResult.outcome === 'accepted') });
}

const isMobile = (args) => {
    args.callback(/Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i.test(navigator.userAgent));
}

function isIOS(args) {
    args.callback(
        [
            'iPad Simulator',
            'iPhone Simulator',
            'iPod Simulator',
            'iPad',
            'iPhone',
            'iPod'
        ].includes(navigator.platform)
        // iPad on iOS 13 detection
        || (navigator.userAgent.includes("Mac") && "ontouchend" in document)
    )
}

const getBrowserType = (args) => {
    if ((navigator.userAgent.indexOf("Opera") || navigator.userAgent.indexOf('OPR')) != -1)
        return args.callback('Opera');
    else if (navigator.userAgent.indexOf("Chrome") != -1)
        return args.callback('Chrome');
    else if (navigator.userAgent.indexOf("Safari") != -1)
        return args.callback('Safari');
    else if (navigator.userAgent.indexOf("Firefox") != -1)
        return args.callback('Firefox');
    else if ((navigator.userAgent.indexOf("MSIE") != -1) || (!!document.documentMode == true)) //IF IE > 10
        return args.callback('IE');
    else
        return args.callback('unknown');

}


const loadFileAsync = async (multiple, accept) => {
    const readFileAsync = (file) => {
        return new Promise((resolve, reject) => {
            const reader = new FileReader()
            reader.onload = () => { resolve(reader.result) }
            reader.onerror = reject
            reader.readAsArrayBuffer(file)
        })
    }

    const inputFile = (multiple, accept) => {
        return new Promise((resolve) => {
            const input = document.createElement('input')
            input.type = 'file';
            if (multiple != null) input.multiple = multiple
            if (accept != null) input.accept = accept

            let fileList = null;
            const cache = document.body.onfocus;

            input.onchange = async (event) => {
                if (fileList === null) {
                    fileList = event.target.files
                    resolve(fileList)
                }
            }
            input.onclick = () => {
                document.body.onfocus = async () => {
                    document.body.onfocus = cache;
                    await delay(350)
                    if (fileList === null) {
                        console.log('Read-files timeout. ')
                        fileList = []
                        resolve(fileList)
                    }
                }
            }

            input.click()
        })
    }

    const fileList = await inputFile(multiple, accept)
    const res = []
    for (let i = 0; i < fileList.length; i++) {
        const file = fileList[i]
        try {
            const arrayBuffer = await readFileAsync(file)
            res.push(new FileDescriptor(file.name, new Uint8Array(arrayBuffer)))
        } catch (error) { }
    }
    return res;
}

const openFileDialog = async (args) => {
    const res = await loadFileAsync(args.multiple, args.accept)
    args.callback(res)
}

const timeout = (promise, ms) => {
    const timer = new Promise((resolve, reject) => {
        const id = setTimeout(() => {
            clearTimeout(id)
            reject('Timed out in ' + ms + 'ms.')
        }, ms)
    })
    return Promise.race([promise, timer])
}

const reload = () => { window.location.reload(true) }

const openDevTool = args => {
    console.log('openDevTool')
    try {
        // detect whether electron platform
        window.ipcRenderer.send('openDevTool')
        args.callback(null)
    } catch (error) {
        // If this is web platform, web platform can't open DevTool by js. 
        args.callback('Failed to import electron modules. \nWeb application can\'t open DevTool programmatically. \nPress "F12" to explicit open DevTool. ')
    }
}

// should not change
const upgrade = async (args) => {
    console.log('software is ready to upgrade. ')
    if (window.fs === undefined ||
        window.ipcRenderer === undefined ||
        window.dialog === undefined ||
        window.unzipper === undefined ||
        window.fsExtra === undefined ||
        window.path === undefined ||
        window.dirname === undefined)
        return window.location.reload();

    const fs = window.fs
    const dialog = window.dialog
    const ipcRenderer = window.ipcRenderer
    const unzipper = window.unzipper
    const fsExtra = window.fsExtra
    const path = window.path
    const __dirname = window.dirname

    console.log('modules loaded successfully. ')
    args.callback('Electron modules loaded')

    function mkdir(dir) {
        return new Promise((resolve, reject) => {
            fsExtra.ensureDir(dir, (error) => {
                if (error) reject(error);
                else resolve(dir);
            })
        });
    }

    function readdir(dir) {
        return new Promise((resolve, reject) => {
            fs.readdir(dir, (error, files) => {
                if (error) reject(error)
                else resolve(files)
            });
        })
    }

    function remove(dir) {
        return new Promise((resolve, reject) => {
            fsExtra.remove(dir, (error) => {
                if (error) reject(error)
                else resolve(undefined)
            });
        })
    }

    function copy(src, dst) {
        return new Promise((resolve, reject) => {
            fsExtra.copy(src, dst, function (error) {
                if (error) reject(error)
                else resolve(dst)
            });
        })
    }

    function unzip(src, dst) {
        return new Promise((resolve) => {
            fs.createReadStream(src)
                .pipe(unzipper.Extract({ path: dst }))
                .on('finish', resolve);
        });
    }

    function showOpenFileDialog() {
        return new Promise((resolve) => {
            dialog.showOpenDialog({
                filters: [
                    { name: 'UPGRADE', extensions: ['upgrade'] },
                    { name: 'ALL FILE', extensions: ['*'] }
                ],
            }, (filePaths) => { resolve(filePaths) })
        })
    }

    // dialog
    args.callback('Please select upgrade package')
    const filePaths = await showOpenFileDialog();
    if (filePaths === undefined || filePaths.length == 0) return args.callback(0) // exit code: 0 (no upgrade package)

    const filePath = filePaths[0]
    console.log('filePath: ' + filePath)
    const fileName = filePath.replace(/^.*[\\\/]/, '')
    console.log('fileName: ' + fileName)
    const cachePath = path.join(__dirname, '.cache')
    console.log('cachePath: ' + cachePath)
    const upgradeDir = path.join(cachePath, '.upgrade')
    const bakDir = path.join(upgradeDir, '.bak')

    // mkdir and clear cache
    args.callback('Ensure files directory')
    try {
        await timeout(remove(upgradeDir), 10000)
        await timeout(mkdir(bakDir), 15000)
    } catch (error) {
        console.log(error.toString());
        return args.callback(2); // exit code: 2 (make directory failed)
    }
    console.log('Directory clear')
    const unzipFilePath = path.join(upgradeDir, fileName);
    console.log('unzipFilePath: ' + unzipFilePath)

    // unzip
    args.callback('Extract upgrade code')
    try {
        await timeout(unzip(filePath, unzipFilePath), 30000)
    } catch (error) {
        console.log(error.toString());
        return args.callback(3); // exit code: 3 (extract failed)
    }

    console.log('Unzip successfully')
    await delay(250)

    args.callback('Try to backup current version')
    const files = await readdir(unzipFilePath)
    let hasError = false
    for (const file of files) {
        const filePath = path.join(__dirname, file)
        console.log(filePath)
        try {
            if (fs.existsSync(filePath)) {
                const newPath = path.join(bakDir, file)
                if (fs.lstatSync(filePath).isDirectory()) {
                    await timeout(mkdir(newPath), 50)
                    await timeout(copy(filePath, newPath), 100)
                } else
                    await timeout(copy(filePath, newPath), 50)
            }
        } catch (error) {
            hasError = true
            console.log(error.toString())
        }
    }

    if (hasError) {
        args.callback('Backup operation have some trouble')
        await delay(2500)
    }

    args.callback('Override code')
    try {
        await timeout(copy(unzipFilePath, __dirname), 10000)
    } catch (error) {
        console.log(error.toString())
        return args.callback(4) // exit code: 4 (override failed)
    }

    args.callback('Upgrade successfully')
    await delay(1000)
    args.callback('Program will reload in seconds')
    await delay(1000)

    return ipcRenderer.send('reload');
}

