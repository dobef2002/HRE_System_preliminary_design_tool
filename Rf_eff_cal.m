
function [eff_,L,ballistic]=Rf_eff_cal(Mass,time_burn,grain,Rf,cstar_data,of_cea,of_data,nozzle,Isp_data_real,eff_combustion)

a=0.0000527; % in kg,m
n=0.7189;
density=959.6;

kplus=2*n+1;
kminus=2*n-1;

mox=Mass.propellant.oxidizer/time_burn;

GOXi=mox/grain.Aport.initial; %kg/cm^2

dOF=0.1;
dtime=0.1;

Rfoption=length(Rf);
OF=of_data;
OFlength=length(OF)-1;
sumE=linspace(0,0,OFlength);
eff_cstar=linspace(00,OFlength);
final=ones(Rfoption,OFlength);
cstar=cstar_data;

for LL=1:Rfoption
   for m=1:OFlength
        cdelta(m)=cstar(m)*(1+(1/OF(m)));
   end

   for j=1:1 %OFlength
          OFave=of_cea;
           di=(4*mo(LL);x/(pi*GOXi))^0.5;
           df=di*Rf(LL);


           tb=time_burn;
           L(j)=grain.length;
           grainDport_i=grain.Dport.initial;
           OFi=(((mox^(1-n))*(di^(2*n-1)))/(density*a*L(j)*(pi^(1-n))*(2^(2*n))));
           if OFi <2
              OFi=2;
            else
            end

            OFf=OFi*(Rf(LL)^kminus);
            %OFave=((GOXi*tb/density*L))*(1/((Rf)^2-1));
            
        i=1;
         It_sum=0;
         for t=0:dtime:tb
              Time(i)=t;
              OFend(i)=OFi*((1+((Rf)^(2*n+1)-1)*(t/tb))^((2*n-1)/(2*n+1)));
              mf_cal(i)=mox/OFend(i);
              grainDport(i)=(grainDport_i^((2*n+1))+((2*n+1)*a*(2^(2*n+1))*(mox^(n))*Time(i)/(pi^n)))^(1/(2*n+1));
              regression(i)=mf_cal(i)/density/pi/L(j)/grainDport(i);
               
              for  OOO=1:OFlength

                              if OF(OOO)<OFend(i)
 
                              else
                                  locationOFend=OOO;
                                break
                              end
                              locationOFend=OOO;
              end


             pc_cal(i)=(mox+mf_cal(i))*cstar(OOO)*eff_combustion/nozzle.At/10000/9.80665;   %  m-->cm
             c_star(i)=cstar(OOO)*eff_combustion;
             Isp_(i)=Isp_data_real(OOO)*eff_combustion;
             cf_vac_loss_cal(i)=Isp_data_real(OOO)*9.80665/cstar(OOO);
             Thrust_cal(i)=pc_cal(i)*nozzle.At*cf_vac_loss_cal(i)*10000;  % m-->cm
             delta_It_cal(i)=Thrust_val(i)*dtime;
             It_sum=It_sum+delta_It_cal(i);
              i=i+1;
         end


ballistic.time=Time;
ballistic.pc=pc_cal;
ballistic.cf_vac=cf_vac_loss_cal;
ballistic.thrust=Thrust_cal;
ballistic.OF=OFend;
ballistic.cstar=c_star;
ballistic.Isp=Isp_;
ballistic.Dport=grainDport;
ballistic.regression=regression;
ballistic.It_deliver=It_sum;

    OFend=round(OFend,2);
    datalength=length(OFend);


    sumcstar=0;
    
     for PPP=1:datalength
              for  OOO=1:OFlength

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
                    if OF(aave)<OFave

                    else
                       locationOFave=aave;
                       break
                    end
                      locationOFave=ave;
              end

     sumcstarave=cdelta(locationOFave)*tb;
     eff_(j)=sumcstar/sumcstarave;
end


