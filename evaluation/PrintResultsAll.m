
function PrintResultsAll(Result,tags)
fprintf('\n--------------------------------------------\n');
fprintf('Evalucation Metric       Mean      Std\n');
fprintf('--------------------------------------------\n');
num_views = -1;
num_tags = size(tags,1);
fprintf('                      ');
for i = 1:num_tags
   fprintf(['   ', tags{i},'\t\t ']);
end


fprintf('\n--------------------------------------------\n');
fprintf('HammingLoss           ');
for i = 1:(num_views+2)*2
    fprintf('   %.4f',Result(1,i));
end

fprintf('\rExampleBasedAccuracy  ');
for i = 1:(num_views+2)*2
    fprintf('   %.4f',Result(2,i));
end
fprintf('\rExampleBasedPrecision ');
for i = 1:(num_views+2)*2
    fprintf('   %.4f',Result(3,i));
end
fprintf('\rExampleBasedRecall    ');
for i = 1:(num_views+2)*2
    fprintf('   %.4f',Result(4,i));
end
fprintf('\rExampleBasedFmeasure  ');
for i = 1:(num_views+2)*2
    fprintf('   %.4f',Result(5,i));
end
fprintf('\rSubsetAccuracy        ');
for i = 1:(num_views+2)*2
    fprintf('   %.4f',Result(6,i));
end
fprintf('\rLabelBasedAccuracy    ');
for i = 1:(num_views+2)*2
    fprintf('   %.4f',Result(7,i));
end
fprintf('\rLabelBasedPrecision   ');
for i = 1:(num_views+2)*2
    fprintf('   %.4f',Result(8,i));
end
fprintf('\rLabelBasedRecall      ');
for i = 1:(num_views+2)*2
    fprintf('   %.4f',Result(9,i));
end
fprintf('\rLabelBasedFmeasure    ');
for i = 1:(num_views+2)*2
    fprintf('   %.4f',Result(10,i));
end
fprintf('\rMicroF1Measure        ');
for i = 1:(num_views+2)*2
    fprintf('   %.4f',Result(11,i));
end

fprintf('\rAverage_Precision     ');
for i = 1:(num_views+2)*2
    fprintf('   %.4f',Result(12,i));
end
fprintf('\rOneError              ');
for i = 1:(num_views+2)*2
    fprintf('   %.4f',Result(13,i));
end
fprintf('\rRankingLoss           ');
for i = 1:(num_views+2)*2
    fprintf('   %.4f',Result(14,i));
end
fprintf('\rCoverage              ');
for i = 1:(num_views+2)*2
    fprintf('   %.4f',Result(15,i));
end
fprintf('\rAUC                   ');
for i = 1:(num_views+2)*2
    fprintf('   %.4f',Result(16,i));
end
fprintf('\n');
end