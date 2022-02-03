
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
- [x] Include mapping functionality
- [x] point map north and have it track user with a "snail trail" gps line of previous points.
- [ ] color points based on RSSI
- [ ] read OUT(date).txt to create a single point with colored RSSI intenstiy, log many points to create a map (use timestamp to sync with GPS, or use another serial read to grab position)
- [ ] Use short range omnidirectional DIY coil antenna for low power signal  to get minimal signal unless close to tag
- [ ] display message "tracking cobble ID: XXXXX" once signal has been high for some criteria, Map display pcolor of signal strength.  (average signal over area and gps coord)

##### 1/28/22
- Work on Antenna data logging and RSSI callback func.  Talk to Brian about caching data for RSSI scatter.
What is the best way to save the data?
- After determining data format, make RSSI bar graph callback & highlight specific bar for prev tag/next tag.
- implement some sort of locking system to your config menu for safety.

##### 2/2/22
- RSSI aquired, create new timer function to bar graph RSSI and periodically clear info.  Find best way to sync the clearing with the GPS tag (perhaps clear RSSI the instant it maps it)

##### 2/3/22
- RSSI graph working.  Updates in GPStmr loop.  Next step is to slow this update & improve RSSI acquisition.  Only select tags are being registered at any given loop cycle.  May need to implement more timers for RSSI collection and graphing.  (time dependent GPS sync?)


##### other features
 - [x] COM port dropdown selection
 - [x] import MOP line
 - [ ] import coastline
 - [ ] For saving data in the same folder as the installed app:

<code>files = matlab.apputil.getInstalledAppInfo;\
[path,\~,~] = fileparts(files(1).location)</code>

 - [ ] midnight rollover handling
 - [ ] continuous log of RSSI will only display heatmap for 1 tag at a time, but data will be recorded for any signal received



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


## Antennas
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
 - [strcmp(A , B)]() a faster version of find() to compare string to a cell { }


 - [Pause vs Timer](https://www.mathworks.com/matlabcentral/answers/83271-pause-n-vs-timer-which-is-better) - Good explanation of matlabs fake "multithreading" with a timerfcn vs using a while loop.  Also a great method to save compute time by not re-running plot commands but instead only updating data in handles.
 - [AppDesigner TmrFcn]() - Correct order of function arguments:  
    <code>function example(app, obj, event, string_arg)  
    &nbsp;&nbsp;&nbsp; ... do stuff \
    end</code>

### CDF Notes
The common data format NASA standard in data storage.
[CDF guide](https://spdf.gsfc.nasa.gov/pub/software/cdf/doc/cdf380/cdf380ug.pdf).  This is so overkill for this project, but it is very good practice for future formats. [Matlab CDF](https://www.mathworks.com/help/matlab/common-data-format.html)

**Features**
- rVariable - fixed dimensions
- zVariable - save disk space for variables with changing dimensions (recommended)
- Sparse Records (1.4.4) - only save entries instead of pad values (Seems helpful for RSSI, more research)

**too much data**
- Checksum (1.4.6) - Data corruption checking.  (CPU intensive)
