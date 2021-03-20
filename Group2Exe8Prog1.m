clear;
close all;
%% Import Data
datM = importdata('forestfires.txt');
%% Parameters
% n - number of all observations
n = length(datM(:,1));
% alpha - confidence level
alpha = 0.05;
% M - Number of samples
M = 100;
% b number of samples
b = 40;
% z - statistic
zcrit = norminv(1-alpha/2);

yV = datM(:,11);
xM = NaN(n,12);
xM(:,1:10) = datM(:,1:10);
xM(:,11:12) = datM(:,12:13);
xregM = [ones(n,1) xM];
my = mean(yV);

%% Stepwise Fit Regression for all observations
[bV,sdbV,pvalV,inmodel,stats] = stepwisefit(xM,yV);
b0 = stats.intercept;
indxV = find(inmodel==1); % attributes that were selected
yhatV = xregM * ([b0;bV].*[1 inmodel]');
eV = yV-yhatV;
k1 = sum(inmodel);
se2 = (1/(n-(k1+1)))*(sum(eV.^2));
se = sqrt(se2);
R2 = 1-(sum(eV.^2))/(sum((yV-my).^2));
adjR2 = 1-((n-1)/(n-(k1+1)))*(sum(eV.^2))/(sum((yV-my).^2));
estarV = eV / se;
%% Stepwise Fit Regression for M samples of b observations
inmodelM = NaN(M,12);
for i = 1:M
    indx = unidrnd(n,b,1);
    y = yV(indx,:);
    x = xM(indx,:);
    [~,~,~,inmodelV,~] = stepwisefit(x,y);
    % attributes that were selecetd for each M sample (row) have 1 in the
    % corresponding (column)
    inmodelM(i,:) = inmodelV;
    
end
suminmodel = sum(inmodelM); % how many times each attribute was selected

fprintf('Attributes that were selected for all observations: %d %d %d %d %d\n',indxV(1:5));
for j = 1:5
fprintf('At the M samples: the %d was selected with a percentage of %1.3f\n',indxV(j),suminmodel(indxV(j))/M);
end