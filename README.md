# track-shipment-demo
Demo Interface for tracking shipments

###Installation

Install CoffeeScript if not installed (requires [Node.js](http://nodejs.org/)).
```bash
npm install -g coffee-script
```
Install Sass if not installed (requires [Ruby](https://www.ruby-lang.org/en/documentation/installation/)).
```bash
sudo su -c "gem install sass"
```
Install `bower` if not installed.
```bash
npm install -g bower
```
Execute the following commands in terminal.
```bash
git clone https://github.com/egorvinogradov/track-shipment-demo.git
cd track-shipment-demo
bower install
coffee -cb .
sass --update css/app.sass:css/app.css
python -m SimpleHTTPServer
```
Open http://127.0.0.1:8000/ in browser.
