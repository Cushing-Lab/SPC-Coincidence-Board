%% Michelson interferometer with SPADs and ESP
% Version 2: 04/14/2021
% NEW VERSION: 01/18/2022
% Update notes:
% Better data saving
​
clear all
close all
% MAKE SURE MATLAB IS RUNNING AS ADMIN!!!!!!
%% SET THESE BEFORE PRESSING START
​
% Number of runs and data folder
numRuns = 3;
foldertosavedata = 'E:\Data\20220118 183C WP115 10nm bandpass ethanol';
% Stage positions
runstart = -5.265; %Run stage position start
runstop = -5.135;
step_size = 0.0001;     % travel step size
​
% PicoHarp integration time 
Tacq         = 10000;    %  you can change this time in ms
% PicoHarp indices to plot
startingindex = 4750;
finalindex = 6250;
​
% ESP
espcom = 'COM3';
​
%% Initialization
% Makes folder for data
foldertosavedata = [foldertosavedata,'\',strrep(datestr(now,'yyyy/mm/dd'),'/',''),' s',strrep(num2str(step_size),'.','p'),' int',num2str(Tacq/1000),' ',strrep(num2str(runstart),'.','p'),' ',strrep(num2str(runstop),'.','p')];
mkdir(foldertosavedata)
% ESP initalization
%espcom = 'COM3';
esp301 = espConnect(espcom);     % connect ESP. Check 'serial' function inside 'espConnect' to make sure the comport syntax is correct
setvelocity(esp301,1,2);     % set travel velocity in mm/s
stagepositions = [runstart : step_size : runstop];     % x-axis is stage positions
numstagepositions = size(stagepositions,2);
% PicoHarp initialization
REQLIBVER   =  '3.0';     % this is the version this program expects
MAXDEVNUM   =      8;
HISTCHAN    =  65536;	    % number of histogram channels
MAXBINSTEPS =      8;
MODE_HIST   =      0;
MODE_T2	    =      2;
MODE_T3	    =      3;
FLAG_OVERFLOW = hex2dec('0040');
ZCMIN		  =          0;		% mV
ZCMAX		  =         20;		% mV
DISCRMIN	  =          0;	    % mV
DISCRMAX	  =        800;	    % mV
SYNCOFFSMIN	  =     -99999;		% ps
SYNCOFFSMAX	  =      99999;		% ps
OFFSETMIN	  =          0;		% ps
OFFSETMAX	  = 1000000000;	    % ps
ACQTMIN		  =          1;		% ms
ACQTMAX		  =  360000000;	    % ms  (10*60*60*1000ms = 100h)
PH_ERROR_DEVICE_OPEN_FAIL		 = -1;
% Settings for the measurement
Offset       = 0;       %  you can change this
CFDZeroX0    = 10;      %  you can change this
CFDLevel0    = 150;     %  you can change this
CFDZeroX1    = 10;      %  you can change this
CFDLevel1    = 150;     %  you can change this
SyncDiv      = 1;       %  you can change this
SyncOffset   = 0;       %  you can change this
Binning      = 1;       %  you can change this
dev = [];
found = 0;
Serial     = '12345678'; %enough length!
SerialPtr  = libpointer('cstring', Serial);
ErrorStr   = 'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx'; %enough length!
ErrorPtr   = libpointer('cstring', ErrorStr);
loadlibrary('phlib64.dll', 'phlib.h', 'alias', 'PHlib');
for i=0:MAXDEVNUM-1
    [ret, Serial] = calllib('PHlib', 'PH_OpenDevice', i, SerialPtr);
    if (ret==0)       % Grab any PicoHarp we successfully opened
        fprintf('\n  %1d        S/N %s', i, Serial);
        found = found+1;            
        dev(found)=i; %keep index to devices we may want to use
    else
        if(ret==PH_ERROR_DEVICE_OPEN_FAIL)
            fprintf('\n  %1d        no device', i);
        else 
            [ret, ErrorStr] = calllib('PHlib', 'PH_GetErrorString', ErrorPtr, ret);
            fprintf('\n  %1d        %s', i,ErrorStr);
        end;
	end;
end;
    
% in this demo we will use the first PicoHarp device we found, i.e. dev(1)
% you could also check for a specific serial number, so that you always know 
% which physical device you are talking to.
​
if (found<1)
	fprintf('\nNo device available. Aborted.\n');
	return; 
end;
​
fprintf('\nUsing device #%1d',dev(1));
fprintf('\nInitializing the device...');
​
[ret] = calllib('PHlib', 'PH_Initialize', dev(1), MODE_HIST); 
if(ret<0)
	fprintf('\nPH init error %d. Aborted.\n',retcode);
    closedev;
	return;
end; 
​
%this is only for information
Model      = '1234567890123456'; %enough length!
Partnum    = '12345678'; %enough length!
Version    = '12345678'; %enough length!
ModelPtr   = libpointer('cstring', Model);
PartnumPtr = libpointer('cstring', Partnum);
VersionPtr = libpointer('cstring', Version);
[ret, Model, Partnum, Version] = calllib('PHlib', 'PH_GetHardwareInfo', dev(1), ModelPtr, PartnumPtr, VersionPtr);
if (ret<0)
    fprintf('\nPH_GetHardwareInfo error %1d. Aborted.\n',ret);
    closedev;
	return;
else
	fprintf('\nFound Model %s Part number %s Version: %s', Model, Partnum, Version);             
end;
        
fprintf('\nCalibrating ...');
[ret] = calllib('PHlib', 'PH_Calibrate', dev(1));
if (ret<0)
    fprintf('\nPH_Calibrate error %1d. Aborted.\n',ret);
    closedev;
    return;
end;
   
[ret] = calllib('PHlib', 'PH_SetSyncDiv', dev(1), SyncDiv);
if (ret<0)
    fprintf('\nPH_SetSyncDiv error %1d. Aborted.\n',ret);
    closedev;
    return;
end;
​
[ret] = calllib('PHlib', 'PH_SetSyncOffset', dev(1), SyncOffset);
if (ret<0)
    fprintf('\nPH_SetSyncOffset error %1d. Aborted.\n',ret);
    closedev;
    return;
end;
​
[ret] = calllib('PHlib', 'PH_SetInputCFD', dev(1), 0, CFDLevel0, CFDZeroX0);
if (ret<0)
    fprintf('\nPH_SetInputCFD error %ld. Aborted.\n', ret);
    closedev;
    return;
end;
​
[ret] = calllib('PHlib', 'PH_SetInputCFD', dev(1), 1, CFDLevel1, CFDZeroX1);
if (ret<0)
    fprintf('\nPH_SetInputCFD error %ld. Aborted.\n', ret);
    closedev;
    return;
end;
​
[ret] = calllib('PHlib', 'PH_SetBinning', dev(1), Binning);
if (ret<0)
    fprintf('\nPH_SetBinning error %ld. Aborted.\n', ret);
    closedev;
    return;
end;
​
[Offset] = calllib('PHlib', 'PH_SetOffset', dev(1), Offset);
if (Offset<0)
    fprintf('\nPH_SetOffset error %ld. Aborted.\n', ret);
    closedev;
    return;
end;
​
ret = calllib('PHlib', 'PH_SetStopOverflow', dev(1), 1, 65535);
if (ret<0)
    fprintf('\nPH_SetStopOverflow error %ld. Aborted.\n', ret);
    closedev;
    return;
end;
​
Resolution = 0;
ResolutionPtr = libpointer('doublePtr', Resolution);
[ret, Resolution] = calllib('PHlib', 'PH_GetResolution', dev(1), ResolutionPtr);
if (Resolution<0)
    fprintf('\nPH_GetResolution error %ld. Aborted.\n', ret);
    closedev;
    return;
end;
% Note: after Init or SetSyncDiv you must allow 100 ms for valid new count rate readings
pause(0.2);
Countrate0 = 0;
CountratePtr = libpointer('int32Ptr', Countrate0);
[ret, Countrate0] = calllib('PHlib', 'PH_GetCountRate', dev(1),0,CountratePtr);
Countrate1 = 0;
CountratePtr = libpointer('int32Ptr', Countrate1);
[ret, Countrate1] = calllib('PHlib', 'PH_GetCountRate', dev(1),1,CountratePtr);
countsbuffer  = uint32(zeros(1,HISTCHAN));
bufferptr = libpointer('uint32Ptr', countsbuffer);
​
fprintf('\nResolution=%1dps Countrate0=%1d/s Countrate1=%1d/s', Resolution, Countrate0, Countrate1);
ret = calllib('PHlib', 'PH_ClearHistMem', dev(1),0);    % always use Block 0 if not Routing
if (ret<0)
    fprintf('\nPH_ClearHistMem error %ld. Aborted.\n', ret);
    closedev;
    return;
end;
​
histogramplotx = [1 : 1 : 65536];
% Variable memory allocation
fprintf(['\nEach run will take ',num2str(((runstop-runstart)/step_size)*(Tacq/1000)/3600),'hours\n'])
fprintf(['\nThis scan will take ',num2str(numRuns*((runstop-runstart)/step_size)*(Tacq/1000)/3600),'hours\n'])
​
%% Run
% h = animatedline('Color','b','LineWidth',2);
% xlabel('Stage Position [mm]')
% ylabel('Coincidences s^-^1')
for run = 1:numRuns
    current_run_data = {};
    count0plot = NaN(numstagepositions,1);
    count1plot = NaN(numstagepositions,1);
    summedcounts = NaN(numstagepositions,1);
    stagepositionsplot = NaN(numstagepositions,1);
    ESPerror = {};
    for a = 1:size(stagepositions,2)
        ret = calllib('PHlib', 'PH_ClearHistMem', dev(1),0);    % always use Block 0 if not Routing
        if (ret<0)
            fprintf('\nPH_ClearHistMem error %ld. Aborted.\n', ret);
            closedev;
            return;
        end;
        disp(stagepositions(1,a))
        % Try and Catch loop to make sure ESP doesn't stop program
        try
            current_pos = moveto(esp301, 1, stagepositions(1,a));
        catch
            if isempty(ESPerror)
                ESPerror = datetime(clock);
            else
                ESPerror = cat(1,ESPerror,datetime(clock));
            end
            devicestatus = system('pnputil /disable-device "USB\VID_104D&PID_3001\0000000000000000"');
            devicestatus = system('pnputil /enable-device "USB\VID_104D&PID_3001\0000000000000000"');
            esp301 = espConnect(espcom);     % connect ESP. Check 'serial' function inside 'espConnect' to make sure the comport syntax is correct
            setvelocity(esp301,1,2);     % set travel velocity in mm/s
            current_pos = moveto(esp301, 1, stagepositions(1,a));
        end
        ret = calllib('PHlib', 'PH_StartMeas', dev(1),Tacq);
        if (ret<0)
            fprintf('\nPH_StartMeas error %ld. Aborted.\n', ret);
            closedev;
            return;
        end;
        fprintf('\nMeasuring for %1d milliseconds...',Tacq);
        ctcdone = int32(0);
        ctcdonePtr = libpointer('int32Ptr', ctcdone);
        while (ctcdone==0)
            [ret, ctcdone] = calllib('PHlib', 'PH_CTCStatus', dev(1), ctcdonePtr);
        end;
        ret = calllib('PHlib', 'PH_StopMeas', dev(1));
        if (ret<0)
            fprintf('\nPH_StopMeas error %ld. Aborted.\n', ret);
            closedev;
            return;
        end;
​
        [ret,countsbuffer] = calllib('PHlib', 'PH_GetHistogram', dev(1), bufferptr, 0);
        if (ret<0)
            fprintf('\nPH_GetHistogram error %ld. Aborted.\n', ret);
            closedev;
            return;
        end
        [ret, Countrate0] = calllib('PHlib', 'PH_GetCountRate', dev(1),0,CountratePtr);
        [ret, Countrate1] = calllib('PHlib', 'PH_GetCountRate', dev(1),1,CountratePtr);
        try
            current_stage_pos = findposition(esp301, 1);
        catch
            if isempty(ESPerror)
                ESPerror = datetime(clock);
            else
                ESPerror = cat(1,ESPerror,datetime(clock));
            end
            devicestatus = system('pnputil /disable-device "USB\VID_104D&PID_3001\0000000000000000"');
            devicestatus = system('pnputil /enable-device "USB\VID_104D&PID_3001\0000000000000000"');
            esp301 = espConnect(espcom);     % connect ESP. Check 'serial' function inside 'espConnect' to make sure the comport syntax is correct
            setvelocity(esp301,1,2);     % set travel velocity in mm/s
            current_stage_pos = findposition(esp301, 1);
        end
        current_pos_data = countsbuffer;
        current_run_data{1,1} = current_pos_data;
        current_run_data{1,2} = Countrate0;
        current_run_data{1,3} = Countrate1;
        current_run_data{1,4} = current_stage_pos;
        intcounts = sum(current_pos_data(1,startingindex:finalindex),2);
        intcounts = double(intcounts);
        Countrate0 = double(Countrate0);
        Countrate1 = double(Countrate1);
        count0plot(a,1) = Countrate0;
        count1plot(a,1) = Countrate1;
        summedcounts(a,1) = intcounts;
        stagepositionsplot(a,1) = stagepositions(1,a);
        figure(1)
        plot(histogramplotx,countsbuffer)
        title('Coincidence histogram')
        drawnow
        figure(2)
        subplot(3,1,1)
        plot(stagepositionsplot,summedcounts)
        title('Summed Coincidence Counts')
        subplot(3,1,2)
        plot(stagepositionsplot,count0plot)
        title('Counts in Channel 0')
        subplot(3,1,3)
        plot(stagepositionsplot,count1plot)
        title('Counts in Channel 1')
        drawnow
        %%
        if a == 1
            save([foldertosavedata,'\','Run',num2str(run),'data','.mat'],'current_run_data','-v7.3')
            run_data_file = matfile([foldertosavedata,'\','Run',num2str(run),'data','.mat'],'Writable',true);
        else
            run_data_file.current_run_data(size(run_data_file,'current_run_data',1)+1,:) = current_run_data;
        end
        save([foldertosavedata,'\Run',num2str(run),'error.mat'],'ESPerror')
        %save([foldertosavedata,'\','Run',num2str(run),'data','.mat'],'current_run_data')
    end
end
​
%% Disconnect