function roc = computeROCArea(roc)
% From derek
%ind = find([true (roc.fp(2:end)~=roc.fp(1:end-1))]);

ind = find([true (roc.conf(2:end-1)~=roc.conf(1:end-2))' true]);
dfp = roc.fp(ind(2:end)) - roc.fp(ind(1:end-1));
avetp = (roc.tp(ind(1:end-1))+roc.tp(ind(2:end)))/2;
roc.area = sum(avetp/(roc.tp(end)+eps) .* dfp/(roc.fp(end)+eps));
%plot(roc.fp/roc.fp(end), roc.tp/roc.tp(end))