function [Z,Z_lo]=Maxide(M_Omega,Omega_linear,A,B,lambda,max_iter)
%ProSVM implements the algorithm Maxide proposed in [1]
%
%    Syntax
%
%       [M_recover,telapsed]=Maxide(M_Omega,Omega_linear,A,B,lambda,max_iter)
%
%    Description
%
%       Maxide takes,
%           M_Omega       - n\times m, the target matrix with only observed
%                           entries when the unobserved entries are 0 .
%           Omega_linear  - A vector recording the observed positions
%                           in the target matrix. If the (i,j)th entry is 
%                           observed, a value (j-1)*n+i is recorded in Omega_linear.
%           A             - the side information matrix where left singular
%                           vectores lie in. 
%           B             - the side information matrix where right singular 
%                           vectores lie in.
%           lambda        - the regularization parameter
%           max_iter      - maximum number of iterations
%      and returns,
%			M_recover     - the recoverd matrix
%           telapsed      - the training time measures in seconds
%
%[1] Miao Xu, Rong Jin and Zhi-Hua Zhou. Speed up matrix completion with
%side information: application to multi-label learning. In: NIPS'13.


%% Initialization
t1=tic;

Omega_linear=sort(Omega_linear,'ascend');
[n,m]=size(M_Omega);
tag='';
if (size(B,1)==size(B,2))&&isequal(B,eye(m))
    tag='Multi_Label';
end
%M_norm=norm(M,'fro');
[row,column]=index2spa(Omega_linear,n);

r_a=size(A,2);
r_b=size(B,2);

L=1;
gamma=2;
Z0=zeros(r_a,r_b);
Z=Z0;
alpha0=1;
alpha=1;

i=0;
convergence=zeros(max_iter,1);
if strcmp(tag,'Multi_Label')
	svdt3=A'*M_Omega;
else
    svdt3=A'*M_Omega*B;
end
M_Omega_linear=full(M_Omega(Omega_linear))';
if strcmp(tag,'Multi_Label')
	AZ0BOmega=multi_partial(A*Z0,Omega_linear);
else
    AZ0BOmega=xumm(A*Z0,B',row,column);
end

AZBOmega=AZ0BOmega;
Z_loss=0;
%% Iteration
while i<max_iter
    i=i+1;
    %disp(['Enter Iteration' num2str(i)]);
    
    %disp('Updata Z');
    Y=Z+alpha*(1/alpha0-1)*(Z-Z0);
    Z0=Z;
    AYBOmega=(1+alpha*(1/alpha0-1))*AZBOmega-(alpha*(1/alpha0-1))*AZ0BOmega;
    if strcmp(tag,'Multi_Label')
        svdt2=A'*(sparse(row,column,AYBOmega,n,m)); 
    else
        svdt2=A'*(sparse(row,column,AYBOmega,n,m))*B;
    end
     
    Z=sidesvd2Threshold(Y,svdt2,svdt3,L,lambda);
    AZ0BOmega=AZBOmega;
    if strcmp(tag,'Multi_Label')
        AZBOmega=multi_partial(A*Z,Omega_linear);
    else
        AZBOmega=xumm(A*Z,B',row,column);
    end
    
    %disp('Try to find the appropriate L');
    qlpl1=norm(AYBOmega-M_Omega_linear,'fro')^2/2;
    qlpl2=svdt2-svdt3;
    DiffL2=norm(AZBOmega-M_Omega_linear,'fro')^2/2;
    while DiffL2>Qlpl(Z,Y,L,qlpl1,qlpl2)
        L=L*gamma;
        %disp(['L=' num2str(L)]);
        Z=sidesvd2Threshold(Y,svdt2,svdt3,L,lambda);
        if strcmp(tag,'Multi_Label')
            AZBOmega=multi_partial(A*Z,Omega_linear);
        else
            AZBOmega=xumm(A*Z,B',row,column);
        end
        DiffL2=norm(AZBOmega-M_Omega_linear,'fro')^2/2;
    end

    %disp('Updata alpha');
    alpha0=alpha;
    alpha=(sqrt(alpha^4+4*alpha^2)-alpha^2)/2;
    
    %disp('calculate the objective to show convergence');
    convergence(i,1)=sideobjectCalc(Z,lambda,DiffL2);
    Z_loss=convergence(i,1)-DiffL2;
    %disp('calculate the difference to ensure convergence')
      if i>1
          if abs(convergence(i,1)-convergence(i-1,1))<(1e-5)*convergence(i,1)
%                 disp(strcat('end at the ',31,num2str(i),'th iteration'));
                break;
          end
      end
end
 Z_lo=convergence(i,1);
%% Preparing the return
% if i==max_iter
%     warning('reach maximum iteration~~do not converge!!!');
% end

% % if strcmp(tag,'Multi_Label')
% %     M_recover=A*Z;
% % else
% %     M_recover=A*Z*B';
% % end

telapsed=toc(t1);
