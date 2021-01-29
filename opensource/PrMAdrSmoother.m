function [gnssMeas]= PrMAdrSmoother(gnssMeas)
% [gnssMeas]= ProcessAdr(gnssMeas)
% process the Accumulated Delta Ranges obtained from ProcessGnssMeas
%
%gnssMeas.FctSeconds = Nx1 vector. Rx time tag of measurements.
%        .ClkDCount  = Nx1 vector. Hw clock discontinuity count
%        .Svid       = 1xM vector of all svIds found in gnssRaw.
%        ...
%        .PrM        = NxM pseudoranges, row i corresponds to FctSeconds(i)
%        .DelPrM     = NxM change in pr while clock continuous
%        .AdrM       = NxM accumulated delta range (= -k*carrier phase) 
%        ...
%
% output:
% gnssMeas.PrMSmooth = NxM , re-initialized to PrM at each
%   discontinuity or reset of DelPrM or AdrM

%Author: Xie Yirong
%Open Source code for processing Android GNSS Measurements

if ~any(any(isfinite(gnssMeas.AdrM) & gnssMeas.AdrM~=0))
    %Nothing in AdrM but NaNs and zeros
    fprintf(' No ADR recorded\n'), return
end

M = length(gnssMeas.Svid);
N = length(gnssMeas.FctSeconds);
PrMSmooth = zeros(N,M)+NaN;
for j=1:M %loop over Svid
    AdrM    = gnssMeas.AdrM(:,j); %make local variables for readability
    PrM  = gnssMeas.PrM(:,j);
    AdrState = gnssMeas.AdrState(:,j);
    %From gps.h:
    %/* However, it is expected that the data is only accurate when:
    % *  'accumulated delta range state' == GPS_ADR_STATE_VALID.
    %*/
    % #define GPS_ADR_STATE_UNKNOWN                       0
    % #define GPS_ADR_STATE_VALID                     (1<<0)
    % #define GPS_ADR_STATE_RESET                     (1<<1)
    % #define GPS_ADR_STATE_CYCLE_SLIP                (1<<2)
    
    %keep valid values of AdrM only
    iValid = bitand(AdrState,2^0);
    iReset = bitand(AdrState,2^1);
    AdrM(~iValid) = NaN;
    
    %% work out DelPrM - AdrM since last discontinuity, plot DelPrM-AdrM
    M = 100;
    PrMLast = NaN; %to store initial offset from AdrM
    for i=1:N %loop over time
%         if i == 150
%            a = 1; 
%         end
        if isfinite(AdrM(i)) && (AdrM(i)~=0) && isfinite(PrM(i)) && ...
                ~iReset(i)
            %reinitialize after NaNs or AdrM zero or AdrState reset
            if isnan(PrMLast)
                PrMSmooth(i,j) = PrM(i);
            else
                PrMSmooth(i,j) = PrM(i)/M +  (PrMSmooth(i-1,j) + AdrM(i) - AdrM(i-1)) * (M-1)/M;
            end
            
        else %reset at NaNs or AdrM zero
            PrMSmooth(i,j) = NaN;
%             PrMSmooth(i,j) = PrM(i);
        end
        PrMLast = PrMSmooth(i,j);
    end
end
    
gnssMeas.PrMSmooth = PrMSmooth;

figure
plot(gnssMeas.PrM)
figure
plot(gnssMeas.PrMSmooth)

figure
plot(gnssMeas.DelPrM)
figure
x = gnssMeas.PrMSmooth - [gnssMeas.PrMSmooth(1,:); gnssMeas.PrMSmooth(1:end-1,:)];
plot(x)
end