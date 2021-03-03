function [row,column]=index2spa(Omega_linear,n)
if size(Omega_linear,1)==1
    Omega_linear=Omega_linear';
end

row=mod(Omega_linear,n);
row(find(row==0))=n;
column=((Omega_linear-row)/n)';
column=column+1;
row=row';
%[row,i_row]=sort(row,'ascend');
%column=column(i_row);
%[column,i_column]=sort(column,'ascend');
%row=row(i_column);