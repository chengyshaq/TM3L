
function [loss,result,time] =TM3L( data,target,para)

fprintf('Start Run TM3L at time:%s \n',datestr(now));
LabelMaskRatio=para.LabelMaskRatio;
beta=para.beta;
dratio=para.dratio;
choose2=para.choose2;
d_range=zeros(1,length(data));
for dd=1:length(data)
    d_range(1,dd)=size(data{dd},2);
end
d=floor(min(d_range)*dratio);
newdata=data;
round=5;
result=cell(round,1);
time = zeros(1,round);
%% Solving the objective function
tic
[ loss,Z] = TM3L_model(d,newdata,para);
for run=1:round
%     fprintf('Running Fold - %d/%d \n',run,round);
    [Ndata,Nlabel]=size(target);
    train_num=ceil(Ndata*0.8);
    indexperm=randperm(Ndata);
    train_index=indexperm(1,1:train_num);
    test_index=indexperm(1,train_num+1:end);

    train_data=Z(:,train_index);
    train_label=target(train_index,:);

    %% create missing labels
    label=full(target);
    test_data=Z(:,test_index);
    test_label=target(test_index,:);
    obrT = Mark_label(label,train_index,LabelMaskRatio);
    if  min(min(label))==-1
        label=(label+1)/2;
    end
    EstiY=label.*obrT;
    Omega_linear=find(obrT(train_index,:));
%     Omega_linear=1:train_num;
    iter=1;
    l=size(label,2);
    S=eye(l);
%     S=CosLCorr(label);
%     fprintf('Predict labels \n');
    if choose2==1
        while iter<=5
            [Outputs,Ytrain] = MLRKELM(train_data',EstiY(train_index,:),test_data',test_label,para,S);

                [S,~]=Maxide(EstiY(train_index,:),Omega_linear,Ytrain,eye(size(train_label,2)),beta,60);
        %         [S,~]=Maxide(train_label,Omega_linear,Ytrain,eye(size(train_label,2)),beta,60);
                S(S<0)=0;
                S=S-diag(diag(S))+diag(ones(size(S,1),1));

            preloss=0.5*norm(Ytrain*S-EstiY(train_index,:),'fro')^2+beta*norm(S);
            if preloss<10^-3
                break;
            end
%             loss2(iter,1)=preloss; 
            iter=iter+1;
        end
    else
        [Outputs,Ytrain] = MLRKELM(train_data',EstiY(train_index,:),test_data',test_label,para,S);
    end
    threshold = tuneThresholdMVML(train_label,Ytrain*S);
    Pre_Labels   = Outputs >= threshold(1,1); 
    Pre_Labels   = double(Pre_Labels);
    result{run,1}  = EvaluationAll(Pre_Labels,Outputs,test_label');
    time(1,run) = toc;
end

end
function threshold = tuneThresholdMVML(Ytrain,Outputs)
    [ threshold,  ~] = TuneThreshold( Outputs, Ytrain, 1, 1);
end

 


