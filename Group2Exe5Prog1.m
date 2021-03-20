clear;
close all;
%% Import Data
datM = importdata('forestfires.txt');
%% Parameters
% number of all observations
m = length(datM(:,1));
% pick 40 observations
n = 40;
% alpha - confidence level
alpha = 0.05;
%% Temperature, Relative Humidity and Wind Attributes
tempV = datM(:,9);
rhV = datM(:,10);
windV = datM(:,11);

idx = unidrnd(m,n,1);
x = tempV(idx);
y1 = rhV(idx);
y2 = windV(idx);
%% Linear Regression Model 
% Dependent value -> Relative Humidity 
% Independent value -> Temperature 
[b_rh,bint_rh,~,~,stats_rh] = regress(y1,[ones(n,1) x]) %ektimish tou montelou grammikis palindromisis RH ws pros temp
figure(1)
scatter(x,y1) 
yhat_rhV=[ones(n,1) x]*b_rh;
hold on
plot(x,yhat_rhV)
xlabel('temperature');
ylabel('RH');
title('Linear regression model');
%% Diagnostic Plot
e_rhV = y1-yhat_rhV;  
se2_rh = stats_rh(4);
se_rh = sqrt(se2_rh);
estar_rhV = e_rhV ./ se_rh;
zcrit = norminv(1-alpha/2);
figure(2)
clf
plot(y1,estar_rhV,'.') 
hold on
ax = axis;
plot([ax(1) ax(2)],zcrit*[1 1],'c--')
plot([ax(1) ax(2)],-zcrit*[1 1],'c--')
title('Diagnostic plot for RH');
%% Linear Regression Model 
% Dependent value -> Relative Humidity 
% Independent value -> Wind 
[b_wind,bint_wind,~,~,stats_wind] = regress(y2,[ones(n,1) x]) 
figure;
scatter(x,y2)
yhat_windV=[ones(n,1) x]*b_wind;
hold on
plot(x,yhat_windV)
xlabel('temperature');
ylabel('wind');
title('Linear regression model');
%% Diagnostic Plot
e_windV = y2-yhat_windV;
se2_wind = stats_wind(4);
se_wind = sqrt(se2_wind);
estar_windV = e_windV ./ se_wind;
figure;
clf
plot(y2,estar_windV,'.')
hold on
ax = axis;
plot([ax(1) ax(2)],zcrit*[1 1],'c--')
plot([ax(1) ax(2)],-zcrit*[1 1],'c--')
title('Diagnostic plot for wind');