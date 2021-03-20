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
% B - number of Bootstrap Samples
B = 1000;
%% Combinations
combos = nchoosek(5:11,2); % combinations of columns
c = length(combos); % number of combinations

rV = NaN(c,1);
tV = NaN(c,1);
hV = NaN(c,1);
rallM = NaN(B,c);
tallM = NaN(B,c);
idx = unidrnd(m,n,1);
tcrit = tinv(1-alpha/2,n-2);
lowlim = round((alpha/2)*B);
upplim = round((1-alpha/2)*B);

for i = 1:c
    % choose couple of attributes for parametric test 
    a = combos(i,1); 
    b = combos(i,2);
    x = datM(idx,a);
    y = datM(idx,b);
    rM = corrcoef(x,y);
    rV(i) = rM(1,2);
    tV(i) = rV(i)*sqrt((n-2)/(1-rV(i)^2)); % t statistic for all the combinations
    
    if(abs(tV(i))>tcrit)
        hV(i) = 1; % rejection
    else
        hV(i) = 0; % non rejection 
    end
    
    % randomization test
    for j = 1:B
        zM = [x y(randperm(n))];
        tmpM = corrcoef(zM);
        rallM(j,i) = tmpM(1,2);
    end
    
end

tallM = rallM.*sqrt((n-2)./(1-rallM.^2));
sorted_tallM = sort(tallM); 
tlV = sorted_tallM(lowlim,:); 
tuV = sorted_tallM(upplim,:);


  for i = 1:c
    if(hV(i) == 1)
       fprintf("\n Parametric test(alpha): rejection H0. Correlated Attributes: %d and %d  \n",combos(i,1),combos(i,2));
    else
       fprintf("\n Parametric test(alpha): rejection H1. Uncorrelated Attributes: %d and %d  \n",combos(i,1),combos(i,2)); 
    end
    if tcrit < abs(tlV(i)) || tcrit > abs(tuV(i))
        fprintf("\n Randomization test(alpha): rejection H0. Correlated Attributes: %d and %d  \n",combos(i,1),combos(i,2));
    else
        fprintf("\n Randomization test(alpha): rejection H1. Uncorrelated Attributes: %d and %d \n",combos(i,1),combos(i,2));
    end  
  end
