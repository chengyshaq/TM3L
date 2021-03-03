function [OutputWeight,Omega_test,Y] = kelmtrain (P, T, Pt, C, Kernel_para)

n = size(T,1);
Omega_train = kernel_matrix(P, Kernel_para);
OutputWeight=((Omega_train+speye(n)/C)\(T));

Y=(Omega_train * OutputWeight);

Omega_test = kernel_matrix(P, Kernel_para,Pt);

function omega = kernel_matrix(Xtrain, kernel_pars,Xt)

nb_data = size(Xtrain,1);

if nargin<3,
    XXh = sum(Xtrain.^2,2)*ones(1,nb_data);
    omega = XXh+XXh'-2*(Xtrain*Xtrain');
    omega = exp(-omega./kernel_pars(1));
else
    XXh1 = sum(Xtrain.^2,2)*ones(1,size(Xt,1));
    XXh2 = sum(Xt.^2,2)*ones(1,nb_data);
    omega = XXh1+XXh2' - 2*Xtrain*Xt';
    omega = exp(-omega./kernel_pars(1));
end

