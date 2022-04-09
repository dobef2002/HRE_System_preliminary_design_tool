function J=J_cal(M,gamma1_cea)
r=gamma1_cea;
rp1=r+1;
rm1=r-1;

%M=0.3;

k=(rp1/(2*rm1));
c=((rp1/2)^k);
d=M*(1+(rm1/2)*M^2)^(-k);
J=c*d;

end
