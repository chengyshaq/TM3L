function Graph = ConsG_KNN( origin_data,k)
%CONSG_KNN Summary of this function goes here
% %------------------------------------------------%

[n,~]=size(origin_data);
 distance=EuDist2(origin_data,origin_data,1);
Graph=diag(ones(n,1));
for i=1:n
   [~,index]=sort(distance(i,:),'ascend');
   Graph(i,index(2:k+1))=1;
   Graph(index(2:k+1),i)=1; 
end
end

