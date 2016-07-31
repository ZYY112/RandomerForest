close all
clear
clc

fpath = mfilename('fullpath');
rerfPath = fpath(1:strfind(fpath,'RandomerForest')-1);

rng(1);

ntrain = 100;
ntest = 10000;
dims = [2 10 50 100 500 1000];
ndims = length(dims);
ntrials = 10;
Class = [0;1];
Xtrain = cell(1,ndims);
Ytrain = cell(1,ndims);
Xtest = cell(1,ndims);
Ytest = cell(1,ndims);

for i = 1:ndims
    d = dims(i);
    d_idx = 1:d;
    mu1 = 1./sqrt(d_idx);
    mu0 = -1*mu1;
    Mu = cat(1,mu0,mu1);
    Sigma = ones(1,d);
    obj = gmdistribution(Mu,Sigma);
    x = zeros(ntrain,d,ntrials);
    y = cell(ntrain,ntrials);
    for trial = 1:ntrials
        [x(:,:,trial),idx] = random(obj,ntrain);
        y(:,trial) = cellstr(num2str(Class(idx)));
    end
    Xtrain{i} = x;
    Ytrain{i} = y;
    [Xtest{i},idx] = random(obj,ntest);
    Ytest{i} = cellstr(num2str(Class(idx)));
end

save([rerfPath 'RandomerForest/Data/Trunk_data.mat'],'Xtrain','Ytrain',...
    'Xtest','Ytest','ntrain','ntest','dims','ntrials')