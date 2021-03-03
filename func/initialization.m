

function [para,modelparameter] =  initialization
    para.alpha=10^-2;
    para.beta=10^-2;
    para.MaskRatios=0.2;
    para.LabelMaskRatio=0.2;

    para.outputthetaQ      = 1;
    para.tuneParaOneTime = 1;
    %% Model Parameters
    modelparameter.tuneThresholdType  = 1; % 1:Hloss, 2:Acc, 3:F1, 4:LabelBasedAccuracy, 5:LabelBasedFmeasure, 6:SubACC 
    modelparameter.crossvalidation    = 1; % {0,1}
    modelparameter.cv_num             = 1;
    modelparameter.L2Norm             = 1; % {0,1}
    modelparameter.output_tempresults = 0;   % {0,1}
    modelparameter.splitpercentage    = 0.8; %[0,1]
end