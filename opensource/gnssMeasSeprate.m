function  [gnssMeasBackscattered]=gnssMeasSeprate(gnssMeas,prFileName)
figure;
[colors] = PlotPseudoranges(gnssMeas,prFileName);
figure;
PlotCno(gnssMeas,prFileName,colors);
dim=1;
[strongestSig,SigIndex]=max(gnssMeas.Cn0DbHz);
[MaxCn0DbHz,Index]=max(strongestSig);
StongestSvid=gnssMeas.Svid(Index);


%选到信号�?��的卫星信�?
gnssCnoMax=gnssMeas.Cn0DbHz(:,Index);
figure;
plot(gnssCnoMax);
%选取判决门限
gnssCnoMax(isnan(gnssCnoMax)==1) = min(gnssCnoMax);
gnssCnoMaxCopy=gnssCnoMax;
refLevel=mean(gnssCnoMaxCopy);
gnssCnoMaxCopy(find(gnssCnoMaxCopy<refLevel))=0;
gnssCnoMaxCopy(find(gnssCnoMaxCopy>refLevel))=1;
figure;
plot(gnssCnoMaxCopy);
% 产生同步方波
t=1:1:length(gnssCnoMax)/10;
ref=square(t,50);
corr = xcorr(ref,gnssCnoMax);
%写到这了�?
[pks,locs] = findpeaks(corr);
%第一个节点的结果移动到第�?���?
figure;
% hold on
% plot(ref);
% plot(gnssCnoMax);
plot(corr);
%
LocsCnoIndex= find(gnssCnoMaxCopy>0.5);
% gnssMeasBackscattered=gnssMeas(LocsCnoIndex);
% gnssMeasBackscattered=gnssMeas(LocsCnoIndex);
%
gnssMeasBackscattered.svid=gnssMeas.Svid;
gnssMeasBackscattered.AzDeg=gnssMeas.AzDeg;
gnssMeasBackscattered.ElDeg=gnssMeas.ElDeg;
gnssMeasBackscattered.FctSeconds=gnssMeas.FctSeconds(LocsCnoIndex,:);
gnssMeasBackscattered.ClkDCount=gnssMeas.ClkDCount(LocsCnoIndex,:);
gnssMeasBackscattered.HwDscDelS=gnssMeas.HwDscDelS(LocsCnoIndex,:);
gnssMeasBackscattered.tRxSeconds=gnssMeas.tRxSeconds(LocsCnoIndex,:);
gnssMeasBackscattered.tTxSeconds=gnssMeas.tTxSeconds(LocsCnoIndex,:);
gnssMeasBackscattered.PrM=gnssMeas.PrM(LocsCnoIndex,:);
gnssMeasBackscattered.PrSigmaM=gnssMeas.PrSigmaM(LocsCnoIndex,:);
gnssMeasBackscattered.DelPrM=gnssMeas.DelPrM(LocsCnoIndex,:);
gnssMeasBackscattered.PrrMps=gnssMeas.PrrMps(LocsCnoIndex,:);
gnssMeasBackscattered.PrrSigmaMps=gnssMeas.PrrSigmaMps(LocsCnoIndex,:);
gnssMeasBackscattered.AdrM=gnssMeas.AdrM(LocsCnoIndex,:);
gnssMeasBackscattered.AdrSigmaM=gnssMeas.AdrSigmaM(LocsCnoIndex,:);
gnssMeasBackscattered.AdrState=gnssMeas.AdrState(LocsCnoIndex,:);
gnssMeasBackscattered.Cn0DbHz=gnssMeas.Cn0DbHz(LocsCnoIndex,:);
gnssBksCnoMax=gnssMeasBackscattered.Cn0DbHz(:,Index);
figure;
plot(gnssBksCnoMax);

end