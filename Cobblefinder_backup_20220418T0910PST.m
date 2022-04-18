classdef Cobblefinder < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                    matlab.ui.Figure
        GridLayout                  matlab.ui.container.GridLayout
        GridLayout7                 matlab.ui.container.GridLayout
        RefreshButton               matlab.ui.control.Button
        UImssg                      matlab.ui.control.Label
        LogCobbleButton             matlab.ui.control.Button
        TabGroup                    matlab.ui.container.TabGroup
        ControlsTab                 matlab.ui.container.Tab
        GridLayout2                 matlab.ui.container.GridLayout
        GridLayout8                 matlab.ui.container.GridLayout
        GPSCOMLabel_2               matlab.ui.control.Label
        GPSCOMLamp_2                matlab.ui.control.Lamp
        AntennaLabel                matlab.ui.control.Label
        AntennaCOMLamp_2            matlab.ui.control.Lamp
        LoggingLabel                matlab.ui.control.Label
        LoggingLamp                 matlab.ui.control.Lamp
        TagSlider                   matlab.ui.control.Slider
        TagSliderLabel              matlab.ui.control.Label
        TagIDLabel                  matlab.ui.control.Label
        PrevioustagButton           matlab.ui.control.Button
        NexttagButton               matlab.ui.control.Button
        RSSIAxes                    matlab.ui.control.UIAxes
        DatalogTab                  matlab.ui.container.Tab
        GridLayout3                 matlab.ui.container.GridLayout
        ConsoleOutputTextArea       matlab.ui.control.TextArea
        ConsoleOutputTextAreaLabel  matlab.ui.control.Label
        UITable                     matlab.ui.control.Table
        TESTINGTab                  matlab.ui.container.Tab
        GridLayout6                 matlab.ui.container.GridLayout
        WalkSwitch                  matlab.ui.control.Switch
        WalkSwitchLabel             matlab.ui.control.Label
        HeadingKnob                 matlab.ui.control.Knob
        HeadingKnobLabel            matlab.ui.control.Label
        ConfigureTab                matlab.ui.container.Tab
        GridLayout4                 matlab.ui.container.GridLayout
        GridLayout5                 matlab.ui.container.GridLayout
        RSSIdotsCheckBox            matlab.ui.control.CheckBox
        ZoomRadiusmDropDownLabel    matlab.ui.control.Label
        ZoomRadiusmDropDown         matlab.ui.control.DropDown
        SnailtrailsCheckBox         matlab.ui.control.CheckBox
        MoplinesCheckBox            matlab.ui.control.CheckBox
        UISwitch                    matlab.ui.control.Switch
        UISwitchLabel               matlab.ui.control.Label
        UILamp                      matlab.ui.control.Lamp
        GPSCOMListBox               matlab.ui.control.ListBox
        GPSCOMSwitch                matlab.ui.control.Switch
        GPSCOMSwitchLabel           matlab.ui.control.Label
        GPSCOMLamp                  matlab.ui.control.Lamp
        AntennaCOMListBox           matlab.ui.control.ListBox
        AntennaCOMSwitch            matlab.ui.control.Switch
        AntennaCOMSwitchLabel       matlab.ui.control.Label
        AntennaCOMLamp              matlab.ui.control.Lamp
        GPSAxes                     matlab.ui.control.UIAxes
    end

    
    properties (Access = private)      
        % General variables
        DSP % stuct containing boolean vars to enable display  of GUI features
        datalog % struct containing vars to save the data

        % Timers (and their associated variables)
        % __________
        antCOMtmr % Antenna data aquisition

        antenna % Serial obj
        antCOM % COM#
