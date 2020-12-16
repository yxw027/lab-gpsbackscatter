%ProcessGnssMeasScript.m, script to read GnssLogger output, compute and plot:
% pseudoranges, C/No, and weighted least squares PVT solution
%
% you can run the data in pseudoranges log files provided for you: 
% prFileName = 'gnss_log_2020_08_07_15_09_27.txt'; %with duty cycling, no carrier phase
close all;
clear all;
prFileName = 'gnss_log_2020_08_07_03_36_36.txt'; %no duty cycling, with carrier phase
% as follows
% 1) copy everything from GitHub google/gps-me     asurement-tools/ to 
%    a local directory on your machine
% 2) change 'dirName = ...' to match the local directory you are using:

% dirName = 'E:\Users\ASUS\Documents\Lab Research\Submit\NewCode\gps-measurement-tools-master\opensource\demoFiles';
% dirName = 'E:\Users\ASUS\Documents\Lab Research\Submit\NewCode\gps-measurement-tools-master\opensource\demoFiles';

% Raw and GPS data Path
dirName = '..\dhx_paper\TEST\Room_810_PCL_0804\Test0_5Hz\1';
% dirName='E:\Users\ASUS\Desktop\TEST\mi8';
% 3) run ProcessGnssMeasScript.m script file 
param.llaTrueDegDegM = [];

%Author: Frank van Diggelen
%Open Source code for processing Android GNSS Measurements

%% data
%To add your own data:
% save data from GnssLogger App, and edit dirName and prFileName appropriately
%dirName = 'put the full path for your directory here';
%prFileName = 'put the pseuoranges log file name here';

%% parameters
%param.llaTrueDegDegM = [];
%enter true WGS84 lla, if you know it:
% param.llaTrueDegDegM = [37.422578, -122.081678, -28];%Charleston Park Test Site

%% Set the data filter and Read log file
dataFilter = SetDataFilter;
[gnssRaw,gnssAnalysis] = ReadGnssLogger(dirName,prFileName,dataFilter);
if isempty(gnssRaw), return, end

%% Get online ephemeris from Nasa ftp, first compute UTC Time from gnssRaw:
% Get the last second, in millisecond
fctSeconds = 1e-3*double(gnssRaw.allRxMillis(end));
% Convert GPS time (week & seconds), or Full Cycle Time (seconds) to UTC
% e.g: 1280778419432
utcTime = Gps2Utc([],fctSeconds);
allGpsEph = GetNasaHourlyEphemeris(utcTime,dirName);
if isempty(allGpsEph), return, end

%% process raw measurements, compute pseudoranges:
% Analyse the raw data (Only changed the name of func)
% [gnssMeas] = ProcessGnssMeas(gnssRaw);
 [gnssMeas]= ProcessGnssMeasForBackscatter(gnssRaw); % Process raw measurements read from ReadGnssLogger
 
 [gnssMeas_BKS, gnssRaw_BKS]=Seprate(gnssRaw,gnssMeas,prFileName);
 
%  gnssRaw_BKS = gnssRaw.(1);
 
% [gnssMeasBackscattered]=gnssMeasSeprate(gnssMeas,prFileName);
% %% plot pseudoranges and pseudorange rates
% h1 = figure;
% [colors] = PlotPseudoranges(gnssMeas,prFileName);
% h2 = figure;
% PlotPseudorangeRates(gnssMeas,prFileName,colors);
% h3 = figure;
% PlotCno(gnssMeas,prFileName,colors);

%% Calculate the position of satellites
close all
% gpsPvt = GpsWlsPvt(gnssMeasBackscattered,allGpsEph);
N = length(gnssMeas_BKS.FctSeconds);
for i=1:N
    iValid = find(isfinite(gnssMeas_BKS.PrM(i,:))); %index into valid svid
    svid    = gnssMeas_BKS.Svid(iValid)';
    
    [gpsEph,iSv] = ClosestGpsEph(allGpsEph,svid,gnssMeas_BKS.FctSeconds(i));
    svid = svid(iSv); %svid for which we have ephemeris
    numSvs = length(svid); %number of satellites this epoch
    
    
    gpsPvt_BKS(i).numSvs = numSvs;
    gpsPvt_BKS(i).svid = svid;


    %GPS Week number:
    weekNumber = floor(-double(gnssRaw_BKS.FullBiasNanos(i))*1e-9/GpsConstants.WEEKSEC);
%    use tRxSeconds 
    for k=1:numSvs
%         position.pos(k) = SatPosition(gpsEph(k),gnssMeas_BKS.tRxSeconds(i), weekNumber);
        [position(k,1), position(k,2), position(k,3)] = SatPosition(gpsEph(k),gnssMeas_BKS.tRxSeconds(i), weekNumber);
    end
    gpsPvt_BKS(i).position = position;
    gpsPvt_BKS(i).gpsEph = gpsEph;
    if numSvs<4
        continue;%skip to next epoch
    end

end








%% compute WLS position and velocity
gpsPvt = GpsWlsPvt(gnssMeas_BKS,allGpsEph);
% gpsPvt= GpsWlsPvtBackscatter(gnssMeas,allGpsEph);%

%% plot Pvt results
h4 = figure;
ts = 'Raw Pseudoranges, Weighted Least Squares solution';
PlotPvt(gpsPvt,prFileName,param.llaTrueDegDegM,ts); drawnow;
h5 = figure;
PlotPvtStates(gpsPvt,prFileName);

%% Plot Accumulated Delta Range 
if any(any(isfinite(gnssMeas.AdrM) & gnssMeas.AdrM~=0))
    [gnssMeas]= ProcessAdr(gnssMeas);
    h6 = figure;
    PlotAdr(gnssMeas,prFileName,colors);
    [adrResid]= GpsAdrResiduals(gnssMeas,allGpsEph,param.llaTrueDegDegM);drawnow
    h7 = figure;
    PlotAdrResids(adrResid,gnssMeas,prFileName,colors);
end

%% Calculate err based on GroundTruth
GroundTruth = [22.576062252004220   113.9363809520042;];
% distance=distanceCountViaCoordinate(gpsPvt.allLlaDegDegM(:,1:2),GroundTruth)
distance = zeros(length(gpsPvt.allLlaDegDegM(:,1)),1);
for i = 1:length(gpsPvt.allLlaDegDegM(:,1))
    distance(i) = distanceCountViaCoordinate(gpsPvt.allLlaDegDegM(i,1:2),GroundTruth);
end
figure
plot(distance)
