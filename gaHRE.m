% Optimal Design for Hybrid Rocket System

% Function: Find maximum delta Velocity for Hybrid Rocket Engine as an upper stage
%2021.11.11,Cosine

mission_time=[100,200,300];

geometric=[1,2,3,4];

timeoption=length(mission_time);
geometricooption=length(geometric);
totaloption=timeoption*geometricoption;
solution=zeros(totaloption,7);  % all result matrix
score=zeros(totaloption,1);
count=0;
ConstraintFunction=@simple_constraint;

for i=1:timeoption
    for j=1:geometricoption

options=optimoptions('ga','PopulationSize', 120,'MaxGenerations', 500, 'CrossoverFraction',0.8,'Display', 'iter');

% options=optimoptions('ga','PopulationSize', 120,'MaxGenerations', 500,'PlotFcn',{@gaplotbestf,@my_plot}, 'CrossoverFraction',0.8,'Display', 'iter');
%                    %最佳算法 %染色體數量       %最大繁衍代數              %繪圖函數                     %交配率                   %結果展示方式
[x, fval]=ga(@FitnessFcn,7, [],[],[],[],[5,mission_time(i),2,2,20,geometric(j),6], [100,mission_time(i),4,200,100,geometric(j),10],[],[1 2 3 4 5 6 7],option);
%[x, fval]=ga(@FitnessFcn,7, [],[],[],[],[5,100,2,2,20,1,6], [100,300,4,200,100,4,10],[],[1 2 3 4 5 6 7],option);
%          ga(自定義函數,變數變量,限制式-不等式係數,限制式-不等式係數,限制式-等式係數,限制式-等式係數,變數下界,變數上界,非線性約束式,整數欄位,GA參數)

count=count+1;
localtion_score=count;
score(localtion_score)=fval
solution(localtion_score,:)=x
 
   end
end
save('solution');

%自定義適應函數
function Z=FitnessFcn(x)

load('HRE_AR_database_20211130.mat')  %  load propellant thermal properties from NASA CEA calculation result

        P_chamber= x(1);
        time_burn= x(2);
        Rf= x(3);            %fuel grain diameter ratio
        AR= x(4);            %expansion ratio
        OFX10= x(5);         %10 times OF ratio
        OF=OFX10/10;         %OF ratio
        geometricflag=x(6);  % HRE components arrangement--> 1 for straight line, 2 for 2 ox tank, 3 for toroidal ox tank, 4 for 4 ox tank
 
        OxTankmaterial=2  %x(8);% 1 for Ti6Al4V, 2 for AL-5254
        P.gas_multiple=x(7);
       
   %material strength and  density
   material.Ti6AL4V.yieldStrength=8436; 
   material.Ti6AL4V.density=4460;
   material.AL5254.yieldStrength=2742; 
   material.AL5254.yieldStrength=2700; 
   material.AL7075T6.yieldStrength=5100; 
   material.AL7075T6.yieldStrength=2850;
   material.SAE4130.yieldStrength=9500; 
   material.SAE4130.yieldStrength=7800;
   material.silicaphenolic.density=1700;
%%%%
  switch OxTankmaterial
      case 1
             Tank.oxidizer.strength=material.Ti6Al4V.yieldStrength;
             Tank.oxidizer.density=material.Ti6Al4V.density;
      case 2
             Tank.oxidizer.strength=material.Al5254.yieldStrength;
             Tank.oxidizer.density=material.Al5254.density;
  end

   Tank.gas.strength=material.Ti6AL4V.yieldStrength;
   Tank.gas.density=materiaal.Ti6AL4V.density;
   chamber.strength=material.SAE4130.yieldStrength;
   chamber.density=material.SAE4130.density;
   nozzle.div.strength=material.AL7075T6.yieldStrength;
   nozzle.div.density=material.AL7075T6.density;
   nozzle.div_insulation.density=material.silicaphenolic.density;
   nozzle.con.strength=material.SAE4130.yieldStrength;
   nozzle.con.density=material.SAE4130.density;
   nozzle.con_insulation.density=material.silicaphenolic.density;
%%%

F_avg=[300]; %kgf

eff_cf=0.98;
eff_combustion=0.95;
gravity=9,80665;

F_avg_option=length(F_avg);

