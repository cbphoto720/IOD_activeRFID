
# IOD_activeRFID
A GUI to help the user track active RFID tags.  In addition to 

Active cobble RFID tag GUI for detection, mapping, and data-logging.

# Road Map
- [x] Research Antenna
- [x] test script to read serial data
- [ ] log serial data from test script into OUT(date).txt file (use fopen( ,'a') 'a' for append
- [ ] read OUT(date).txt to create pcolor map (use timestamp to sync with GPS, or use another serial read to grab position)
- [ ] Use short range omnidirectional DIY coil antenna for low power signal  to get minimal signal unless close to tag
- [ ] display message "tracking cobble ID: XXXXX" once signal has been high for some criteria, Map display pcolor of signal strength.  (average signal over area and gps coord)
#### other features
 - [ ] COM port dropdown selection
 - [ ] import MOP line or coastline
 - [ ] navigation map using mapping toolbox
 - [ ] For saving data in the same folder as the installed app:
    <code>files = matlab.apputil.getInstalledAppInfo;
    [path,~,~] = fileparts(files(1).location)</code>

# Notes
## Properties
Max RSI detected with Slender III antenna: 180

## Antennas
A great overview of [Antenna basics](https://www.antenna-theory.com/basics/main.php)
- [The Friis Equation](https://www.antenna-theory.com/basics/friis.php)
- 
**Starting hardware**
 - [Antenna from Brian](https://elainnovation.com/wp-content/uploads/2021/01/FP-SLENDERIII-02C-EN.pdf) 6W max
 - [Active RFID coin tag](https://gaorfid.com/product/433mhz-coin-id-active-rfid-tag/)

### Antenna research
Many of the directional 433 MHz antenna I have found are oriented toward high power, long range communication.  Almost all are very large and 300W max.
 - [OSCAR44/0.3M/NTYPEF/S/S/17](https://www.digikey.com/en/products/detail/siretta-ltd/OSCAR44-0-3M-NTYPEF-S-S-17/14312651) 100W max Yagi
- [YS4065](https://www.mouser.com/ProductDetail/Laird-Connectivity/YS4065?qs=EU6FO9ffTweelPAbWW8Qfg==) 300W max Yagi 

**DIY options**
 - [DIY 433 MHz Directional antenna](https://www.instructables.com/433-MHz-tape-measure-antenna-suits-UHF-transmitte/) small, directional "tape measurer antenna"
 - [DIY mini 433 MHz Omni-Directional antenna](https://www.instructables.com/433-MHz-Coil-loaded-antenna/) inexpensive, low power omnidirectional

# Code
### Markdown
- [Syntax](https://daringfireball.net/projects/markdown/syntax#img)
'this is a test'

### Matlab
 - [fopen](https://www.mathworks.com/help/matlab/ref/fopen.html?searchHighlight=fopen&s_tid=srchtitle_fopen_1) read files
 - [fclose](https://www.mathworks.com/help/matlab/ref/fclose.html) close file or serial obj
 - [fscanf](https://www.mathworks.com/help/matlab/ref/fscanf.html) read data from files
 - geodensityplot
 - [serialportlist](https://www.mathworks.com/help/matlab/ref/serialportlist.html#d123e1295884) serialportlist("available")=open ports
