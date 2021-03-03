
% function [ResultHL,ResultAUC] = TM3L_adaptive_validate( data, target, oldPara)
function [Result] = TM3L_adaptive_validate( data, target, oldPara)
    para         = oldPara;

    alpha_searchrange     = oldPara.alpha_searchrange;
    beta_searchrange     = oldPara.beta_searchrange;
    lambda_searchrange     = oldPara.lambda_searchrange;    
    C_searchrange     = oldPara.C_searchrange;    
    dratio_searchrange = oldPara.dratio_searchrange;  
    num_cv = 5;
    index = 1;
    total = length(alpha_searchrange)*length(beta_searchrange)*length(lambda_searchrange)*length(C_searchrange)*length(dratio_searchrange);
%     ResultHL = zeros(length(lamda3_searchrange),length(lamda4_searchrange));
%     ResultAP = zeros(length(lamda3_searchrange),length(lamda4_searchrange));
%     num_train             = size(data,1);
%     randorder             = randperm(num_train);
    for i=1:length(alpha_searchrange) % lamda1
        for j=1:length(beta_searchrange) % lamda2
             for l=1:length(lambda_searchrange)%lamda4
                for k=1:length(C_searchrange)%lamda4
                    for p=1:length(dratio_searchrange)
                           fprintf('\n-   %d-th/%d: search parameter alpha to C for TM3L, alpha = %f, beta = %f, lambda = %f, and C = %f',index, total, alpha_searchrange(i), beta_searchrange(j),lambda_searchrange(l), C_searchrange(k));
                            index = index + 1;
                            
                            para.alpha   = alpha_searchrange(i); % label correlation
                            para.beta   = beta_searchrange(j);  % sparsity
                            para.lambda   = lambda_searchrange(l); % {0.01, 0.1}
                            para.C   = C_searchrange(k); % {0.01, 0.1}
                            para.dratio = dratio_searchrange(p);
%                             para.LabelMaskRatio=0.60; 
%                             para.maxIter=60;
%                             para.C1 = 1.0;        %正则参数 
%                             para.Kpara = 1.0;    %RBF核参数
%                             para.maxIter           = 100;
%                             para.minimumLossMargin = 0.001;
%                             para.outputtempresult  = 0;
%                             para.drawConvergence   = 0;

%                             cvResult = zeros(16,num_cv);
%                             for cv = 1:num_cv
% %                                 [cv_train_data,cv_train_target,cv_test_data,cv_test_target ] = generateCVSet( data,target',randorder,cv,num_cv);
% %                                 [model_zdw]  = zdw2( cv_train_data, cv_train_target,optmParameter);
% %                                 cvResult(:,cv)    =  EvaluationAll(Pre_Labels,Outputs,cv_test_target');
%                             end
                             [~,result,time] = TM3L(data,target,para);
%                             Avg_Result = zeros(16,2);
                             [Avg_Result] = PrintTM3LAvgResult(result,time,num_cv);
%                             Avg_Result(:,1)=mean(cvResult,2);
                            Result.ResultHL(l)=Avg_Result(1,1);
                            Result.ResultSA(l)=Avg_Result(6,1);
                            Result.ResultAP(l)=Avg_Result(12,1);
                            Result.ResultOE(l)=Avg_Result(13,1);
                            Result.ResultRL(l)=Avg_Result(14,1);
                            Result.ResultCV(l)=Avg_Result(15,1);
                            Result.ResultAUC(l)=Avg_Result(16,1);
                    end
                end
             end
         end
    end
end

