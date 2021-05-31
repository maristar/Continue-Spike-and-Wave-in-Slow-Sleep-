n1 = 30;
n2 = 40;
displacement = 0.4;
nbin = 50;

% Generate of two samples.
x1V = randn(n1,1);
x2V = displacement+randn(n2,1);

% Histogram computation
[Nx1,Xx1]=hist(x1V,nbin);
[Nx2,Xx2]=hist(x2V,nbin);

% Compuation of ROC and AUROC
classV = [ones(n1,1);zeros(n1,1)];
xV = [x1V;x2V];
[tpV, fpV] = myroc(classV,xV);
AUROC = myauroc(tpV,fpV);
% If the samples are in an order so that ROC is under the diagonal, just
% reverse true positives and false positives to look nice.
if AUROC < 0.5
    tmp = tpV;
    tpV = fpV;
    fpV = tmp;
    AUROC = 1-AUROC;
end
[H,p,ci]=ttest2(x1V,x2V);  

% Plot the histogram curves
figure(1)
clf
plot([Xx1(1) Xx1 Xx1(end)],[0 Nx1 0],'b')
hold on
plot([Xx2(1) Xx2 Xx2(end)],[0 Nx2 0],'r')
xlabel('x')
ylabel('counts')
legend('data1','data2','Location','Best')

% Plot the ROC curve
figure(2)
clf
plot(fpV,tpV,'b')
hold on
plot([0 1],[0 1],'c')
xlabel('false positives')
ylabel('true positives')
title(sprintf('AUROC=%1.3f t-test:p-val=%1.5f CI=[%f,%f]',AUROC,p,ci(1),ci(2)))
