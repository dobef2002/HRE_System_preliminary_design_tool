function [ballistic,eff_]=ballistics(Isp_data_real,grain,Rf,Mass,time_burn,cstar_data,of_cea,of_data,nozzle)
  
  a=userinputdata.propellant.a;   % in kg,m
  n=userinputdata.propellant.n;   % in kg,m
  density=userinputdata..propellant.density;   % in kg/m^3
  
  kplus=2*n+1;
  kminus=2*n-1;

  mox=Mass.propellant.oxidizer/time_burn;

  % mfi=a*density*grain.length*(2^(2*n))*(mox^n)*(pi^(1-n))*(grain.Dport.initial^(1-2*n));  % initial fuel mass flow rate
  % OFi=(((mox^(1-n))*(grain.Dport.initial^(2*n-1)))/(density*a*grain.length*(pi^(1-n))*(2^(2*n))));  % initial O/F ratio

 Goxi=mox/grain.Aport.intial;
 dtime=0.001; delta time
 
 % P.initial=(mox+mfi)*cstar_data/nozzle.At;
 % Thrust.initial=P*nozzle.At*cf_vac_loss;

OF=of_data; 
OFlength=length(OF);
sumE=linspace(0,0,OFlength);
eff_cstar=linspace(0,0,OFlength);
cstar=cstar_data;

for m=1:OFlength
     cdelta(m)=cstar(m)*(1+(1/OF(m)));
end

for j=1:1  % OFlength

     OFave=of_cea;
    
     % di=((kplus*a*(2^(n+1))*density*L*OFave*(mox^(n-1))*(Rf(LL)^2-1))/(4*(pi^(n-1))*(Rf(LL)^kplus-1)))^(1/kminus);
     di=grain.Dport.initial;  
     df=di*Rf;              %  final  grain port
     
     tb=time_burn;

      Ofi=(((mox^(1-n))*(grain.Dport.initial^(2*n-1)))/(density*a*grain.length*(pi^(1-n))*(2^(2*n))));
         
        if OFi < 2
          OFi=2;
        else
        end
        
i=;
It_sum=0;
for t=0:dtime:tb
     OFend(i)=OFi*((1+((Rf)^(2*n+1)-1)*(t/tb))^((2*n-1)/(2*n+1)));
     mf_cal(i)=mox/OFend(i);

     for OOO=1:OFlength
               if OF(OOO)<OFend(i)
               else
                 locationOFend=OOO;
                  break
               end
               locationOFend=OOO;
      end
      
      pc_cal(i)=(mox+mf_cal(i))*cstar(OOO)/nozzle.At;
      cf_vac_loss_cal(i)=Isp_data_real(OOO)*9.80665/cstar(OOO);
      Thrust_cal(i)=pc_cal(i)*nozzle.At*cf_vac_loss_cal(i);
      delt_It_cal(i)=Thrust_cal(i)*dtime;
      It_sum=It_sum+delt_It_cal(i);
      Time(i)=t;
      i=i+1;
end

ballistic.time=Time;
ballistic.pc=pc_cal;
ballistic.cf_vac=cf_vac_loss_cal;
ballistic.thrust=Thrust_cal;
ballistic.OF=OFend;
ballistic.Itt=It_sum;


 OFend=round(OFend,2);
 datalength=length(OFend);

  sumcstar=0;

     for PPP=1:datalength
                  for OOO=1:OFlength
                     
                       if OF(OOO)<OFend(PPP)
                         
                       else
                           locationOFend=OOO;
                         break
                       end
                       locationOFend=OOO;

                  end
             check(PPP)=cdelta(locationOFend);
             cstarint=cdelta(locationOFend)*dtime;

             sumcstar=sumcstar+cstarint;
     end
     
     
     
                  for aave=1:OFlength
                       if OF(aave)< OFave
                       else
                           locationOFave=aave;
                           break
                       end
                       locationOFave=aave;
                  end
    sumcstarave=cdelta(locationOFave)*tb;

eff_(j)=sumcstar/sumcstarave;

end


end





