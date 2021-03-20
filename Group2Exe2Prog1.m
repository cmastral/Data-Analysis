clear;
close all;
%% Import Data
datM = importdata('forestfires.txt');
%% Burnt Areas Attribute
% 0 value -> burnt, any other value -> non-burnt
yV = datM(:,13);
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
%% 95% Confidence Interval for mean differnce 
[~,~,ci_temp] = ttest2(temp0V,temp_burntV);
[~,~,ci_rh] = ttest2(rh0V,rh_burntV);
[~,~,ci_wind] = ttest2(wind0V,wind_burntV);
%% M = 50 number of samples -  n = 20 sample size
M = 50;
n = 20;
A1 = NaN(M,2);
A2 = NaN(M,2);
A3 = NaN(M,2);

for i = 1:M
    
    indxV0 = unidrnd(sum0,n,1);
    indxV1 = unidrnd(sum1,n,1);
    
    temp0_nV = temp0V(indxV0);
    temp_burnt_nV = temp_burntV(indxV1);
    
    rh0_nV = rh0V(indxV0);
    rh_burnt_nV = rh_burntV(indxV1);
    
    wind0_nV = wind0V(indxV0);
    wind_burnt_nV = wind_burntV(indxV1);
    
    [~,~,ci_9]  = ttest2(temp0_nV,temp_burnt_nV);
    [~,~,ci_10] = ttest2(rh0_nV,rh_burnt_nV);
    [~,~,ci_11] = ttest2(wind0_nV,wind_burnt_nV);
    
    A1(i,:) = ci_9';
    A2(i,:) = ci_10';
    A3(i,:) = ci_11';
end

ci_temp_n = mean(A1);
ci_rh_n = mean(A2);
ci_wind_n = mean(A3);

%% Confidence Interval for all the samples and for M samples - Temperature
figure;
histogram(A1(:,1));
hold on
histogram(A1(:,2));
hold on
plot(ci_temp(1)*[1 1],ylim,'-r')
hold on
plot(ci_temp(2)*[1 1],ylim,'-r')
title('95% Confidence Interval for mean difference of temperature');
%% Confidence Interval for all the samples and for M samples - Relative Humidity
figure;
histogram(A2(:,1));
hold on
histogram(A2(:,2));
hold on
plot(ci_rh(1)*[1 1],ylim,'-r')
hold on
plot(ci_rh(2)*[1 1],ylim,'-r')
title('95% Confidence Interval for mean difference of rh');
%% Confidence Interval for all the samples and for M samples - Wind
figure;
histogram(A3(:,1));
hold on
histogram(A3(:,2));
hold on
plot(ci_wind(1)*[1 1],ylim,'-r')
hold on
plot(ci_wind(2)*[1 1],ylim,'-r')
title('95% Confidence Interval for mean difference of wind');