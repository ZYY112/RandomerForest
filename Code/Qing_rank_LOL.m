%Plot optimal LOL projection of Qing's data, including unknowns

clear
close
clc

fpath = mfilename('fullpath');
findex = strfind(fpath,'/');
rootDir=fpath(1:findex(end-1));
p = genpath(rootDir);
gits=strfind(p,'.git');
colons=strfind(p,':');
for i=0:length(gits)-1
endGit=find(colons>gits(end-i),1);
p(colons(endGit-1):colons(endGit)-1)=[];
end
addpath(p);

[data,txt,raw] = xlsread('Qing Dataset 70 Samples Unnormalized (12-16-2014).xlsx');
Xtrain = data(:,1:46)';
Xtrain_rank = passtorank(Xtrain);
Xtest = data(:,47:end)';
Ytrain = zeros(size(Xtrain_rank,1),1);
Ytrain(27:46) = 1;
Xtest_rank = interpolate_rank(Xtrain,Xtest);
Ystr = cellstr(num2str(Ytrain));

parms.types={'DENL'};
parms.Kmax = 3;

Proj = LOL(Xtrain_rank,Ystr,parms.types,parms.Kmax);
Xtrain_LOL = Xtrain_rank*transpose(Proj{1}.V);
Xtest_LOL = Xtest_rank*transpose(Proj{1}.V);

linclass = fitcdiscr(Xtrain_LOL,Ystr);

plot3(Xtrain_LOL(Ytrain==0,1),Xtrain_LOL(Ytrain==0,2),Xtrain_LOL(Ytrain==0,3),'bo',Xtrain_LOL(Ytrain==1,1),Xtrain_LOL(Ytrain==1,2),Xtrain_LOL(Ytrain==1,3),'rx',Xtest_LOL(:,1),Xtest_LOL(:,2),Xtest_LOL(:,3),'k.')
set(gcf,'Visible','On')
legend('Normal','Cancer','Unknown')

L = linclass.Coeffs(1,2).Linear;
K = linclass.Coeffs(1,2).Const;
x1 = linspace(-11e4,-1e4);
x2 = linspace(-800,-100);
[x1_hyper,x2_hyper] = meshgrid(x1,x2);
x3_hyper = (-L(1)*x1_hyper - L(2)*x2_hyper - K)/L(3);
hold on
sf = surf(x1_hyper,x2_hyper,x3_hyper);
sf.FaceColor = 'k';
sf.FaceAlpha = 0.4;
sf.EdgeAlpha = 0;
ln = findobj(gca,'Type','Line');
ln(1).Marker = '.';
ln(2).Marker = '.';
ln(3).Marker = '.';
ln(1).MarkerSize = 14;
ln(2).MarkerSize = 14;
ln(3).MarkerSize = 14;
ln(1).Color = 'm';
ln(2).Color = 'c';
ln(3).Color = 'g';
grid on
xlabel('k1')
ylabel('k2')
zlabel('k3')
title('LOL on Ranked Data')
fname = '~/Documents/MATLAB/CancerAnalysis/Plots/Qing_rank_LOL';
save_fig(gcf,fname)