from flask import *

app = Flask(__name__, static_url_path=r'',
            static_folder=r'../build/web', template_folder=r'template')


@app.route('/')
def index():
    return app.send_static_file(r'index.html')


@app.route('/js/<path>', methods=['GET', 'POST'])
def js(path):
    return app.send_static_file(r'assets/js/'+path)


@app.route('/jquery.min.js', methods=['GET', 'POST'])
def jquery():
    return render_template(r'jquery.min.js')


@app.route('/<path>')
def dart(path):
    return app.send_static_file(path)


if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)
