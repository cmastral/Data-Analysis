clear;
close all;
%% Import Data
datM = importdata('forestfires.txt');
%% Parameters
% number of all observations
m = length(datM(:,1));
% alpha - confidence level
alpha = 0.05;
% M - Number of samples
M = 100;
% B - number of Bootstrap Samples
B = 1000;
% n - sample size
n = 40;
%% Temperature and Relative Humidity Attributes
tempV = datM(:,9);
rhV = datM(:,10);
%% Linear Regression Model for all the observations
%Montelo grammikis palindromisis gia oles tis paratiriseis-beta
[b_rh,bint_rh,~,~,stats_rh] = regress(rhV,[ones(m,1) tempV]);
b0 = b_rh(1);
b1 = b_rh(2);
figure;
scatter(tempV,rhV)
yhat_rhV = [ones(m,1) tempV]*b_rh;
hold on
plot(tempV,yhat_rhV)
%% Parametric and Bootstrap CI estimations
ballM = NaN(M,2);
bintall = NaN(M,4);
bbM = NaN(M,2);
b0cibootV = NaN(M,2);
b1cibootV = NaN(M,2);
indxlow = round(B*alpha/2);
indxupp = round(B*(1-alpha/2));

for i = 1:M
idx = unidrnd(m,n,1);
x = tempV(idx);
y1 = rhV(idx);
[b,bint,~,~,stats] = regress(y1,[ones(n,1) x]); 
ballM(i,:) = b'; 
% parametric confidence interval for b0 and b1
bintall(i,1:2) = bint(1,:);
bintall(i,3:4) = bint(2,:);

    for j = 1:B
        indxV = unidrnd(n,n,1);
        xbV = x(indxV);
        ybV = y1(indxV);
        xbM = [ones(n,1) xbV];
        bboot = regress(ybV,xbM);
        bbM(j,:) = bboot(:)'; % b0 and b1 for every bootstrap
    end
% bootstrap ci for each M sample
ob0V = sort(bbM(:,1)); %sort for b0
b0cibootV(i,:) = [ob0V(indxlow) ob0V(indxupp)]; 
ob1V = sort(bbM(:,2)); %sort for b1
b1cibootV(i,:) = [ob1V(indxlow) ob1V(indxupp)]; 

end 

sum0=0;
sum1=0;
sum2=0;
sum3=0;
for i=1:M 
   if(b0>bintall(i,1) && b0<bintall(i,2))
       sum0=sum0+1;
   end
   if(b1>bintall(i,3) && b1<bintall(i,4)) 
       sum1=sum1+1;
   end
  if(b0>b0cibootV(i,1) && b0<b0cibootV(i,2))
       sum2=sum2+1;
   end
   if(b1>b1cibootV(i,1) && b1<b1cibootV(i,2)) 
       sum3=sum3+1;
   end   
end

fprintf('b0 is between the parametric confidence interval with a percentage of: %f\n',sum0/M);
fprintf('b0 is between the bootstrap confidence interval with a percentage of: %f\n',sum2/M);
fprintf('b1 is between the parametric confidence interval with a percentage of: %f\n',sum1/M);
fprintf('b1 is between the bootstrap confidence interval with a percentage of: %f\n',sum3/M);
%% Figures
figure;
histogram(ballM(:,1));
title('Distribution of b0')
hold on
plot(b0*[1 1],ylim,'-r')
figure;
histogram(ballM(:,2));
hold on
plot(b1*[1 1],ylim,'-r')
title('Distribution of b1')