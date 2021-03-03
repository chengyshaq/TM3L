% function [HammingLoss,RankingLoss,OneError,Coverage,Average_Precision,Outputs,Pre_Labels] = MLRKELM(X,Y,Xt,Yt,parameter)
function [Outputs,Ytrain] = MLRKELM(X,Y,Xt,Yt,para,S)
C = para.C1;
Kpara = para.Kpara;

[OutputWeight,Omega_test,Ytrain] = kelmtrain (X, (Y*S')/(S*S'), Xt, C, Kpara);

TY = kelmpredict (OutputWeight,Omega_test);

Outputs = (TY*S)'; 

end