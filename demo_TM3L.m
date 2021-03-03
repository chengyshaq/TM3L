%%%%%%%%%%%
% This is an examplar file on how the TM3L [1] program could be used.
% - [1] Zhao D, Gao Q, Lu Y, et al. Two-step multi-view and multi-label learning with missing label via subspace learning[J]. Applied Soft Computing, 2021, 102: 107120.
% - This package was developed by Mr. Da-Wei Zhao (zhaodwahu@163.com). For any problem concerning the code, please feel free to contact Mr. Zhao.
%%%%%%
clear;clc
addpath('evaluation');
addpath('func');
load('MVMLyeast.mat')
para.lambda = 10^-5;%-4.-5
para.beta   = 10^4;%4,5
para.C      = 10^-1;%-1
para.alpha  = 10^5;%4,5
para.choose1=1;
para.choose2=1;
para.LabelMaskRatio = 1.0; 
para.maxIter        = 60;
para.C1             = 1.0;    %正则参数 1.0 0.1 0.01
para.Kpara          = 1.0;    %RBF核参数
para.searchPara     = 0;
para.dratio         = 0.9;
%%search para
para.alpha_searchrange  = 10.^[5]; %5
para.beta_searchrange   = 10.^[4];%4
para.lambda_searchrange = 10.^[-5:5];%-4
para.C_searchrange      = 10.^[-1];%-1 
para.dratio_searchrange = [0.9];%-1
para.tuneParaOneTime    = 1;
%% Tune the parametes
if para.searchPara == 1
    if (para.tuneParaOneTime == 1) && (exist('BestResult','var')==0)
        fprintf('\n-  parameterization for TM3L by cross validation on the training data');
        [Result] = TM3L_adaptive_validate( dataMVML, target, para);
    elseif (para.tuneParaOneTime == 0)
        fprintf('\n-  parameterization for TM3L by cross validation on the training data');
        [Result] = TM3L_adaptive_validate( dataMVML, target, para);
    end
else
    [loss,result,time] = TM3L(dataMVML,target,para);
    [Avg_Result] = PrintTM3LAvgResult(result,time,5);
end
endtime = datestr(now,0);
fprintf('End Run TM3L at time:%s \n',endtime);
rmpath('evaluation');
rmpath('func');