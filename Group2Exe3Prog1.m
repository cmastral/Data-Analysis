clear;
close all;
%% Import Data
datM=importdata('forestfires.txt');
%% Burnt Areas Attribute
% 0 value -> burnt, any other value -> non-burnt
yV = datM(:,13);
%% Parameters
% M - Number of samples
M = 50;
% n - sample size
n = 20;
% B - number of Bootstrap Samples
B = 1000;
% alpha - confidence level
alpha = 0.05;
%% Indices for burnt and unburnt areas 
% nunburnt areas index
ind0V = find(yV==0); 
% sum of unburnt areas
sum0 = length(ind0V);
% burnt areas index
ind1V = find(yV~=0);
% sum of burnt areas
sum1 = length(ind1V); 
%% Temperature, Relative Humidity and Wind Attributes of unburnt areas 
temp0V = datM(ind0V,9);
rh0V = datM(ind0V,10);
wind0V = datM(ind0V,11);
%% Temperature, Relative Humidity and Wind Attributes of burnt areas 
temp_burntV = datM(ind1V,9);
rh_burntV = datM(ind1V,10);
wind_burntV = datM(ind1V,11);
%% Parameters for percentile bootstrap
klower = floor((B+1)*alpha/2);
kup = B+1-klower;
tailpercV = [klower kup]*100/B;
%% Percentile bootstrap confidence intervals for median differnce for all the samples
bootdmxV1=NaN(B,1);
bootdmxV2=NaN(B,1);
bootdmxV3=NaN(B,1);
for iB=1:B
    rV0 = unidrnd(sum0,sum0,1);
    xb1V = temp0V(rV0,1);
    xb2V = rh0V(rV0,1);
    xb3V = wind0V(rV0,1);
    rV1 = unidrnd(sum1,sum1,1);
    yb1V = temp_burntV(rV1,1);
    yb2V = rh_burntV(rV1,1);
    yb3V = wind_burntV(rV1,1);
    bootdmxV1(iB) = median(xb1V)-median(yb1V);
    bootdmxV2(iB) = median(xb2V)-median(yb2V);
    bootdmxV3(iB) = median(xb3V)-median(yb3V);
end

ci_temp = prctile(bootdmxV1,tailpercV);
ci_rh = prctile(bootdmxV2,tailpercV);
ci_wind = prctile(bootdmxV3,tailpercV);
    
%% Percentile bootstrap confidence intervals for median differnce for M samples, n sample size 
bootdmxV1_2 = NaN(B,1);
bootdmxV2_2 = NaN(B,1);
bootdmxV3_2 = NaN(B,1);
cidmxV1= NaN(M,2);
cidmxV2= NaN(M,2);
cidmxV3= NaN(M,2);

for i=1:M
indxV0 = unidrnd(sum0,n,1);
indxV1 = unidrnd(sum1,n,1);
x_temp0=temp0V(indxV0);
x_temp_burnt=temp_burntV(indxV1);
x_rh0=rh0V(indxV0);
x_rh_burnt=rh_burntV(indxV1);
x_wind0=wind0V(indxV0);
x_wind_burnt=wind_burntV(indxV1);

     for iB=1:B
        rV0_2 = unidrnd(n,n,1);
        xb1V_2 = x_temp0(rV0_2,1);
        xb2V_2 = x_rh0(rV0_2,1);
        xb3V_2 = x_wind0(rV0_2,1);
        
        rV1_2 = unidrnd(n,n,1);
        
        yb1V_2 = x_temp_burnt(rV1_2,1);
        yb2V_2 = x_rh_burnt(rV1_2,1);
        yb3V_2 = x_wind_burnt(rV1_2,1);
        
        bootdmxV1_2(iB) = median(xb1V_2)-median(yb1V_2);
        bootdmxV2_2(iB) = median(xb2V_2)-median(yb2V_2);
        bootdmxV3_2(iB) = median(xb3V_2)-median(yb3V_2);
        
     end
     
    cidmxV1(i,:) = prctile(bootdmxV1_2,tailpercV);
    cidmxV2(i,:) = prctile(bootdmxV2_2,tailpercV);
    cidmxV3(i,:) = prctile(bootdmxV3_2,tailpercV);
    
 end
ci_temp_teliko = mean(cidmxV1);
ci_rh_teliko = mean(cidmxV2);
ci_wind_teliko = mean(cidmxV3);

fprintf('CI for all the samples\n');
fprintf('CI for median difference for temperature [%1.3f %1.3f]\n',ci_temp(1),ci_temp(2));
fprintf('CI for median difference for rh [%1.3f %1.3f]\n',ci_rh(1),ci_rh(2));
fprintf('CI for median difference for wind [%1.3f %1.3f]\n',ci_wind(1),ci_wind(2));
%% Confidence Interval for all the samples and for M samples - Temperature
figure; 
histogram(cidmxV1(:,1));
hold on
histogram(cidmxV1(:,2));
hold on
plot(ci_temp(1)*[1 1],ylim,'-r')
hold on
plot(ci_temp(2)*[1 1],ylim,'-r')
title('95% Confidence Interval for median difference of temperature');
%% Confidence Interval for all the samples and for M samples - Relative Humidity
figure;
histogram(cidmxV2(:,1));
hold on
histogram(cidmxV2(:,2));
hold on
plot(ci_rh(1)*[1 1],ylim,'-r')
hold on
plot(ci_rh(2)*[1 1],ylim,'-r')
title('95% Confidence Interval for median difference of rh');
%% Confidence Interval for all the samples and for M samples - Wind 
figure;
histogram(cidmxV3(:,1));
hold on
histogram(cidmxV3(:,2));
hold on
plot(ci_wind(1)*[1 1],ylim,'-r')
hold on
plot(ci_wind(2)*[1 1],ylim,'-r')
title('95% Confidence Interval for median difference of wind');