
function MacroAUC = MacroROC(Outputs,target,LP,LN)
% input
%   Outputs     a l by n matrix
%   target      a l by n label matrix
%   LP          label of positive pattern. e.g., 1
%   LN          label of negative pattern. e.g., 0
%
% output
%   MacroAUC
    
     num_class = size(target,1);
     AUC = zeros(1,num_class);
     AUC = 0;
     count = 0;
     for i =1:num_class

     [labelauc, curve] = LabelROC(Outputs(i,:), target(i,:), LP, LN);
     % plot(curve(:,1),curve(:,2)) 
     % plotroc(cv_test_target(1,:),Outputs(1,:))
     if labelauc > 1
         count = count + 1;
         continue;
     end
     AUC = AUC + labelauc;
     end
     MacroAUC = AUC/(num_class - count);
end