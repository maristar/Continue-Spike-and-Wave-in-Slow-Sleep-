% 30-8-2011
x1V_all=result_pre;
x2V_all=result_post;
nbin = 50;
nchan=10;
name=resultscor.filename(1:end-4);
s=resultscor.s;

for kk=1:nchan
    for jj=1:nchan
        if kk~=jj
            x1V=squeeze(x1V_all(kk,jj,:));
            x2V=squeeze(x2V_all(kk,jj,:));
            n1=length(x1V); n2=length(x2V);
            % Histogram computation
            [Nx1,Xx1]=hist(x1V,nbin);
            [Nx2,Xx2]=hist(x2V,nbin);

            % Compuation of ROC and AUROC
            classV = [ones(n1,1);zeros(n1,1)];
                     
            
            xV = [x1V;x2V];
            [tpV, fpV] = myroc(classV,xV);
            AUROC = myauroc(tpV,fpV);
            % If the samples are in an order so that ROC is under the diagonal, just
            % reverse true positives and false positives to look nice
            if AUROC < 0.5
                tmp = tpV;
                tpV = fpV;
                fpV = tmp;
                AUROC = 1-AUROC;
            end
            [H,p,ci]=ttest2(x1V_temp,x2V_temp);  
            % Plot the histogram curves
            chan1=cell2mat(s(kk)); chan2=cell2mat(s(jj)); 
            figure; subplot(2,1,1);
            plot([Xx1(1) Xx1 Xx1(end)],[0 Nx1 0],'b'); 
            hold on
            plot([Xx2(1) Xx2 Xx2(end)],[0 Nx2 0],'r')
            xlabel('x')
            ylabel('counts')
            
            % Plot the ROC curve
            %figure;
            %clf
            subplot(2,1,2);
            plot(fpV,tpV,'b')
            hold on
            plot([0 1],[0 1],'c')
            xlabel('false positives')
            ylabel('true positives')
            title(sprintf('AUROC=%1.3f t-test:p-val=%1.5f CI=[%f,%f], chan1=%2s, chan2=%2s',AUROC,p,ci(1),ci(2), chan1, chan2))
            stemp=['AUROC-' name '-' textmeasure3{1} '-' num2str(chan1)  '-' num2str(chan2)];
            saveas(gcf, stemp, 'fig');
       close all
        end
        end
end