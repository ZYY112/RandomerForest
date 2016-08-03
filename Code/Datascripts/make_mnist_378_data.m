close all
clear
clc

rng(1);

load MNIST_train

ns = [100 300 1000 3000];
Labels = [3,7,8];

ntrials = 10;

for k = 1:length(ns)
        nTrain = ns(k);
    
    for trial = 1:ntrials

        Idx = [];
        for l = 1:length(Labels)
            Idx = [Idx randsample(find(Y==Labels(l)),round(nTrain/length(Labels)))'];
        end
        TrainIdx{k}(trial,:) = Idx;
    end
end

save('~/Documents/MATLAB/Data/MNIST_378_train_indices.mat','ns','ntrials',...
    'TrainIdx')