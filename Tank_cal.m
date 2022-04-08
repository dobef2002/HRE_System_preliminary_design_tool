%%%%  Tank mass calculate

function [Mass,P,Tank]=Tank_cal(Mass,P,geometricflag,chamber,Tank,casing)

casing.D_outer=inputdata.D_outer;
casing.th=inputdata.casing_th;
casing.D_inner=(casing.D_outer-2*casing.th);
Tank.saftyfactor=2;
Tank.basic_thick=0.002;
Tank.gas.number=2;   % 2 gas tank 

%%%%%%%%%%
%  gas property
%%%%%%%%%%%%

          gas.He.specific_heat=1.66;
          gas.He.molecular_weight=4;
          gas_constant=8.31446;   % (J/K-mol)
          gas.He.gas_constant=gas_constant/gas.He.molecular_weight/0.001;
          gas.temperature=300;


  switch geometricflag

         case 1

               % oxidizer tank sphere
    
                  Tank.oxidizer.sphere.volumn=((Mass.propellant.oxidizer+Mass.propellant_residual+Mass.propellant.ACS)/1414)*1.03;
                  Tank.oxidizer.sphere.pressure=P.chamber*2.5;   % assume tank P ia 2.5times chamber P
                  Tank.oxidizer.sphere.R=(Tank.oxidizer.sphere.volumn*3/4/pi)^(1/3);
                  
               if Tank.oxidizer.sphere.R <=  casing.D_inner

                 Tank.oxidizer.sphere.th=Tank.saftyfactor*Tank.oxidizer.sphere.pressure*Tank.oxidizer.sphere.R/2/Tank.oxidizer.strength;
                 Tank.oxidizer.sphere.th_real=Tank.saftyfactor*Tank.oxidizer.sphere.pressure*Tank.oxidizer.sphere.R/2/Tank.oxidizer.strength;

                 Tank.oxidizer.sphere.th(Tank.oxidizer.sphere.th<Tank.basic_thick)=Tank.basic_thick;
                 Tank.oxidizer.sphere.mass=(((Tank.oxidizer.sphere.R+Tank.oxidizer.sphere.th)^3-Tank.oxidizer.sphere.R^3)*4*pi/3)*Tank.oxidizer.density;
                 Tank.oxidizer.sphere.length=2*Tank.oxidizer.sphere.R;

                else

                Tank.oxidizer.sphere.Rm=casing.D_inner;
                Tank.oxidizer.sphere.L=(Tank.oxidizer.sphere.volumn-((4*pi*Tank.oxidizer.sphere.Rm^3)/3))/(pi*(Tank.oxidizer.sphere.Rm^2));
                Tank.oxidizer.sphere.th=Tank.saftyfactor*Tank0oxidizer.sphere.pressure*Tank.oxidizer.sphere.Rm/Tank.oxidizer.strength;

                Tank.oxidizer.sphere.volumn_outer=pi*Tank.oxidizer.sphere.L*(Tank.oxidizer.sphere.Rm+Tank.oxidizer.sphere.th)^2+(4*pi*(Tank.oxidizer.sphere.Rm+Tank.oxidizer.sphere.th)^3)/3;
                Tank.oxidizer.sphere.mass=(Tank.oxidizer.sphere.volumn_outer-Tank.oxidizer.sphere.volumn)*Tank.oxidizer.density;
                Tank.oxidizer.sphere.length=Tank.oxidizer.sphere.L+2*Tank.oxidizer.sphere.Rm;
                
                end

                Mass.Tank.oxidizer=Tank.oxidizer.sphere.mass;


                %%%%%%
                % gas tank
                %%%%%%

                Tank.oxidizer.pressure=Tank.oxidizer.sphere.pressure;
                Tank.oxidizer.volumn=Tank.oxidizer.sphere.volumn;
                Tank.gas.pressure=Tank.oxidizer.pressure*P.gas_multile;
                Mass.He=9.80665*10000*Tank.oxidizer.pressure*Tank.oxidizer.volumn*gas.He.specific_heat/gas.He.gas_constant/gas.temperature/(1-Tank.oxidizer.pressure/Tank.gas.pressure);
                Tank.gas.volumn=1.02*0.00001*Mass.He*gas.He.gas_constant*gas.temperature/Tank.gas.pressure;
                Tank.gas.R=((Tank.gas.volumn*1.02/Tank.gas.number)*3/4/pi)^(1/3);  % 1.02 margin for gas volumn
                Tank.gas.th=Tank.saftyfactor.*Tank.gas.pressure*Tank.gas.R/2/Tank.gas.strength;
                Tank.gas.th_real=Tank.saftyfactor*Tank.gas.pressure*Tank.gas.R/2/Tank.gas.strength;
                Tank.gas.th(Tank.gas.th < Tank.basic_thick)=Tank.basic_thick;

                Tank.gas.mass=((((Tank.gas.R+Tank.gas.th)^3-Tank.gas.R^3)*4*pi/3)*Tank.gas.density)*Tank.gas.number; % total mass of 2 gas tank
                Mass.Tank.gas=Tank.gas.mass;

                P.oxidizer=Tank.oxidizer.sphere.pressure;
                P.gas=Tank.gas.pressure;

    
          case 2    % 2 tanks with cylinder shape 

               Tank.ellipse.D.maximum=(casing.D_inner-chamber.D)/2;
               Tank.ellipse.number=2;

               Tank.oxidizer.ellipse.volumn=((Mass.propellant.oxidizer+Mass+propellant.oxidizer_residual+Mass.propellant.ACS)/1414)*1.03;
               Tank.oxidizer.ellipse.pressure=P.chamber*2.5;
               Tank.oxidizer.ellipse.volumn_half=Tank.oxidizer.ellipse.volumn/Tank.ellipse.number;
               Tank.oxidizer.ellipse.R=((Tank.oxidizer.ellipse.volumn_half)*3/4/pi)^(1/3);
               
               if Tank.oxidizer.ellipse.R <= Tank.ellipse.D.maximum/2


                   % sphere shape
                 Tank.oxidizer.ellipse.th=Tank.saftyfactor*Tank.oxidizer.ellipse.pressure*Tank.oxidizer.ellipse.R/2/Tank.oxidizer.strength;
                 Tank.oxidizer.ellipse.th_real=Tank.saftyfactor*Tank.oxidizer.ellipse.pressure*Tank.oxidizer.ellipse.R/2/Tank.oxidizer.strength;

                 Tank.oxidizer.ellipse.th(Tank.oxidizer.ellipse.th<Tank.basic_thick)=Tank.basic_thick;
                 Tank.oxidizer.ellipse.thh=Tank.oxidizer.ellipse.pressure*Tank.oxidizer.ellipse.R/2/(Tank.oxidizer.strength*0.95-0.6*Tank.oxidizer.ellipse.pressure);
                 

                 Tank.oxidizer.ellipse.mass=Tank.ellipse.number*(((Tank.oxidizer.ellipse.R+Tank.oxidizer.ellipse.th)^3-Tank.oxidizer.ellipse.R^3)*4*pi/3)*Tank.oxidizer.density;
                 Tank.oxidizer.ellipse.length=2*Tank.oxidizer.ellipse.R;

               else

                  % cylinder shape 
              
                  Tank.oxidizer.ellipse.Rm=Tank.ellipse.D.maximum/2;

                  Tank.oxidizer.ellipse.R=Tank.oxidizer.ellipse.Rm;
                  Tank.oxidizer.ellipse.L=((Tank.oxidizer.ellipse.volumn_half-((4*pi*Tank.oxidizer.ellipse.Rm^3)/3))/(pi*Tank.oxidizer.ellipse.Rm^2))+2*Tank.oxidizer.ellipse.Rm;
                  Tank.oxidizer.ellipse.th=Tank.saftyfactor*Tank.oxidizer.ellipse.pressure*Tank.oxidizer.ellipse.Rm/Tank.oxidizer.strength;
                  Tank.oxidizer.ellipse.th_real=Tank.saftyfactor*Tank.oxidizer.ellipse.pressure*Tank.oxidizer.ellipse.Rm/Tank.oxidizer.strength;
                  Tank.oxidizer.ellipse.th(Tank.oxidizer.ellipse.th < Tank.basic_thick)=Tank.basic_thick;
                  
                  Tank.oxidizer.ellipse.volumn_half_outer=pi*(Tank.oxidizer.ellipse.L-2*Tank.oxidizer.ellipse.Rm)*(Tank.oxidizer.ellipse.Rm+Tank.oxidizer.ellipse.th)^2+(4*pi*(Tank.oxidizer.ellipse.Rm+Tank.oxidizer.ellipse.th)^3)/3;
                  Tank.oxidizer.ellipse.mass=Tank.ellipse.number*(Tank.oxidizer.ellipse.volumn_half_outer-Tank.oxidizer.ellipse.volumn_half)*Tank.oxidizer.density;
                  Tank.oxidizer.ellipse.length=Tank.oxidizer.ellipse.L;
               end

               Mass.Tank.oxidizer=Tank.oxidizer.ellipse.mass;


                %%%%%%
                % gas tank
                %%%%%%

                Tank.oxidizer.pressure=Tank.oxidizer.ellipse.pressure;
                Tank.oxidizer.volumn=Tank.oxidizer.sphere.volumn;
                Tank.gas.pressure=Tank.oxidizer.pressure*P.gas_multile;
                Mass.He=9.80665*10000*Tank.oxidizer.pressure*Tank.oxidizer.volumn*gas.He.specific_heat/gas.He.gas_constant/gas.temperature/(1-Tank.oxidizer.pressure/Tank.gas.pressure);
                Tank.gas.volumn=1.02*0.00001*Mass.He*gas.He.gas_constant*gas.temperature/Tank.gas.pressure;
                Tank.gas.R=((Tank.gas.volumn*1.02/Tank.gas.number)*3/4/pi)^(1/3);  % 1.02 margin for gas volumn
                Tank.gas.th=Tank.saftyfactor.*Tank.gas.pressure*Tank.gas.R/2/Tank.gas.strength;
                Tank.gas.th_real=Tank.saftyfactor*Tank.gas.pressure*Tank.gas.R/2/Tank.gas.strength;
                Tank.gas.th(Tank.gas.th < Tank.basic_thick)=Tank.basic_thick;

                Tank.gas.mass=((((Tank.gas.R+Tank.gas.th)^3-Tank.gas.R^3)*4*pi/3)*Tank.gas.density)*Tank.gas.number; % total mass of 2 gas tank
                Mass.Tank.gas=Tank.gas.mass;

                P.oxidizer=Tank.oxidizer.sphere.pressure;
                P.gas=Tank.gas.pressure;


          case 3

               % oxidizer tank toroid
    
                  Tank.oxidizer.toroid.volumn=((Mass.propellant.oxidizer+Mass.propellant_residual+Mass.propellant.ACS)/1414)*1.03;
                  Tank.oxidizer.toroid.pressure=P.chamber*2.5;   % assume tank P ia 2.5times chamber P
                  Tank.oxidizer.toroid.e.max=(casing.D_inner-2*0.02)/2;  %assume there is a 0.02m length margin for tank thick and gap for each side                 
                  Tank.oxidizer.toroid.d.min=(chamber.D+2*0.02)/2;
                  Tank.oxidizer.toroid.e.test=[Tank.oxidizer.toroid.d.min+0.01:0.02:Tank.oxidizer.toroid.e.max]; %linspace
                  
                  OOO=length(Tank.oxidizer.toroid.e.test);
                   for i=1:OOO
                  Tank.oxidizer.toroid.flag=Tank.oxidizer.toroid.min/Tank.oxidizer.toroid.e.test(OOO);
                      if Tank.oxidizer.toroid.flag >= 0.25
               
                          Tank.oxidizer.toroid.th=Tank.saftyfactor*Tank.oxidizer.toroid.pressure*(Tank.oxidizer.toroid.e.test(i))/Tank.oxidizer.strength;
                          Tank.oxidizer.toroid.th_real=Tank.saftyfactor*Tank.oxidizer.toroid.pressure*(Tank.oxidizer.toroid.e.test(i))/Tank.oxidizer.strength;
                          Tank.oxidizer.toroid.th(Tank.oxidizer.toroid.th < Tank.basic_thick)=Tank.basic_thick;
                      else
                          Tank.oxidizer.toroid.th=((1-Tank.oxidizer.toroid.flag)*(1+3*Tank.oxidizer.toroid.flag)/(8*Tank.oxidizer.toroid.flag))*Tank.saftyfactor*Tank.oxidizer.toroid.pressure*(Tank.oxidizer.toroid.e.test(i))/Tank.oxidizer.strength;
                      end

                          Tank.oxidizer.toroid.a=Tank.oxidizer.toroid.e.test(i)-Tank.oxidizer.toroid.d.min;
                          Tank.oxidizer.toroid.R=(Tank.oxidizer.toroid.e.test(i)+Tank.oxidizer.toroid.d.min;
                          Tank.oxidizer.toroid.h=((Tank.oxidizer.toroid.volumn/Tank.oxidizer.toroid.R/2/pi)-((pi*(Tank.oxidizer.toroid.a^2))/4))/Tank.oxidizer.toroid.a;
                      if Tank.oxidizer.toroid.h < 0
                          Tank.oxidizer.toroid.mass.test(i)=10000000;
                      else
                         Tank.oxidizer.toroid.b=Tank.oxidizer.toroid.h+Tank.oxidizer.toroid.a;
                         Tank.oxidizer.toroid.volumn_out=2*pi*Tank.oxidizer.toroid.R*(((Tank.oxidizer.toroid.a+2*Tank.oxidizer.toroid.th)*Tank.oxidizer.toroid.h)+((pi*(Tank.oxidizer.toroid.a+2*Tank.oxidizer.toroid.th)^2)/4));
                         Tank.oxidizer.toroid.mass.test(i)=(Tank.oxidizer.toroid.volumn_out-Tank.oxidizer.toroid.volumn)*Tank.oxidizer.density;
                      end
                   end

                   [value,ind]=min(Tank.oxidizer.toroid.mass.test);
                   Tank.oxidizer.toroid.e.final=Tank.oxidizer.toroid.e.test(ind);

                   Tank.oxidizer.toroid.flag=Tank.oxidizer.toroid.d.min/Tank.oxidizer.toroid.e.final;

                      if Tank.oxidizer.toroid.flag >= 0.25
                          Tank.oxidizer.toroid.th=Tank.saftyfactor*Tank.oxidizer.toroid.pressure*(Tank.oxidizer.toroid.e.test(i))/Tank.oxidizer.strength;
                          Tank.oxidizer.toroid.th_real=Tank.saftyfactor*Tank.oxidizer.toroid.pressure*(Tank.oxidizer.toroid.e.test(i))/Tank.oxidizer.strength;
                          Tank.oxidizer.toroid.th(Tank.oxidizer.toroid.th < Tank.basic_thick)=Tank.basic_thick;
                      else
                          Tank.oxidizer.toroid.th=((1-Tank.oxidizer.toroid.flag)*(1+3*Tank.oxidizer.toroid.flag)/(8*Tank.oxidizer.toroid.flag))*Tank.saftyfactor*Tank.oxidizer.toroid.pressure*(Tank.oxidizer.toroid.e.test(i))/Tank.oxidizer.strength;
                      end
                          Tank.oxidizer.toroid.a=Tank.oxidizer.toroid.e.test(i)-Tank.oxidizer.toroid.d.min;
                          Tank.oxidizer.toroid.R=(Tank.oxidizer.toroid.e.test(i)+Tank.oxidizer.toroid.d.min;
                          Tank.oxidizer.toroid.h=((Tank.oxidizer.toroid.volumn/Tank.oxidizer.toroid.R/2/pi)-((pi*(Tank.oxidizer.toroid.a^2))/4))/Tank.oxidizer.toroid.a;
                          Tank.oxidizer.toroid.b=Tank.oxidizer.toroid.h+Tank.oxidizer.toroid.a;
                          Tank.oxidizer.toroid.volumn_out=2*pi*Tank.oxidizer.toroid.R*(((Tank.oxidizer.toroid.a+2*Tank.oxidizer.toroid.th)*Tank.oxidizer.toroid.h)+((pi*(Tank.oxidizer.toroid.a+2*Tank.oxidizer.toroid.th)^2)/4));
                          Tank.oxidizer.toroid.mass.final=(Tank.oxidizer.toroid.volumn_out-Tank.oxidizer.toroid.volumn)*Tank.oxidizer.density;
                          Tank.oxidizer.toroid.length=Tank.oxidizer.toroid.b;
                          Mass.Tank.oxidizer=Tank.oxidizer.toroid.mass.final;




                %%%%%%
                % gas tank
                %%%%%%

                Tank.oxidizer.pressure=Tank.oxidizer.ellipse.pressure;
                Tank.oxidizer.volumn=Tank.oxidizer.sphere.volumn;
                Tank.gas.pressure=Tank.oxidizer.pressure*P.gas_multile;
                Mass.He=9.80665*10000*Tank.oxidizer.pressure*Tank.oxidizer.volumn*gas.He.specific_heat/gas.He.gas_constant/gas.temperature/(1-Tank.oxidizer.pressure/Tank.gas.pressure);
                Tank.gas.volumn=1.02*0.00001*Mass.He*gas.He.gas_constant*gas.temperature/Tank.gas.pressure;
                Tank.gas.R=((Tank.gas.volumn*1.02/Tank.gas.number)*3/4/pi)^(1/3);  % 1.02 margin for gas volumn
                Tank.gas.th=Tank.saftyfactor.*Tank.gas.pressure*Tank.gas.R/2/Tank.gas.strength;
                Tank.gas.th_real=Tank.saftyfactor*Tank.gas.pressure*Tank.gas.R/2/Tank.gas.strength;
                Tank.gas.th(Tank.gas.th < Tank.basic_thick)=Tank.basic_thick;

                Tank.gas.mass=((((Tank.gas.R+Tank.gas.th)^3-Tank.gas.R^3)*4*pi/3)*Tank.gas.density)*Tank.gas.number; % total mass of 2 gas tank
                Mass.Tank.gas=Tank.gas.mass;

                P.oxidizer=Tank.oxidizer.sphere.pressure;
                P.gas=Tank.gas.pressure;


          case 4   % 4 tanks with  cylinder shape 

               Tank.ellipse.D.maximum=(casing.D_inner-chamber.D)/2;
               Tank.ellipse.number=4;

               Tank.oxidizer.ellipse.volumn=((Mass.propellant.oxidizer+Mass+propellant.oxidizer_residual+Mass.propellant.ACS)/1414)*1.03;
               Tank.oxidizer.ellipse.pressure=P.chamber*2.5;
               Tank.oxidizer.ellipse.volumn_half=Tank.oxidizer.ellipse.volumn/Tank.ellipse.number;
               Tank.oxidizer.ellipse.R=((Tank.oxidizer.ellipse.volumn_half)*3/4/pi)^(1/3);
               
               if Tank.oxidizer.ellipse.R <= Tank.ellipse.D.maximum/2


                   % sphere shape
                 Tank.oxidizer.ellipse.th=Tank.saftyfactor*Tank.oxidizer.ellipse.pressure*Tank.oxidizer.ellipse.R/2/Tank.oxidizer.strength;
                 Tank.oxidizer.ellipse.th_real=Tank.saftyfactor*Tank.oxidizer.ellipse.pressure*Tank.oxidizer.ellipse.R/2/Tank.oxidizer.strength;

                 Tank.oxidizer.ellipse.th(Tank.oxidizer.ellipse.th<Tank.basic_thick)=Tank.basic_thick;
                 Tank.oxidizer.ellipse.thh=Tank.oxidizer.ellipse.pressure*Tank.oxidizer.ellipse.R/2/(Tank.oxidizer.strength*0.95-0.6*Tank.oxidizer.ellipse.pressure);
                 

                 Tank.oxidizer.ellipse.mass=Tank.ellipse.number*(((Tank.oxidizer.ellipse.R+Tank.oxidizer.ellipse.th)^3-Tank.oxidizer.ellipse.R^3)*4*pi/3)*Tank.oxidizer.density;
                 Tank.oxidizer.ellipse.length=2*Tank.oxidizer.ellipse.R;

               else

                  % cylinder shape 
              
                  Tank.oxidizer.ellipse.Rm=Tank.ellipse.D.maximum/2;

                  Tank.oxidizer.ellipse.R=Tank.oxidizer.ellipse.Rm;
                  Tank.oxidizer.ellipse.L=((Tank.oxidizer.ellipse.volumn_half-((4*pi*Tank.oxidizer.ellipse.Rm^3)/3))/(pi*Tank.oxidizer.ellipse.Rm^2))+2*Tank.oxidizer.ellipse.Rm;
                  Tank.oxidizer.ellipse.th=Tank.saftyfactor*Tank.oxidizer.ellipse.pressure*Tank.oxidizer.ellipse.Rm/Tank.oxidizer.strength;
                  Tank.oxidizer.ellipse.th_real=Tank.saftyfactor*Tank.oxidizer.ellipse.pressure*Tank.oxidizer.ellipse.Rm/Tank.oxidizer.strength;
                  Tank.oxidizer.ellipse.th(Tank.oxidizer.ellipse.th < Tank.basic_thick)=Tank.basic_thick;
                  
                  Tank.oxidizer.ellipse.volumn_half_outer=pi*(Tank.oxidizer.ellipse.L-2*Tank.oxidizer.ellipse.Rm)*(Tank.oxidizer.ellipse.Rm+Tank.oxidizer.ellipse.th)^2+(4*pi*(Tank.oxidizer.ellipse.Rm+Tank.oxidizer.ellipse.th)^3)/3;
                  Tank.oxidizer.ellipse.mass=Tank.ellipse.number*(Tank.oxidizer.ellipse.volumn_half_outer-Tank.oxidizer.ellipse.volumn_half)*Tank.oxidizer.density;
                  Tank.oxidizer.ellipse.length=Tank.oxidizer.ellipse.L;
               end

               Mass.Tank.oxidizer=Tank.oxidizer.ellipse.mass;


                %%%%%%
                % gas tank
                %%%%%%

                Tank.oxidizer.pressure=Tank.oxidizer.ellipse.pressure;
                Tank.oxidizer.volumn=Tank.oxidizer.sphere.volumn;
                Tank.gas.pressure=Tank.oxidizer.pressure*P.gas_multile;
                Mass.He=9.80665*10000*Tank.oxidizer.pressure*Tank.oxidizer.volumn*gas.He.specific_heat/gas.He.gas_constant/gas.temperature/(1-Tank.oxidizer.pressure/Tank.gas.pressure);
                Tank.gas.volumn=1.02*0.00001*Mass.He*gas.He.gas_constant*gas.temperature/Tank.gas.pressure;
                Tank.gas.R=((Tank.gas.volumn*1.02/Tank.gas.number)*3/4/pi)^(1/3);  % 1.02 margin for gas volumn
                Tank.gas.th=Tank.saftyfactor.*Tank.gas.pressure*Tank.gas.R/2/Tank.gas.strength;
                Tank.gas.th_real=Tank.saftyfactor*Tank.gas.pressure*Tank.gas.R/2/Tank.gas.strength;
                Tank.gas.th(Tank.gas.th < Tank.basic_thick)=Tank.basic_thick;

                Tank.gas.mass=((((Tank.gas.R+Tank.gas.th)^3-Tank.gas.R^3)*4*pi/3)*Tank.gas.density)*Tank.gas.number; % total mass of 2 gas tank
                Mass.Tank.gas=Tank.gas.mass;

                P.oxidizer=Tank.oxidizer.sphere.pressure;
                P.gas=Tank.gas.pressure;


end

