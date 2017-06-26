# eco
> Use an IoT device to monitor water usage using gamification.

Using arduino MKR1000 connected to a liquid flow meter, we send data to an express server and store data using mySQL.
Also being used is an online application which utilizes express to read the data and present it in a fun way.


## Install
### app
This sectoin depends on a knowledge of: [Javascript](https://developer.mozilla.org/en-US/docs/Web/JavaScript), [express](https://expressjs.com/), [HTTP/1.1](https://tools.ietf.org/html/rfc2616), [mySQL](https://www.mysql.com/)

Prerequisites: [Node.js](https://nodejs.org/en/), [npm](https://www.npmjs.com/)
```
$ git clone https://github.com/mezerotm/eco.git
$ cd eco/app/
$ npm install
```
### arduino
This sectoin depends on a knowledge of: [Arduino](https://www.arduino.cc/en/Reference/HomePage), [C++](http://www.cplusplus.com/)

Prerequisites: [Visal Studio Community](https://www.visualstudio.com/vs/community/), [Visual Micro](http://www.visualmicro.com/), [Arduino IDE](https://www.arduino.cc/en/Main/OldSoftwareReleases)

Dependencies: [WiFi101](https://www.arduino.cc/en/Reference/WiFi101), [ArduinoSTL](https://github.com/mike-matera/ArduinoSTL), [Flow Meter](http://diyhacking.com/projects/FlowMeterDIY.ino)

<sub>*Visual Studio & Visual Micro are not required, but recommended to work with C & C++ files</sub>

## Maintainers
- [@mezerotm](https://github.com/mezerotm)
- [@ravenusmc](https://github.com/ravenusmc)
- [@NJTuley](https://github.com/NJTuley)
- [@novasolo17](https://github.com/novasolo17)
- [@hawaiianmoon](https://github.com/hawaiianmoon)

## Contribute
You can [post questions](https://github.com/mezerotm/eco/issues).

Not taking PRs.

## License
CC BY-NC 4.0

[![CC BY-NC 4.0](https://i.creativecommons.org/l/by-nc/4.0/80x15.png)](https://creativecommons.org/licenses/by-nc/4.0/legalcode)