% Pc location at this iteration
    P_chamber_option=[5:1:100];
    P_chamber_option_length=length(P_chamber_option);
                  for OOO=1:P_chamber_option_length
                       if P_chamber_option(OOO)<P_chamber
                              % keep searching
                        else
                             k=OOO;
                          break
                        end
                   end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Expansion ratio (AR) location at this iteration
   AR_option=[2:1:200];
   AR_option_length=length(AR_option);
                    for XXX=1:AR_option_length
                         if AR_option(XXX)<AR
                               % keep searching
                         else
                             j=XXX;
                           break
                         end
                     end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% OF location at this iteration
   OF_option=[2:0.1:10];
   OF_option_length=length(OF_option);
                    for ZZZ=1:OF_option_length
                         if OF_option(ZZZ)<OF
                               % keep searching
                         else
                             v=XXX;
                           break
                         end
                     end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

               cea_data=finalAR_database(v,:,j,k) % linspace 
                       %final(OF,thermo property,AR,k)
               cstar_data=finalAR_database(:,2,j,k);
               of_data=finalAR_database(:,1,j,k);
               Isp_data=finalAR_database(:,7,j,k);Isp_data=Isp_data/gravity;
               Isp_data_real=Isp_data.*eff_cf;
                  % from linspace to  a unit
               of_cea=cea_data(:,1);
               cstar_cea=cea_data(:,2);
               isp_cea=cea_data(:,3);isp_cea=isp_cea/gravity;
               temperature_cea=cea_data(:,4);cf_cea=cea_data(:,5);aeat_cea=cea_data(:,6);
               isp_vac_cea=cea_data(:,7);isp_vac_cea=isp_vac_cea/gravity;
               gamma1_cea=cea_data(:,8);mw1_cea=cea_data(:,9);
               P_throat_cea=cea_data(:,10);Pc_Pe_cea=cea_data(:,11);
               
               %%%損失計算
               total_impulse=time_burn.*F_avg;
               cf_loss=cf_cea.*eff_cf;
               cf_vac_loss=isp_vac_cea.*eff_cf.*gravity./cstar_cea;
               isp_vac_real=isp_vac_cea.*eff_cf.*eff_combustion;
               cstar_real=cstar_cea*eff_combustin;
               Ga=((gamma1_cea).^0.5).*((2./(gamma1_cea+1)).^((gamma1_cea+1)./(2*(gamma1_cea-1)))); 
               P_throat=P_throat_cea.*1.02; % bar to kgf/cm2
               Pe_pc=1./Pc_Pe_cea;
               %%%%
               P.chamber=P_chamber;
               P.throat=P_throat;
               P.exit=Pe_Pc*P_chamber;
               P.ambient=0,00001;
                %%%%%
              %%%%%%%%%%%%%%%% Performance and Weight calculation%%%%%%%%%%%%%%
               
               Mass=propellant_cal(F_avg,total_impulse,of_cea,isp_vac_real);
               [nozzle,Mass]=nozzle_div_cal(F_avg,cf_vac_loss,P,aeat_cea,Mass,nozzle);
               J=J_cal(0.3,gamma1_cea);%M=0.3
               [grain,Rf]=fuel_grain_cal(nozzle,time_burn,Mass,Rf,J);
               [eff_,L,ballistic]=Rf_eff_cal(Mass,time_burn,grain,Rf,cstar_data,of_cea,of_data,nozzle,Isp_data_real,eff_combustion);
               chamber=chamber_cal(grain,P,chamber);
               [nozzle,Mass]=nozzle_con_cal(P,nozzle,Mass,chamber);
               [chamber,Mass]=aft_chamber_cal(Mass,grain,nozzle,chamber);
               Vloading=(Mass.propellant.fuel/959.6)/(chamber.volumn);

               Mass=Acs_cal(Mass);
               [Mass,P,Tank]=Tank_cal(Mass,P,geometricflag,chamber,Tank);
                
               [motor_case,Mass,length_case]=engine_length_cal(nozzle,Mass,Tank,chamber,grain,geometricflag);
               Volumn=engine_volumn_cal(nozzle,chamber,Tank,geometricflag);
               Mass=engine_mass_cal(Mass);
               [performance,Mass]=performance_cal(Mass,isp_vac_real,total_impulse,Rf,eff_,ballistic);
               [motor_dV,HREproperty]=overall_dV_cal(Mass,performance);
               Z=(performance.takeoff1_delta_velocity_withoutpayload/Mass.primaryStructure);
                Z=-Z;


function [c,ceq]=simple_constraint(x)
   
               %%%  nonlinear constraint 
                 
                      Z=performance.takeoff1_massratio;
                     Z=-Z;
                      ceq=[];
                        c=Z+0.5;   % mass ratio constraint
  end
 





               







    

        
