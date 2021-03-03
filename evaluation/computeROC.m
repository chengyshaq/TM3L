function roc = computeROC(scores, labels)
% From Derek
[sval, sind] = sort(scores, 'descend');
roc.tp = cumsum(labels(sind)==1);
roc.fp = cumsum(labels(sind)==0);
roc.conf = sval;

roc = computeROCArea(roc);

% ind = find([true (roc.conf(2:end)~=roc.conf(1:end-1))']);
% dfp = roc.fp(ind(2:end)) - roc.fp(ind(1:end-1));
% avetp = (roc.tp(ind(1:end-1))+roc.tp(ind(2:end)))/2;
% roc.area = sum(avetp/roc.tp(end) .* dfp/roc.fp(end));

roc.p = roc.tp ./ (roc.tp + roc.fp);
roc.r = roc.tp / roc.tp(end);
