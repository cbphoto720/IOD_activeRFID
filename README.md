
# IOD_activeRFID
A GUI to help the user track active RFID tags.  In addition to

Active cobble RFID tag GUI for detection, mapping, and data-logging.



# Overview for Survey conducted to find active cobbles
###### End Goal
- arrive at site
- use manual directional antenna + electronic compass / doppler or Adcock array to detect initial signal bearings
  - bearing & RSII information compiled in GUI to give predicted locations of tag
- walk toward predictions with omnidirectional antenna while monitoring RSSI
- program will find location of peak RSSI by instructing user to walk in specific direction
- logged cobble will then be ignored on RSSI bar graph and will be added to a log
- move on to next cobble


###### Simplified
Coin tags have ~40m range, so direction finding unlikely without dir. antenna with high gain.
- walk pattern with omni antenna and prod around when high RSSI is detected


# Version Control
## V1.1
- save to datalog with specific filename
- log cobble button
  - save to new logg
  - hide RSSI
  - mark location on GPSplot

## V1.2
- GPS com port  



# Road Map
- [x] Research Antenna
- [x] test script to read serial data
- [x] log serial data from test script into OUT(date).txt file (use fopen( ,'a') 'a' for append
- [x] configure readserial as a callback function with BytesAvailableFcn.  Then practice using a timer with a callback for logging data in bigger chunks.  (these chunks of history will hold values in memory rather than logging unessesary RSSI values when seraching for a cobble)
- [x] [BytesAvailableFcn](https://www.mathworks.com/help/instrument/bytesavailablefcn.html)
- [x] [timer](https://www.mathworks.com/help/matlab/matlab_prog/use-a-matlab-timer-object.html)
- [x] [switch](https://www.mathworks.com/help/matlab/ref/switch.html)
- [x] intergrate readserial functionality into cobblefinder GUI to plot results
- [x] create a simple export from matlab compiler to check functionality and see if you can measure performance on a toughbook
- [ ] Start logging IG8 GPS with serial read
- [x] Include mapping functionality
- [x] point map north and have it track user with a "snail trail" gps line of previous points.
- [x] color points based on RSSI
- [ ] measure performance on a toughbook!
- [ ] compile all information in a single variable.  Or choose to have tag RSSI recorded separately to find a creative way to store sparse records.  Index this record with a common timestamp to pull GPS data or simply re-write GPS info in RSSI data for performance.
- [x] Next, implement prev tag/next tag to focus bar graph color/RSSIdot display
- [ ] Log GPS serial positions from IG8 (talk to Rob)
- [ ] Start long dist testing by faking data and trying to display it all at once

**Extra features**
- [ ] RSSI signal interpretation and thresholds to ensure fast acquisition of data.
  - when communicating with multiple tags, expect delays (NaN values)
  - periodic drops in signal are expected
  - handle RSSI overfill with a separate timer
- [ ] import coastline
- [ ] For saving data in the same folder as the installed app (But I think matlab automatic directy path is to where app in launched):

<code>files = matlab.apputil.getInstalledAppInfo;\
[path,\~,~] = fileparts(files(1).location)</code>

- [ ] midnight rollover handling

##### 1/28/22
- Work on Antenna data logging and RSSI callback func.  Talk to Brian about caching data for RSSI scatter.
What is the best way to save the data?
- After determining data format, make RSSI bar graph callback & highlight specific bar for prev tag/next tag.
- implement some sort of locking system to your config menu for safety.

##### 2/2/22
RSSI aquired, create new timer function to bar graph RSSI and periodically clear info.  Find best way to sync the clearing with the GPS tag (perhaps clear RSSI the instant it maps it)

##### 2/3/22
RSSI graph working.  Updates in GPStmr loop.  Next step is to slow this update & improve RSSI acquisition.  Only select tags are being registered at any given loop cycle.  May need to implement more timers for RSSI collection and graphing.

##### 2/11/22
- To read bulk output file:
  - read columns of data **[timestamp, Lat , Lon , RSSI]**
  - remove nan values (rows)
- To read flag boolean chart **length(num_tags)** - boolean values to indicate if a cobble has been found
- to read slim output file:
  - read columns **[flag (tagID#), timestamp, Lat, Lon]**

##### 3/30/22
-  work on logging cobble kml and cobble kml import
- should immediately save in case of program crash
- [geospatial table creation](https://www.mathworks.com/help/map/ref/geocrs.html)
- [save geospatial table](https://www.mathworks.com/help/map/create-geospatial-tables.html)

##### 2022-04-04 Feature Goals
- [x] mark cobble button saves datalog to table
- [x] GPS log position
  - Sample GPS line:
  <br><code>$GPGGA,210302.00,3252.02652259,N,11715.11341598,W,1,20,0.7,53.759,M,-35.060,M,,*63
<br> [GMT time, lat, N, lon, W, 1, #satallites, other info, checksum]
  </code>
  - [ ] utilize GPS checksum & numsats
- [x] snail trail fixed size (2hr max or # of entries max)
- [ ] dir-antenna graph with faster refresh rate
- [x] how to handle RSSI histogram refresh
- [ ] default values changed in .txt doc (com ports, display previous cobbles, snail trail timeout, etc..)
- [ ] import table to display previous cobble positions
- [x] ability to delete logged cobbles
- [ ] Turn off RSSIscat should stop logging for performance reasons (perhaps enable a switch once you are getting close)
  - [ ] RSSIscat should only display location of maximum RSSI for each cobble

##### 2022-04-27
- [ ] getexecutabllefolder for deployed app
- [ ] fix cobble log for import functionality (import previous cobble positions)
- [ ] use iG8 and simulate shutdown & reboot
- [ ] process other iG8 information to display to user
- [ ] more antenna visualizations
- [ ] logged cobble plays chime
- [ ] RSSIscat only shows best known position (largest RSSI value location)


# Program Information
#### Global Variables
*No longer applicable to program.  (Reformat to include timer variables as well as program log outuput.*
- Timestamp
- TagID & RSSI (for directional & omni-dir antenna)
- GPS coord
- Flag cobble (value = TagID# that is being flagged)

#### Comment flags
- %flag - an important note
- %speed - a potential improvement
- %stats - code purely to asses the performance of features
- %test - a temporary element
- %debug - facilitate tinkering
- %current - a feature I am CURRENTly working on

#### Files required
- taglist.txt - List of active tag ID #s
- MOPs_SD_County.kml - MOP lines in SD
- MOPelementreducer.m - fcn. to format MOP lines into 1 graphical element

# Questions
- log iG8 time in UTC vs using matlab/computer time
- use checksum from iG8 messages
- display # of satallites/gps quality from iG8?

# Notes
## Data output
- ISO 8601 date formet: **yyyymmddThhmmssZ** (z for UTC time)
## GPS
- [iG8 serial data format $GPGGA](https://docs.novatel.com/OEM7/Content/Logs/GPGGA.htm)

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
    end</code><br>
 - test
 - [matlab appdesigner debugging tutorial](https://www.mathworks.com/matlabcentral/answers/499633-how-to-view-parameter-values-while-debugging-in-app-designer)

### CDF Notes
The common data format NASA standard in data storage.
[CDF guide](https://spdf.gsfc.nasa.gov/pub/software/cdf/doc/cdf380/cdf380ug.pdf).  This is so overkill for this project, but it is very good practice for future formats. [Matlab CDF](https://www.mathworks.com/help/matlab/common-data-format.html)

**Features**
- rVariable - fixed dimensions
- zVariable - save disk space for variables with changing dimensions (recommended)
- Sparse Records (1.4.4) - only save entries instead of pad values (Seems helpful for RSSI, more research)

**too much data**
- Checksum (1.4.6) - Data corruption checking.  (CPU intensive)
