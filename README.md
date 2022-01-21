
# IOD_activeRFID
A GUI to help the user track active RFID tags.  In addition to

Active cobble RFID tag GUI for detection, mapping, and data-logging.



# Road Map
- [x] Research Antenna
- [x] test script to read serial data
- [x] log serial data from test script into OUT(date).txt file (use fopen( ,'a') 'a' for append
- [ ] configure readserial as a callback function with BytesAvailableFcn.  Then practice using a timer with a callback for logging data in bigger chunks.  (these chunks of history will hold values in memory rather than logging unessesary RSSI values when seraching for a cobble)
- [ ] [BytesAvailableFcn](https://www.mathworks.com/help/instrument/bytesavailablefcn.html)
- [ ] [timer](https://www.mathworks.com/help/matlab/matlab_prog/use-a-matlab-timer-object.html)
- [ ] [switch](https://www.mathworks.com/help/matlab/ref/switch.html)
- [ ] intergrate readserial functionality into cobblefinder GUI to plot results
- [ ] create a simple export from matlab compiler to check functionality and see if you can measure performance on a toughbook

##### Next Phase -> Intergrate GPS
- [ ] Start logging inreach GPS chip with serial read
- [ ] Includ mapping functionality
- [ ] point map north and have it track user with a "snail trail" gps line of previous points.  (color points based on RSSI for easy mapping start)
- [ ] read OUT(date).txt to create a single point with colored RSSI intenstiy, log many points to create a map (use timestamp to sync with GPS, or use another serial read to grab position)
- [ ] Use short range omnidirectional DIY coil antenna for low power signal  to get minimal signal unless close to tag
- [ ] display message "tracking cobble ID: XXXXX" once signal has been high for some criteria, Map display pcolor of signal strength.  (average signal over area and gps coord)

##### other features
 - [ ] COM port dropdown selection
 - [ ] import MOP line or coastline
 - [ ] navigation map using mapping toolbox
 - [ ] For saving data in the same folder as the installed app:

<code>files = matlab.apputil.getInstalledAppInfo;\
[path,\~,~] = fileparts(files(1).location)</code>

 - [ ] midnight rollover handling
 - [ ] continuous log of RSSI will only display heatmap for 1 tag at a time, but data will be recorded for any signal recieved



# Variables Tree
#### Global Variables
- Timestamp
- TagID & RSSI (for directional & omni-dir antenna)
- GPS coord
- Flag index {length(num_tags)}
    - Boolean values that notate recorded cobbles

#### Comment flags
- %flag - an important note
- %speed - a potential improvement
- %stats - code purely to asses the performance of other features
- %test - a temporary element



# Notes
## Questions for Brian
- [ ] 1/10/22 in test.m, your callback functions update a global variable.  Is this a product of using a callback function on the BytesAvailableFcn or is there more to it?



# Antennas
A great overview of [Antenna basics](https://www.antenna-theory.com/basics/main.php)
and the [The Friis Equation](https://www.antenna-theory.com/basics/friis.php)

##### Starting hardware
 - [Antenna from Brian](https://elainnovation.com/wp-content/uploads/2021/01/FP-SLENDERIII-02C-EN.pdf) 6W max
    - Max RSI detected with Slender III antenna: 180
 - [Active RFID coin tag](https://gaorfid.com/product/433mhz-coin-id-active-rfid-tag/)

#### Antenna research
Many of the directional 433 MHz antenna I have found are oriented toward high power, long range communication.  Almost all are very large and 300W max.
- [OSCAR44/0.3M/NTYPEF/S/S/17](https://www.digikey.com/en/products/detail/siretta-ltd/OSCAR44-0-3M-NTYPEF-S-S-17/14312651) 100W max Yagi
- [YS4065](https://www.mouser.com/ProductDetail/Laird-Connectivity/YS4065?qs=EU6FO9ffTweelPAbWW8Qfg==) 300W max Yagi

DIY options
 - [DIY 433 MHz Directional antenna](https://www.instructables.com/433-MHz-tape-measure-antenna-suits-UHF-transmitte/) small, directional "tape measurer antenna"
 - [DIY mini 433 MHz Omni-Directional antenna](https://www.instructables.com/433-MHz-Coil-loaded-antenna/) inexpensive, low power omnidirectional

# Code
### Markdown
- [Markdown syntax cheat sheet](https://daringfireball.net/projects/markdown/syntax#img)


### Matlab
 - [fopen](https://www.mathworks.com/help/matlab/ref/fopen.html?searchHighlight=fopen&s_tid=srchtitle_fopen_1) read files
 - [fclose](https://www.mathworks.com/help/matlab/ref/fclose.html) close file or serial obj
 - [fscanf](https://www.mathworks.com/help/matlab/ref/fscanf.html) read data from files
 - [serialportlist](https://www.mathworks.com/help/matlab/ref/serialportlist.html#d123e1295884) serialportlist("available")=open ports
