function [ obrT ] = Mark_label(hatT, train_index,percent)
obrT=zeros(size(hatT));
remainT=hatT(train_index,:);
[n,q]=size(hatT);
for iii=1:q
    positive_index=find(remainT(:,iii)>0);
    positive_number=length(positive_index);
    positive_random=randperm(positive_number);
    positive_select=positive_index(positive_random(1,1:ceil(positive_number*percent)),1);
    negative_index=find(remainT(:,iii)<=0);
    negative_number=length(negative_index);
    negative_random=randperm(negative_number);
    negative_select=negative_index(negative_random(1,1:ceil(negative_number*percent)),1);
    obrT(train_index(1,positive_select),iii)=1;
    obrT(train_index(1,negative_select),iii)=1;
end
end

