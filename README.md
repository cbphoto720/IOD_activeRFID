
# IOD_activeRFID
A GUI to help the user track active RFID tags.  The program will read serial inputs from an iG8a GPS and an ELA SCIEL-READER-LITE for the 433mhz Yagi antenna.  This serial information is parsed and then displayed to the user through a GPS map as well as a variety of signal strength indicators.

Active cobble RFID tag GUI for detection, mapping, and data-logging.



# Overview for Survey conducted to find active cobbles
###### End Goal
- arrive at site
- use manual directional antenna detect initial signal direction
  - RSSI information compiled in GUI to indicate likely RFID position
- walk toward predictions while monitoring RSSI
- use a signal attenuator during approach to hone in on the position of the tag
- manually log cobble location
- Flagged cobble will then be ignored on RSSI bar graph and its coordinates will be added to a log
- move on to next cobble

# Version Control
## V1.1
- save to datalog with specific filename
- log cobble button
  - save to new logg
  - hide RSSI
  - mark location on GPSplot

## V1.2
- GPS com port

## V2.1
- GUI overhall
- Pcolor plot

## V2.2
- previous cobble position implementation
- more robust time handling
- datalog import tool
- Refine GUI layout

# V2.3
- bug fixes
- Increase framerate stability (UItmr BusyMode='drop')


# Build Information
- 433 MHz Active RFID
  - 15m reliable range (Either inside cobble or bare tag)

## Cobble Casting
### Materials
- [ ] [Masonry Angle grinder Blade](https://www.amazon.com/dp/B00004RH8Y?psc=1&ref=ppx_yo2ov_dt_b_product_details)


##### 2022-05-02
- Brian start casting 1st rock with active RFID tag inside


# Program Information
#### Global Variables
*No longer applicable to program.  (Reformat to include timer variables as well as program log outuput)*
- Timestamp
- TagID & RSSI
- GPS coord
- Flag cobble (value = TagID# that is being flagged)

#### Comment flags
- %flag - an important note
- %speed - a potential improvement
- %stats - code purely to asses the performance of features
- %test - a temporary element
- %debug - facilitate tinkering (broken elements of code)
- %current - a feature I am CURRENTly working on

#### Files required
- taglist.txt - List of active tag ID #s
- MOPs_SD_County.kml - MOP lines in SD
- MOPelementreducer.m - fcn. to format MOP lines into 1 graphical element

# Questions
- [x] log iG8 time in UTC vs using matlab/computer time
  - use UTC
- [x] use checksum from iG8 messages
  - Do not use checksum
- [x] display # of satallites/gps quality from iG8?
  - Not required

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
### Publish to Toughpad
- stop debug mode
- disable addpath string

### Markdown
- [Markdown syntax cheat sheet](https://daringfireball.net/projects/markdown/syntax#img)
- [Markdown demo 2 (easier to visualize)](https://markdown-it.github.io/)


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

# References
- The Scientific colour map lajolla (Crameri 2018) is used in
this study to prevent visual distortion of the data and exclusion of
readers with colour-vision deficiencies (Crameri et al., 2020).