%         gps % serial obj
%         gpsCOM % COM
        taglist % hex list of aRFID tags to listen for
        numtags % length(taglist)
        tagflags % length(taglist) - boolean values for flagged tags
        RSSI % Signal strength
        
        % __________
        uitmr

        GPScord % GPS position
        MOPlat % MOP Latitudes seperated by NaN values
        MOPlon % MOP longitudes seperated by NaN values
        snail % Snail trail data
        GPSplot % GPS plot struct
        mapoffset % Zoom scale (in degrees)
        RSSIscat % Scatterplot signal strength data
        tagfocus % highlight RSSI and show scatterplot of this tag index

        % __________
        wlktmr %test %debug

        heading % Direction to walk

        % __________
        % minitmrs (singleshot)
        refreshtmr % a singleShot timer to run UIupdate 1 time
        UIdispmssg % display a message to the user
    end
    
    methods (Access = private)     
        %% UI Update
        function UIupdate(app,src,~,~) %(app, obj, event, string_arg)
            tic %stats
            % callback function for uitmr to update screen elements

            % 'snail' - display snail trails (previous GPS line)
            if app.DSP.snail
                app.snail(end+1,:)=app.GPScord;
                set(app.GPSplot.snail,'XData',app.snail(:,2),'YData',app.snail(:,1))
            else
                set(app.GPSplot.snail,'XData',[],'YData',[])
            end

            % Log RSSI 
            if ~app.datalog.refresh % check for user refresh
                app.RSSIscat(end+1,:)=[app.GPScord(1),app.GPScord(2),app.RSSI']; %flag - collecting RSSI data regardless of RSSIdots setting (turn off antenna COM to disable collection)
                if app.DSP.RSSIdots % (display signal strength at GPS coordinate)
                    set(app.GPSplot.RSSIdot,'Xdata',app.RSSIscat(:,2),'Ydata',app.RSSIscat(:,1),'SizeData',app.RSSIscat(:,app.tagfocus+2)+1); %.^1.5 exponent factor for short range testing
                end
            end
            % RSSI bar graph
%             set(app.GPSplot.RSSI2,'XData',[1:1:app.numtags],'YData',app.RSSIscat(end-1,3:end)); %'ghost' RSSI from previous sample to help slow refresh rate of bar graph
            % ^ only required when many tags are being detected in 1 period
            set(app.GPSplot.RSSI,'XData',[1:1:app.numtags],'YData',app.RSSI);
%             app.GPSplot.RSSI2.YData(app.tagflags) = repmat(160,sum(app.tagflags,'all'),1);
            app.GPSplot.RSSI.YData(app.tagflags) = repmat(160,sum(app.tagflags,'all'),1);
            app.RSSI(:)=0; %test

%             app.GPSplot.RSSI2.CData(:,:) = repmat([0, 0.4470, 0.7410],app.numtags,1); %test
            app.GPSplot.RSSI.CData(:,:) = repmat([0.2, 0.5, 0.7410].*1.2,app.numtags,1); %test set all to blue

%             app.GPSplot.RSSI2.CData(app.tagflags,:) = repmat([0.4660, 0.6740, 0.1880],sum(app.tagflags,'all'),1); %flagged tags
            app.GPSplot.RSSI.CData(app.tagflags,:) = repmat([0.4660, 0.6740, 0.1880],sum(app.tagflags,'all'),1); %flagged tags

            app.GPSplot.RSSI.CData(app.tagfocus,:) = [0.8500, 0.3250, 0.0980]; % highlight in orange

            % Set map limits
            lat=[app.GPScord(1)-app.mapoffset,app.GPScord(1)+app.mapoffset];
            lon=[app.GPScord(2)-app.mapoffset,app.GPScord(2)+app.mapoffset];
            ylim(app.GPSAxes,lat)
            xlim(app.GPSAxes,lon)

            % Plot GPS cord
            set(app.GPSplot.Xmarker,'XData',app.GPScord(2),'YData',app.GPScord(1))
            set(app.GPSplot.Omarker,'XData',app.GPScord(2),'YData',app.GPScord(1))

            % Enable GPS lamp
            taskEx = get(src,'TasksExecuted');
            if mod(taskEx,2)
                app.UILamp.Enable='on';
                app.UILamp.Color='g';
            else
                app.UILamp.Enable='off';
            end
            % Transfer lamp status to main page
%             app.AntennaCOMLamp_2.Enable=app.AntennaCOMLamp.Enable;
            app.AntennaCOMLamp_2.Color=app.AntennaCOMLamp.Color;

%             app.UITable.Data=app.RSSIscat; %test - display datalog in
%             UItable.  (should only display logged cobbles)

            % Saving datalog
            if ~app.datalog.refresh % user did NOT Refresh
                writematrix(app.RSSIscat(end,:),app.datalog.filepath,'Delimiter',',','WriteMode','append'); %flag extremely basic data log implimentation
                % readability improved by creating column headings in startup code
                app.LoggingLamp.Color='g';
                
                % alternate lamp state
                if mod(taskEx,2)
                    app.LoggingLamp.Enable='on';
                    app.LoggingLamp.Color='g';
                else
                    app.LoggingLamp.Enable='off';
                end
                app.LoggingLabel.Text='logging!';
            else % user DID refresh
                app.datalog.refresh=false;
                app.LoggingLamp.Color='r';
                app.LoggingLamp.Enable='off';
                app.LoggingLabel.Text='NOT logging';
            end

%             scroll(app.ConsoleOutputTextArea, 'bottom')
%             scroll(app.UITable, 'bottom')

            drawnow limitrate; %limitrate critical (improves stability)

%             % play sound
%             dur=0.1;
%             [a,~]=playchime(300,dur);
%             [b,fs]=playchime(500,dur);
%             [c,fs]=playchime(700,dur);
%             [d,fs]=playchime(900,dur*0.9);
%             
%             sound([c,d],fs)

            toc %stats
        end


        %% walking test
        function walktest(app,~,~,~)
            %test that spoofs GPS coordinates to test UIupdate

            walkspeed=5.3666e-07*1; % deg/s **See Testcars.m for calc (Lat/Lon to meters)

            app.GPScord(1)=app.GPScord(1)-(walkspeed*cosd(app.heading));
            app.GPScord(2)=app.GPScord(2)-(walkspeed*sind(app.heading));
        end


        %% lat2meters
        function degrees=meters2GPS(~,Lat,meters)
            lat_m=111e3;
            m2gps=lat_m*cosd(Lat);

            degrees=meters/m2gps;            
        end

        %% Antenna Data Aquisition
        function readant(app,src,~,~)
            a=readline(src);
            a=a{1}(2:end);
            
            % Interpret Serial & output data
            RSSI_OFFSET=255;

            [A,num_elements] = sscanf(a,'%2x%6x01',2); % parse hex to RSI & tag ID
            index = A(2) - app.taglist(1) + 1; %matlab arrays are one based,not zero based
            if num_elements==2 && index <= app.numtags && index > 0
                app.RSSI(index)=RSSI_OFFSET-A(1);
            end
        end

        %% Update taglabel
        function updatetaglabel(app)
            text = sprintf('Tag ID: %d\n(Tag # %d)',app.taglist(app.tagfocus),app.tagfocus);
            app.TagIDLabel.Text=text;
        end

        %% Set Refresh State
         function setrefreshstate(app,src,~,~)
            app.datalog.refresh=true;
         end

         %% Console mssg log
         function consolemssg(app,src,~,~)
            app.ConsoleOutputTextArea.Value=[app.ConsoleOutputTextArea.Value; datestr(datetime('now')), '>> ', app.UImssg.UserData];
            app.UImssg.Visible=true;
         end

         %% UI mssg fade
         function UImssgfade(app,src,~,~)
            app.UImssg.Visible=false;
            app.UImssg.Text='';
            app.UImssg.UserData='';
         end

         %% Tell user fcn
         function telluser(app,mssg,dsp)
             % show user a UImssg (dsp=true) or log to console (dsp=false)
            arguments
                app
                mssg
                dsp (1,1) logical
            end
            
            if isequal(get(app.UIdispmssg,'Running'),'on')
                stop(app.UIdispmssg);
            end
            if dsp
                app.UImssg.Text=mssg;
                app.UImssg.UserData=mssg;
            else
                app.UImssg.UserData=mssg;
            end
            start(app.UIdispmssg);
         end
    end
    

    % Callbacks that handle component events
    methods (Access = private)

        % Code that executes after component creation
        function startupFcn(app)
            % Layout parameters
            debug=true; %enter debug mode (CTRL+F "if debug")
            if debug
                app.UIFigure.WindowState='normal'
                dbstop if error
            else
                app.UIFigure.WindowState='maximized'
            end
            app.UIFigure.Units="normalized"

            % Check Standalone app
            if isdeployed
                % code specific to deployment
            else
                addpath(genpath('C:\Users\ccblack\Documents\Carson\Projects\IOD_activeRFID')) % ensure required files are passed with the compiler
            end

            %% Startup Code
            app.DSP=struct('snail',app.SnailtrailsCheckBox.Value,...
                'mop',app.MoplinesCheckBox.Value,...
                'RSSIdots',app.RSSIdotsCheckBox.Value);
            app.heading = app.HeadingKnob.Value;

            % Fix GUI elements
            app.AntennaCOMListBox.Items=cellstr(serialportlist('all'));
            app.AntennaCOMListBox.Value={}; %flag - replace with default COM value

            app.GPSCOMListBox.Items=cellstr(serialportlist('all'));
            app.GPSCOMListBox.Value={}; %flag - replace with default COM value


            % RSSI
            % Import tag list
            [fid, msg]=fopen('taglist.txt','r');
            if fid < 0
                error('Failed to open file "%s" because: "%s"', filename, msg);
            end
            C = textscan(fid,'%s');
            app.taglist = hex2dec(C{1}); % aquire tag IDs
            fclose(fid);
            app.numtags=length(app.taglist); % # of tags tracking
            app.RSSI = zeros(app.numtags,1); % Initialize RSSI to zeros
            app.tagflags=logical(~ones(app.numtags,1)); % Initialize tagflags to FALSE
            
            app.tagfocus=app.TagSlider.Value;
            text = sprintf('Tag ID: %d\n(Tag # %d)',app.taglist(app.tagfocus),app.tagfocus);
            app.TagIDLabel.Text=text;
            app.TagSlider.Limits=[1 app.numtags];


            %  KMl
            [app.MOPlon,app.MOPlat]=MOPelementreducer('MOPs_SD_County.kml'); % Load MOP lines
            app.GPScord=[32.927981236100734, -117.25985543852305]; %[Lat, Lon] %test -Fix static GPS cord
            app.mapoffset= meters2GPS(app,app.GPScord(1),str2double(app.ZoomRadiusmDropDown.Value));
            app.snail=app.GPScord; % Initialize snail trail
            app.snail(end+1,:)=[nan,nan]; % prevent any "snail jumps"


            % _____ Initialize graphs _____
            app.GPSplot=struct('Xmarker',{scatter(app.GPSAxes,[],[])},...
                'Omarker',{scatter(app.GPSAxes,[],[])},...
                'MOP',{plot(app.GPSAxes,[],[])},...
                'snail',{plot(app.GPSAxes,[],[])},...
                'RSSIdot',{scatter(app.GPSAxes,[],[])},...
                'RSSI',{bar(app.RSSIAxes,[])});
%             app.GPSplot.RSSI2=bar(app.RSSIAxes,[]); %RSSI2

            % RSSI histogram bar graph
%             app.GPSplot.RSSI2=bar(app.RSSIAxes,app.taglist,app.RSSI); %RSSI2
%             app.GPSplot.RSSI2.FaceColor = 'flat';
            hold(app.RSSIAxes,"on")
            app.GPSplot.RSSI=bar(app.RSSIAxes,app.taglist,app.RSSI);
            app.GPSplot.RSSI.FaceColor = 'flat';
            ylim(app.RSSIAxes,[0 160])

            % GPS plot
            app.GPSplot.Xmarker= scatter(app.GPSAxes,app.GPScord(2),app.GPScord(1),200,'blue','x','LineWidth',1); % Position marker
            hold(app.GPSAxes,'on')
            app.GPSplot.Omarker= scatter(app.GPSAxes,app.GPScord(2),app.GPScord(1),200,'blue','o','LineWidth',1); % Position marker

            % 'mop' - display mop lines
            if app.DSP.mop
                app.GPSplot.MOP=plot(app.GPSAxes,app.MOPlon,app.MOPlat,'red');
            end

            % 'snail' - display snail trails (previous GPS line)
            if app.DSP.snail
                app.snail(end+1,:)=app.GPScord;
                app.GPSplot.snail=plot(app.GPSAxes,app.snail(:,2),app.snail(:,1),'green');
            end

            % 'RSSI dots' - signal strength indicators tied to GPS pos.
            app.RSSIscat=ones(1,2+app.numtags);
            app.RSSIscat(1:2)=app.GPScord;
            app.GPSplot.RSSIdot= scatter(app.GPSAxes,app.RSSIscat(2),app.RSSIscat(1),app.RSSIscat(3),[0.8500, 0.3250, 0.0980],'o','LineWidth',0.5);

            %% Datalog startup
            app.datalog=struct('filename',[datestr(datetime('now'),'yyyymmdd'),'_aRFIDcobbleLog'],... %current
                'refresh',false,...
                'foldername','data',...
                'filepath',fullfile('data',[datestr(datetime('now'),'yyyymmdd'),'_aRFIDcobbleLog']));
            mkdir(app.datalog.foldername);
%             Definition of RSSIscat:
%             app.RSSIscat(end+1,:)=[app.GPScord(1),app.GPScord(2),app.RSSI'];
            datalogheadder=sprintf('Lat,Lon,RSSI(%d-%d) %d',1,app.numtags,app.taglist); %test - test header (should really use a CDF file
            writematrix(datalogheadder,app.datalog.filepath,'Delimiter',',','WriteMode','append');

            %% Startup timers (DO THIS LAST)
            pause(0.5) % ensure proper loading

            % refresh timer (singleshot)
            app.refreshtmr=timer('ExecutionMode','singleShot',...
                'StartFcn',{@app.setrefreshstate,app},...
                'TimerFcn',{@app.UIupdate,app});

            % console message timer
            app.UIdispmssg=timer('ExecutionMode','singleShot',...
                'StartFcn',{@app.consolemssg,app},...
                'StartDelay',2,...
                'TimerFcn',{@app.UImssgfade,app});
            
            %GPS timer
            app.uitmr=timer('ExecutionMode', 'FixedRate', 'Period', 1, ...
                'TimerFcn', {@app.UIupdate,app}, ...
                'StartFcn',"disp('start UI timer')",...
                'StopFcn',"disp('stop UI timer')",...
                'ErrorFcn',"disp('UI timer erorr!')");
            start(app.uitmr)

            % Walk timer %test
            app.wlktmr=timer('ExecutionMode', 'FixedRate', 'Period', 0.05, ...
                        'TimerFcn', {@app.walktest,app}, ...
                        'StartFcn',"disp('start walk timer')",...
                        'StopFcn',"disp('stop walk timer')",...
                        'ErrorFcn',"disp('Walk timer erorr!')");

            %% Debug startup

            %flag - Only allowed user actions are permitted below this
            %line, variable definitions should be assigned before timer
            %functions start.

            if debug
                % Start RSSI plotting (connect to atenna with known port)
                if ismember("COM4",serialportlist('available'))
                    app.AntennaCOMListBox.Value="COM4";
                    app.AntennaCOMSwitch.Value="On";
                    AntennaCOMListBoxValueChanged(app);
                    AntennaCOMSwitchValueChanged(app);
                end

                % set Zoom
                app.ZoomRadiusmDropDown.Value="50";
                ZoomRadiusmDropDownValueChanged(app);

                % Start wlktmr
                app.WalkSwitch.Value='On';
                WalkSwitchValueChanged(app);
            end


            % do not put anything below this line 
            % (account for all variables before starting timers)

        end

        % Close request function: UIFigure
        function UIFigureCloseRequest(app, event)
            stop(timerfind) % stop all timers
            delete(timerfind) % delete all timers
            try
                delete(app.antCOM) % attempt to delete
                delete(app)
            catch ME
                disp('unable to properly close antenna COM')
                error(ME.identifier)
            end
        end

        % Button pushed function: RefreshButton
        function RefreshButtonPushed(app, event)
            a=get(app.uitmr,'Running');

            if isequal(a,'off')
                UISwitchValueChanged(app)
            end

            antCOMvalue = app.AntennaCOMSwitch.Value;
            switch antCOMvalue
                case 'On'

                case 'Off'
                    % Refresh list of available COM ports
                    app.AntennaCOMListBox.Items=cellstr(serialportlist('all'));
                    app.AntennaCOMListBox.Value={}; %flag - replace with default COM value
                    telluser(app,'Reset Antenna COM ports',true)
            end
        end

        % Value changed function: AntennaCOMListBox
        function AntennaCOMListBoxValueChanged(app, event)
            app.antCOM = app.AntennaCOMListBox.Value;
            app.AntennaCOMSwitch.Enable='on';
        end

        % Value changed function: AntennaCOMSwitch
        function AntennaCOMSwitchValueChanged(app, event)
            value = app.AntennaCOMSwitch.Value;
            switch value
                case 'On'
                    % Configure Serial
                    if any(strcmp(serialportlist('available'),app.antCOM))
                        app.antenna=serialport(app.antCOM,9600);
                        configureTerminator(app.antenna,93); % 93 ascii = ']'
                        configureCallback(app.antenna,"terminator",@app.readant);
                    else
                        error('Antenna COM port not available (%s)',app.antCOM);
                    end
                    
                    app.AntennaCOMLamp.Enable='on';
                    app.AntennaCOMLamp.Color='g';
                    app.AntennaCOMListBox.Enable='off';
                case 'Off'
                    delete(app.antenna);
                    
                    app.AntennaCOMLamp.Enable='off';
                    app.AntennaCOMLamp.Color='r';
                    app.AntennaCOMListBox.Enable='on';
            end
        end

        % Value changed function: UISwitch
        function UISwitchValueChanged(app, event)
            value = app.UISwitch.Value;
            app.snail(end+1,:)=[nan,nan];
            switch value
                case 'On'
                    app.RSSI(:)=0; % clear any rollover RSSI that was collected while UI and GPS were off
                    start(app.uitmr)
                    app.UILamp.Enable='on';
                    app.UILamp.Color='g';
                case 'Off'
                    stop(app.uitmr)
                    start(app.refreshtmr); % run a singleshot to turn off datalog
                    app.UILamp.Enable='off';
                    app.UILamp.Color='r';
            end
        end

        % Value changed function: SnailtrailsCheckBox
        function SnailtrailsCheckBoxValueChanged(app, event)
            app.DSP.snail=app.SnailtrailsCheckBox.Value;
            app.snail(end+1,:)=[nan,nan];

            if app.DSP.snail
                set(app.GPSplot.snail,'XData',app.RSSIscat(:,2),'YData',app.RSSIscat(:,1));
            else
                set(app.GPSplot.snail,'XData',[],'YData',[]);
            end
        end

        % Value changed function: MoplinesCheckBox
        function MoplinesCheckBoxValueChanged(app, event)
            app.DSP.mop=app.MoplinesCheckBox.Value;

            if app.DSP.mop
                set(app.GPSplot.MOP,'XData',app.MOPlon,'YData',app.MOPlat);
            else
                set(app.GPSplot.MOP,'XData',[],'YData',[]);
            end
        end

        % Value changed function: RSSIdotsCheckBox
        function RSSIdotsCheckBoxValueChanged(app, event)
           app.DSP.RSSIdots=app.RSSIdotsCheckBox.Value;

           if app.DSP.RSSIdots
                set(app.GPSplot.RSSIdot,'Xdata',app.RSSIscat(:,2),'Ydata',app.RSSIscat(:,1),'SizeData',app.RSSIscat(:,app.tagfocus+2)+1);
            else
                set(app.GPSplot.RSSIdot,'XData',[],'YData',[],'SizeData',[]);
            end
        end

        % Value changed function: ZoomRadiusmDropDown
        function ZoomRadiusmDropDownValueChanged(app, event)
            app.mapoffset= meters2GPS(app,app.GPScord(1),str2double(app.ZoomRadiusmDropDown.Value)/2);
            drawnow
        end

        % Value changed function: WalkSwitch
        function WalkSwitchValueChanged(app, event)
            value = app.WalkSwitch.Value;
            switch value
                case 'On'
                    start(app.wlktmr)
                case 'Off'
                    stop(app.wlktmr)
            end
        end

        % Value changed function: HeadingKnob
        function HeadingKnobValueChanged(app, event)
            app.heading = app.HeadingKnob.Value;
        end

        % Button pushed function: NexttagButton
        function NexttagButtonPushed(app, event)
            if app.tagfocus==app.numtags
                app.tagfocus=1;
            else
                app.tagfocus=app.tagfocus+1;
            end

            % Update label
            updatetaglabel(app)

            app.TagSlider.Value=app.tagfocus;
        end

        % Button pushed function: PrevioustagButton
        function PrevioustagButtonPushed(app, event)
            if app.tagfocus==1
                app.tagfocus=app.numtags;
            else
                app.tagfocus=app.tagfocus-1;
            end

            % Update label
            updatetaglabel(app)

            app.TagSlider.Value=app.tagfocus;
        end

        % Value changed function: TagSlider
        function TagSliderValueChanged(app, event)
            app.tagfocus = round(app.TagSlider.Value);

            % Update label
            updatetaglabel(app)
            
        end

        % Button pushed function: LogCobbleButton
        function LogCobbleButtonPushed(app, event)
            telluser(app,'Cobble Position Recorded',true)

            app.tagflags(app.tagfocus)=true;
        end

        % Value changed function: GPSCOMSwitch
        function GPSCOMSwitchValueChanged(app, event)
%             value = app.GPSCOMSwitch.Value;
%             switch value
%                 case 'On'
%                     % Configure Serial
%                     if any(strcmp(serialportlist('available'),app.gpsCOM))
%                         app.antenna=serialport(app.antCOM,9600);
%                         configureTerminator(app.antenna,93); % 93 ascii = ']'
%                         configureCallback(app.antenna,"terminator",@app.readant);
%                     else
%                         error('Antenna COM port not available (%s)',app.antCOM);
%                     end
%                     
%                     app.AntennaCOMLamp.Enable='on';
%                     app.AntennaCOMLamp.Color='g';
%                     app.AntennaCOMListBox.Enable='off';
%                 case 'Off'
%                     delete(app.antenna);
%                     
%                     app.AntennaCOMLamp.Enable='off';
%                     app.AntennaCOMLamp.Color='r';
%                     app.AntennaCOMListBox.Enable='on';
%             end
            
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.Position = [100 100 1280 720];
            app.UIFigure.Name = 'MATLAB App';
            app.UIFigure.CloseRequestFcn = createCallbackFcn(app, @UIFigureCloseRequest, true);

            % Create GridLayout
            app.GridLayout = uigridlayout(app.UIFigure);
            app.GridLayout.ColumnWidth = {50, '0.7x', 130, 130, 130};
            app.GridLayout.RowHeight = {50, '1x'};
            app.GridLayout.RowSpacing = 9.66666666666667;
            app.GridLayout.Padding = [10 9.66666666666667 10 9.66666666666667];

            % Create GPSAxes
            app.GPSAxes = uiaxes(app.GridLayout);
            title(app.GPSAxes, 'GPS')
            xlabel(app.GPSAxes, 'Longitude')
            ylabel(app.GPSAxes, 'Latitude')
            zlabel(app.GPSAxes, 'Z')
            app.GPSAxes.Layout.Row = 2;
            app.GPSAxes.Layout.Column = [1 2];

            % Create TabGroup
            app.TabGroup = uitabgroup(app.GridLayout);
            app.TabGroup.Layout.Row = 2;
            app.TabGroup.Layout.Column = [3 5];

            % Create ControlsTab
            app.ControlsTab = uitab(app.TabGroup);
            app.ControlsTab.Title = 'Controls';

            % Create GridLayout2
            app.GridLayout2 = uigridlayout(app.ControlsTab);
            app.GridLayout2.ColumnWidth = {'1x', '1x', '1x'};
            app.GridLayout2.RowHeight = {50, 40, 40, 25, '10x', '1x'};
            app.GridLayout2.ColumnSpacing = 2.625;
            app.GridLayout2.Padding = [2.625 10 2.625 10];

            % Create RSSIAxes
            app.RSSIAxes = uiaxes(app.GridLayout2);
            title(app.RSSIAxes, 'RSSI')
            xlabel(app.RSSIAxes, 'Tag ID')
            ylabel(app.RSSIAxes, 'Signal Strength')
            zlabel(app.RSSIAxes, 'Z')
            app.RSSIAxes.Layout.Row = 5;
            app.RSSIAxes.Layout.Column = [1 3];

            % Create NexttagButton
            app.NexttagButton = uibutton(app.GridLayout2, 'push');
            app.NexttagButton.ButtonPushedFcn = createCallbackFcn(app, @NexttagButtonPushed, true);
            app.NexttagButton.Layout.Row = 1;
            app.NexttagButton.Layout.Column = 3;
            app.NexttagButton.Text = 'Next tag';

            % Create PrevioustagButton
            app.PrevioustagButton = uibutton(app.GridLayout2, 'push');
            app.PrevioustagButton.ButtonPushedFcn = createCallbackFcn(app, @PrevioustagButtonPushed, true);
            app.PrevioustagButton.Layout.Row = 1;
            app.PrevioustagButton.Layout.Column = 1;
            app.PrevioustagButton.Text = 'Previous tag';

            % Create TagIDLabel
            app.TagIDLabel = uilabel(app.GridLayout2);
            app.TagIDLabel.BackgroundColor = [0.9608 0.9529 0.7294];
            app.TagIDLabel.HorizontalAlignment = 'center';
            app.TagIDLabel.Layout.Row = 1;
            app.TagIDLabel.Layout.Column = 2;
            app.TagIDLabel.Text = 'Tag ID: ';

            % Create TagSliderLabel
            app.TagSliderLabel = uilabel(app.GridLayout2);
            app.TagSliderLabel.HorizontalAlignment = 'center';
            app.TagSliderLabel.Layout.Row = 2;
            app.TagSliderLabel.Layout.Column = 1;
            app.TagSliderLabel.Text = 'Tag #';

            % Create TagSlider
            app.TagSlider = uislider(app.GridLayout2);
            app.TagSlider.Limits = [1 30];
            app.TagSlider.ValueChangedFcn = createCallbackFcn(app, @TagSliderValueChanged, true);
            app.TagSlider.Layout.Row = 2;
            app.TagSlider.Layout.Column = [2 3];
            app.TagSlider.Value = 1;

            % Create LoggingLamp
            app.LoggingLamp = uilamp(app.GridLayout2);
            app.LoggingLamp.Layout.Row = 3;
            app.LoggingLamp.Layout.Column = 1;

            % Create LoggingLabel
            app.LoggingLabel = uilabel(app.GridLayout2);
            app.LoggingLabel.HorizontalAlignment = 'center';
            app.LoggingLabel.Layout.Row = 4;
            app.LoggingLabel.Layout.Column = 1;
            app.LoggingLabel.Text = 'Logging!';

            % Create GridLayout8
            app.GridLayout8 = uigridlayout(app.GridLayout2);
            app.GridLayout8.ColumnWidth = {'1x', '1x', '1x'};
            app.GridLayout8.Layout.Row = [3 4];
            app.GridLayout8.Layout.Column = [2 3];

            % Create AntennaCOMLamp_2
            app.AntennaCOMLamp_2 = uilamp(app.GridLayout8);
            app.AntennaCOMLamp_2.Layout.Row = 1;
            app.AntennaCOMLamp_2.Layout.Column = 1;
            app.AntennaCOMLamp_2.Color = [1 0 0];

            % Create AntennaLabel
            app.AntennaLabel = uilabel(app.GridLayout8);
            app.AntennaLabel.HorizontalAlignment = 'center';
            app.AntennaLabel.Layout.Row = 2;
            app.AntennaLabel.Layout.Column = 1;
            app.AntennaLabel.Text = 'Antenna';

            % Create GPSCOMLamp_2
            app.GPSCOMLamp_2 = uilamp(app.GridLayout8);
            app.GPSCOMLamp_2.Enable = 'off';
            app.GPSCOMLamp_2.Layout.Row = 1;
            app.GPSCOMLamp_2.Layout.Column = 2;
            app.GPSCOMLamp_2.Color = [1 0 0];

            % Create GPSCOMLabel_2
            app.GPSCOMLabel_2 = uilabel(app.GridLayout8);
            app.GPSCOMLabel_2.HorizontalAlignment = 'center';
            app.GPSCOMLabel_2.Layout.Row = 2;
            app.GPSCOMLabel_2.Layout.Column = 2;
            app.GPSCOMLabel_2.Text = 'GPS';

            % Create DatalogTab
            app.DatalogTab = uitab(app.TabGroup);
            app.DatalogTab.Title = 'Datalog';

            % Create GridLayout3
            app.GridLayout3 = uigridlayout(app.DatalogTab);
            app.GridLayout3.ColumnWidth = {'1x'};
            app.GridLayout3.RowHeight = {25, '1x', '2x'};
            app.GridLayout3.Padding = [2 10 2 10];

            % Create UITable
            app.UITable = uitable(app.GridLayout3);
            app.UITable.ColumnName = {'Column 1'; 'Column 2'; 'Column 3'; 'Column 4'};
            app.UITable.RowName = {};
            app.UITable.Multiselect = 'off';
            app.UITable.Layout.Row = 3;
            app.UITable.Layout.Column = 1;

            % Create ConsoleOutputTextAreaLabel
            app.ConsoleOutputTextAreaLabel = uilabel(app.GridLayout3);
            app.ConsoleOutputTextAreaLabel.HorizontalAlignment = 'center';
            app.ConsoleOutputTextAreaLabel.Layout.Row = 1;
            app.ConsoleOutputTextAreaLabel.Layout.Column = 1;
            app.ConsoleOutputTextAreaLabel.Text = 'Console Output';

            % Create ConsoleOutputTextArea
            app.ConsoleOutputTextArea = uitextarea(app.GridLayout3);
            app.ConsoleOutputTextArea.Layout.Row = 2;
            app.ConsoleOutputTextArea.Layout.Column = 1;
            app.ConsoleOutputTextArea.Value = {'Cobblefinder Startup'};

            % Create TESTINGTab
            app.TESTINGTab = uitab(app.TabGroup);
            app.TESTINGTab.Title = 'TESTING';

            % Create GridLayout6
            app.GridLayout6 = uigridlayout(app.TESTINGTab);
            app.GridLayout6.ColumnWidth = {'0.5x', '1x', 150};
            app.GridLayout6.RowHeight = {200, 50, 50, '1x', '1x', '1x', '1x', '1x', '1x', '1x'};

            % Create HeadingKnobLabel
            app.HeadingKnobLabel = uilabel(app.GridLayout6);
            app.HeadingKnobLabel.HorizontalAlignment = 'center';
            app.HeadingKnobLabel.Layout.Row = 2;
            app.HeadingKnobLabel.Layout.Column = 3;
            app.HeadingKnobLabel.Text = 'Heading';

            % Create HeadingKnob
            app.HeadingKnob = uiknob(app.GridLayout6, 'continuous');
            app.HeadingKnob.Limits = [0 360];
            app.HeadingKnob.ValueChangedFcn = createCallbackFcn(app, @HeadingKnobValueChanged, true);
            app.HeadingKnob.BusyAction = 'cancel';
            app.HeadingKnob.Layout.Row = 1;
            app.HeadingKnob.Layout.Column = 3;
            app.HeadingKnob.Value = 180;

            % Create WalkSwitchLabel
            app.WalkSwitchLabel = uilabel(app.GridLayout6);
            app.WalkSwitchLabel.HorizontalAlignment = 'center';
            app.WalkSwitchLabel.Layout.Row = 2;
            app.WalkSwitchLabel.Layout.Column = 1;
            app.WalkSwitchLabel.Text = 'Walk';

            % Create WalkSwitch
            app.WalkSwitch = uiswitch(app.GridLayout6, 'slider');
            app.WalkSwitch.ValueChangedFcn = createCallbackFcn(app, @WalkSwitchValueChanged, true);
            app.WalkSwitch.Layout.Row = 2;
            app.WalkSwitch.Layout.Column = 2;

            % Create ConfigureTab
            app.ConfigureTab = uitab(app.TabGroup);
            app.ConfigureTab.Title = 'Configure';
            app.ConfigureTab.HandleVisibility = 'off';

            % Create GridLayout4
            app.GridLayout4 = uigridlayout(app.ConfigureTab);
            app.GridLayout4.ColumnWidth = {'0.25x', '0.75x', '0.75x', '1x'};
            app.GridLayout4.RowHeight = {50, 50, 25, 50, 150, '1x'};

            % Create AntennaCOMLamp
            app.AntennaCOMLamp = uilamp(app.GridLayout4);
            app.AntennaCOMLamp.Enable = 'off';
            app.AntennaCOMLamp.Layout.Row = 1;
            app.AntennaCOMLamp.Layout.Column = 1;
            app.AntennaCOMLamp.Color = [1 0 0];

            % Create AntennaCOMSwitchLabel
            app.AntennaCOMSwitchLabel = uilabel(app.GridLayout4);
            app.AntennaCOMSwitchLabel.HorizontalAlignment = 'center';
            app.AntennaCOMSwitchLabel.Layout.Row = 1;
            app.AntennaCOMSwitchLabel.Layout.Column = 2;
            app.AntennaCOMSwitchLabel.Text = 'Antenna COM';

            % Create AntennaCOMSwitch
            app.AntennaCOMSwitch = uiswitch(app.GridLayout4, 'slider');
            app.AntennaCOMSwitch.ValueChangedFcn = createCallbackFcn(app, @AntennaCOMSwitchValueChanged, true);
            app.AntennaCOMSwitch.Interruptible = 'off';
            app.AntennaCOMSwitch.Enable = 'off';
            app.AntennaCOMSwitch.Layout.Row = 1;
            app.AntennaCOMSwitch.Layout.Column = 3;

            % Create AntennaCOMListBox
            app.AntennaCOMListBox = uilistbox(app.GridLayout4);
            app.AntennaCOMListBox.Items = {'list COM ports'};
            app.AntennaCOMListBox.ValueChangedFcn = createCallbackFcn(app, @AntennaCOMListBoxValueChanged, true);
            app.AntennaCOMListBox.Interruptible = 'off';
            app.AntennaCOMListBox.Layout.Row = 1;
            app.AntennaCOMListBox.Layout.Column = 4;
            app.AntennaCOMListBox.Value = 'list COM ports';

            % Create GPSCOMLamp
            app.GPSCOMLamp = uilamp(app.GridLayout4);
            app.GPSCOMLamp.Enable = 'off';
            app.GPSCOMLamp.Layout.Row = 2;
            app.GPSCOMLamp.Layout.Column = 1;
            app.GPSCOMLamp.Color = [1 0 0];

            % Create GPSCOMSwitchLabel
            app.GPSCOMSwitchLabel = uilabel(app.GridLayout4);
            app.GPSCOMSwitchLabel.HorizontalAlignment = 'center';
            app.GPSCOMSwitchLabel.Layout.Row = 2;
            app.GPSCOMSwitchLabel.Layout.Column = 2;
            app.GPSCOMSwitchLabel.Text = 'GPS COM';

            % Create GPSCOMSwitch
            app.GPSCOMSwitch = uiswitch(app.GridLayout4, 'slider');
            app.GPSCOMSwitch.ValueChangedFcn = createCallbackFcn(app, @GPSCOMSwitchValueChanged, true);
            app.GPSCOMSwitch.Interruptible = 'off';
            app.GPSCOMSwitch.Enable = 'off';
            app.GPSCOMSwitch.Layout.Row = 2;
            app.GPSCOMSwitch.Layout.Column = 3;

            % Create GPSCOMListBox
            app.GPSCOMListBox = uilistbox(app.GridLayout4);
            app.GPSCOMListBox.Items = {'list COM ports'};
            app.GPSCOMListBox.Interruptible = 'off';
            app.GPSCOMListBox.Enable = 'off';
            app.GPSCOMListBox.Layout.Row = 2;
            app.GPSCOMListBox.Layout.Column = 4;
            app.GPSCOMListBox.Value = 'list COM ports';

            % Create UILamp
            app.UILamp = uilamp(app.GridLayout4);
            app.UILamp.Interruptible = 'off';
            app.UILamp.Layout.Row = 4;
            app.UILamp.Layout.Column = 1;

            % Create UISwitchLabel
            app.UISwitchLabel = uilabel(app.GridLayout4);
            app.UISwitchLabel.Interruptible = 'off';
            app.UISwitchLabel.HorizontalAlignment = 'center';
            app.UISwitchLabel.Layout.Row = 4;
            app.UISwitchLabel.Layout.Column = 2;
            app.UISwitchLabel.Text = 'UI update';

            % Create UISwitch
            app.UISwitch = uiswitch(app.GridLayout4, 'slider');
            app.UISwitch.ValueChangedFcn = createCallbackFcn(app, @UISwitchValueChanged, true);
            app.UISwitch.Interruptible = 'off';
            app.UISwitch.Layout.Row = 4;
            app.UISwitch.Layout.Column = 3;
            app.UISwitch.Value = 'On';

            % Create GridLayout5
            app.GridLayout5 = uigridlayout(app.GridLayout4);
            app.GridLayout5.ColumnWidth = {80, 80, '1x', 80};
            app.GridLayout5.RowHeight = {40, 40, '1x'};
            app.GridLayout5.Layout.Row = 5;
            app.GridLayout5.Layout.Column = [1 4];

            % Create MoplinesCheckBox
            app.MoplinesCheckBox = uicheckbox(app.GridLayout5);
            app.MoplinesCheckBox.ValueChangedFcn = createCallbackFcn(app, @MoplinesCheckBoxValueChanged, true);
            app.MoplinesCheckBox.Text = 'Mop lines';
            app.MoplinesCheckBox.Layout.Row = 1;
            app.MoplinesCheckBox.Layout.Column = 2;
            app.MoplinesCheckBox.Value = true;

            % Create SnailtrailsCheckBox
            app.SnailtrailsCheckBox = uicheckbox(app.GridLayout5);
            app.SnailtrailsCheckBox.ValueChangedFcn = createCallbackFcn(app, @SnailtrailsCheckBoxValueChanged, true);
            app.SnailtrailsCheckBox.Text = 'Snail trails';
            app.SnailtrailsCheckBox.Layout.Row = 1;
            app.SnailtrailsCheckBox.Layout.Column = 1;
            app.SnailtrailsCheckBox.Value = true;

            % Create ZoomRadiusmDropDown
            app.ZoomRadiusmDropDown = uidropdown(app.GridLayout5);
            app.ZoomRadiusmDropDown.Items = {'50', '100', '200', '500', '750', '1000'};
            app.ZoomRadiusmDropDown.ValueChangedFcn = createCallbackFcn(app, @ZoomRadiusmDropDownValueChanged, true);
            app.ZoomRadiusmDropDown.Layout.Row = 1;
            app.ZoomRadiusmDropDown.Layout.Column = 4;
            app.ZoomRadiusmDropDown.Value = '200';

            % Create ZoomRadiusmDropDownLabel
            app.ZoomRadiusmDropDownLabel = uilabel(app.GridLayout5);
            app.ZoomRadiusmDropDownLabel.HorizontalAlignment = 'right';
            app.ZoomRadiusmDropDownLabel.Layout.Row = 1;
            app.ZoomRadiusmDropDownLabel.Layout.Column = 3;
            app.ZoomRadiusmDropDownLabel.Text = 'Zoom Radius (m)';

            % Create RSSIdotsCheckBox
            app.RSSIdotsCheckBox = uicheckbox(app.GridLayout5);
            app.RSSIdotsCheckBox.ValueChangedFcn = createCallbackFcn(app, @RSSIdotsCheckBoxValueChanged, true);
            app.RSSIdotsCheckBox.Text = 'RSSI dots';
            app.RSSIdotsCheckBox.Layout.Row = 2;
            app.RSSIdotsCheckBox.Layout.Column = 1;
            app.RSSIdotsCheckBox.Value = true;

            % Create LogCobbleButton
            app.LogCobbleButton = uibutton(app.GridLayout, 'push');
            app.LogCobbleButton.ButtonPushedFcn = createCallbackFcn(app, @LogCobbleButtonPushed, true);
            app.LogCobbleButton.BackgroundColor = [0.4 0.9608 0.5098];
            app.LogCobbleButton.Layout.Row = 1;
            app.LogCobbleButton.Layout.Column = [3 5];
            app.LogCobbleButton.Text = 'Log Cobble';

            % Create GridLayout7
            app.GridLayout7 = uigridlayout(app.GridLayout);
            app.GridLayout7.ColumnWidth = {'1x', '1x', '1x', '1x', '1x', '1x', '1x'};
            app.GridLayout7.RowHeight = {'1x'};
            app.GridLayout7.Layout.Row = 1;
            app.GridLayout7.Layout.Column = 2;

            % Create UImssg
            app.UImssg = uilabel(app.GridLayout7);
            app.UImssg.BackgroundColor = [0.902 0.902 0.902];
            app.UImssg.FontSize = 24;
            app.UImssg.FontColor = [1 0 0];
            app.UImssg.Visible = 'off';
            app.UImssg.Layout.Row = 1;
            app.UImssg.Layout.Column = [1 5];
            app.UImssg.Text = '';

            % Create RefreshButton
            app.RefreshButton = uibutton(app.GridLayout7, 'push');
            app.RefreshButton.ButtonPushedFcn = createCallbackFcn(app, @RefreshButtonPushed, true);
            app.RefreshButton.BusyAction = 'cancel';
            app.RefreshButton.Interruptible = 'off';
            app.RefreshButton.Layout.Row = 1;
            app.RefreshButton.Layout.Column = 7;
            app.RefreshButton.Text = 'Refresh';

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = Cobblefinder

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.UIFigure)

            % Execute the startup function
            runStartupFcn(app, @startupFcn)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.UIFigure)
        end
    end
end