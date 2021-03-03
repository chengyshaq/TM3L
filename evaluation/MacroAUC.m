function AUC = MacroAUC(score,Y)
% socre ; n by l
% Y     : n by l
%
    k = size(Y,2);
    AUC_ind = zeros(k,1);
    for i = 1 : k
        [uparea AUC_ind(i)] = roc(score(:,i), Y(:,i));
    end
    AUC =mean(AUC_ind);
end


function [up_area down_area] = roc(pred,y)

% pred denotes the vector with prediction value
% y denotes the vector with data label

[val ind] = sort(pred);


TP = length(find(y==1));
FP = length(find(y==-1));
FN = 0;
TN = 0;


for i = 1:length(pred)
    k =  ind(i);
    if y( k ) == 1
        TP = TP - 1;
        FN = FN + 1;
        
    else if y( k ) == -1
            FP = FP - 1;
            TN = TN + 1;
         end
    end
    if (TP + FN) == 0
        TPR( i ) = 0;
    else
        TPR( i ) = TP / (TP + FN);
    end
    if (FP + TN) == 0
        FPR( i ) = 0;
    else
        FPR( i ) = FP / (FP + TN);
    end
end

TPR = [1 TPR];  
TPR = TPR(length(TPR):-1:1);

FPR = [1 FPR];
FPR = FPR(length(FPR):-1:1);

up_area = 0;
down_area = 0;
for i = 2 : length(pred)+1
    up_area = up_area + (TPR(i) - TPR(i-1))  * FPR(i);
    down_area = down_area + (FPR(i) - FPR(i-1))  * TPR(i);
end

end
