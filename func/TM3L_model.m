function [ loss,Z] = TM3L_model(d,X,para)

lambda=para.lambda;
alpha=para.alpha;
C=para.C;
choose1=para.choose1;
maxIter=para.maxIter;
num_views=length(X);
epsilon=10^-3;
Q=cell(num_views,1);

for i=1:num_views
    X{i}=X{i}';
    [dd(i),n]=size(X{i});
    Q{i}=rand(dd(i),d);
end

Z=rand(d,n);
theta=ones(num_views,1)/num_views;
preloss=zeros(num_views,1);
QLoss=zeros(num_views,1);

tol=0.002;
iter=1;
loss=0;
delta=2;
H = -ones(d,d)/d + eye(d); 

while iter<=maxIter && abs(delta)>tol
%     fprintf('Running iter1 number - %d/%d \n',iter,maxIter);
    %% update Q
    K = zeros(d,d);
    for uu=1:num_views
        j = 1 : num_views;
        index = setdiff(j,uu);
        for ii = 1: length(index)
            Ktemp =   -H * Q{index(ii)}' * Q{index(ii)} * H;
            K = K + Ktemp;
        end
        Q{uu}=(theta(uu)*X{uu}*Z')*pinv(theta(uu)*Z*Z' + n*lambda*K + 1e-8*speye(d));
        Q{uu}=Q{uu}./max(1e-12,norm(Q{uu},2));       
    end
    QTQ=zeros(d,d);
    QTX=zeros(d,n);
    for v=1:num_views
        QTQ=QTQ+Q{v}'*Q{v};
        QTX=QTX+Q{v}'*X{v};
        preloss(v,1)=norm(X{v}-Q{v}*Z,'fro')^2+num_views*C*norm(Z,'fro')^2;
        Loss(v,1)=1/num_views*lambda*trace(Q{uu}*K*Q{uu}');
        QLoss(v,1)=norm(QTQ-speye(d),'inf');
    end
    %% update Z
    Z_1=(QTQ+(num_views*C)*speye(d))\(QTX); 
    Z=Z_1;
    if choose1==1
       theta = updateTheta(theta, alpha, preloss);
    end
   
    totalloss=1/(n*num_views)*theta'*preloss+sum(Loss)+alpha*theta'*theta; 
    if totalloss<epsilon&&sum(QLoss)<epsilon
       break
    end

    if loss == 0
        loss = totalloss;
    elseif loss >= 0
        loss = [loss,totalloss];
    end
    iter=iter+1;
end
fprintf('\n - theta: ');
for mm=1:num_views
    fprintf('%.3f, ', theta(mm));
end
fprintf('\n');
end
function [theta_t ] = updateTheta(theta, lambda, q)
    m = length(theta);
    negative = 0;
    theta_t = zeros(m,1);
    
    for i =1:m
       theta_t(i,1) = (lambda+sum(q) - m*q(i))/(m*lambda);
       if theta_t(i,1) < 0
           negative = 1;
           theta_t(i,1) = 0.0000001;
       end
    end
    if negative == 1
       theta_t = theta_t./sum(theta_t);
    end
end
