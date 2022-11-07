# Publishing code:

- turn off developer mode
- turn of folder dependancies
- disable GPS bypass switch?

# Journal
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
- [x] measure performance on a toughbook!
- [x] compile all information in a single variable.  Or choose to have tag RSSI recorded separately to find a creative way to store sparse records.  Index this record with a common timestamp to pull GPS data or simply re-write GPS info in RSSI data for performance.
- [x] Next, implement prev tag/next tag to focus bar graph color/RSSIdot display
- [x] Log GPS serial positions from IG8 (talk to Rob)
- [x] Start long dist testing by faking data and trying to display it all at once

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
- [x] how to handle RSSI histogram refresh
- [ ] default values changed in .txt doc (com ports, display previous cobbles, snail trail timeout, etc..)
- [ ] import table to display previous cobble positions
- [x] ability to delete logged cobbles
- [x] Turn off RSSIscat should stop logging for performance reasons (perhaps enable a switch once you are getting close)
  - [x] RSSIscat should only display location of maximum RSSI for each cobble

##### 2022-04-27
- [ ] getexecutabllefolder for deployed app
- [ ] fix cobble log for import functionality (import previous cobble positions)
- [ ] use iG8 and simulate shutdown & reboot
- [ ] process other iG8 information to display to user
- [x] more antenna visualizations
- [ ] logged cobble plays chime
- [x] RSSIscat only shows best known position (largest RSSI value location)

##### 2022-07-14
- [x] pcolor time series
  - pcolor fixed color scale (with colorbar)
  - la jolla color map
  - **! Colorbar is not fixed!  Color is scaling despite limits being set**
- [x] antenna plots on same page as GPS
- [x] Yagi plt fixed y-axis
- [x] import previous cobble positions
- [x] midnight rollover handling

# App development lessons:
- K.I.S.S.
  - only necessary code first and then add features
  - the faster it is fully working, the more targeted you changes will be due to actual testing rather than dreaming up problems and ideas at the computer.
- default values stored in .txt doc (com ports, display previous cobbles, snail trail timeout, etc..)
  - promotes easily-configurable options
  - streamlines program clarity and Features
- functions to perform tasks should be external (calculate data first, then run a separate function that purely refreshes UI information)
  - helps with code clarity and lends itself to easier modification
  - also helps with project delegation
  - helps with debugging -> find where program is hung up
