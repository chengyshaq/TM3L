
function [LabelBasedAccuracy,LabelBasedPrecision,LabelBasedRecall,LabelBasedFmeasure, LabelBasedAccuracy_Per, LabelBasedPrecision_Per, LabelBasedRecall_Per, LabelBasedFmeasure_Per] = LabelBasedMeasure_ForEachLabel(test_targets,predict_targets)
% syntax
%   [LabelBasedAccuracy,LabelBasedPrecision,LabelBasedRecall,LabelBasedFmeasure]=LabelBasedMeasure(test_targets,predict_targets)
%
% input
%   test_targets        - L x num_test data matrix of groundtruth labels
%   predict_targets     - L x num_test data matrix of predicted labels
%
% output
%   LabelBasedAccuracy,LabelBasedPrecision,LabelBasedRecall,LabelBasedFmeasure


    [L,~]=size(test_targets);
    test_targets=double(test_targets==1);
    predict_targets=double(predict_targets==1);
    
    LabelBasedAccuracy=0;
    LabelBasedPrecision=0;
    LabelBasedRecall=0;
    LabelBasedFmeasure=0;
    
    LabelBasedAccuracy_Per = zeros(1,L);
    LabelBasedPrecision_Per = zeros(1,L);
    LabelBasedRecall_Per = zeros(1,L);
    LabelBasedFmeasure_Per = zeros(1,L);
    for i=1:L
        intersection=test_targets(i,:)*predict_targets(i,:)';
        union=sum(or(test_targets(i,:),predict_targets(i,:)));
        
        if union~=0
            LabelBasedAccuracy=LabelBasedAccuracy + intersection/union;
            LabelBasedAccuracy_Per(i) = intersection/union;
        end
        
        if sum(predict_targets(i,:))~=0
            precision_i = intersection/sum(predict_targets(i,:));
            LabelBasedPrecision_Per(i) = precision_i;
        else
            precision_i=0;
        end
        if sum(test_targets(i,:))~=0
            recall_i = intersection/sum(test_targets(i,:));
            LabelBasedRecall_Per(i) = recall_i;
        else
            recall_i=0;
        end
        LabelBasedPrecision=LabelBasedPrecision + precision_i;
        LabelBasedRecall=LabelBasedRecall + recall_i;
        if recall_i~=0 || precision_i~=0
            LabelBasedFmeasure = LabelBasedFmeasure + 2*recall_i*precision_i/(recall_i+precision_i);
            LabelBasedFmeasure_Per(i) = 2*recall_i*precision_i/(recall_i+precision_i);
        end
    end
    LabelBasedAccuracy=LabelBasedAccuracy/L;
    LabelBasedPrecision=LabelBasedPrecision/L;
    LabelBasedRecall=LabelBasedRecall/L;
    LabelBasedFmeasure = LabelBasedFmeasure/L;
end