c% Script file is for creating custom filters for GnssAnalysisApp
%
% Rules for setting data filter:
% 
% You may filter on any of the "# Raw" header values in the GnssLogger log
% file, example:
% # Raw,ElapsedRealtimeMillis,TimeNanos,LeapSecond,TimeUncertaintyNanos,...
%   FullBiasNanos,BiasNanos,BiasUncertaintyNanos,DriftNanosPerSecond,...
%   DriftUncertaintyNanosPerSecond,HardwareClockDiscontinuityCount,Svid,...
%   TimeOffsetNanos,State,ReceivedSvTimeNanos,ReceivedSvTimeUncertaintyNanos,...
%   Cn0DbHz,PseudorangeRateMetersPerSecond,PseudorangeRateUncertaintyMetersPerSecond,...
%   AccumulatedDeltaRangeState,AccumulatedDeltaRangeMeters,...
%   AccumulatedDeltaRangeUncertaintyMeters,CarrierFrequencyHz,...
%   MultipathIndicator,SnrInDb,ConstellationType,AgcDb
%
% dataFilter is an nx2 cell array, where each row defines a filter value
%
% Each dataFilter entry must contain only one type of header value
%
% You may use a header value e.g. 'ConstellationType' more than once,
% so long as you don't use different heading types in one dataFilter{} row

dataFilter={}; %initialize dataFilter before adding values

%% Example, how to select satellites from GPS and GAL:
% dataFilter{end+1,1} = 'ConstellationType'; 
% dataFilter{end,2} = '(ConstellationType)==1 | (ConstellationType)==6';
%% Example, how to remove GLONASS:
% dataFilter{end+1,1} = 'ConstellationType'; 
% dataFilter{end,2} = '(ConstellationType)~=3';
%
% Constellation types are as specified in the Android GNSS Raw Measurements API

%% Example L1 only
% dataFilter{end+1,1} = 'CarrierFrequencyHz'; 
% dataFilter{end,2} = 'CarrierFrequencyHz > 1.5E9';

%% Example CNo > 23 dBHz only
% dataFilter{end+1,1} = 'Cn0DbHz'; 
% dataFilter{end,2}   = 'Cn0DbHz>23';
