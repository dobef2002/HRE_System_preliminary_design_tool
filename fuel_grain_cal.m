%%%  fuel grain geometric calculate

function [grain,Rf]=fuel_grain_cal(nozzle, time_burn,Mass,Rf,J,of_cea)

          %grain
          %At_Aport=0.5;=J
          
         % propellant properties of  95%H2O2/HTPB/C
  
           a=0.0000527;  %in m,kg
           n=0.7189;
           density_f=959.6;
           
          grain.Dport.initial=((time_burn*a*(2^(2*n+1))*(2*n+1)*((Mass.propellant.oxidizer/time_burn)^n))/((pi^n)*((Rf^(2*n+1))-1)))^(1/(2*n+1));
          grain.Aport.initial=pi*(grain.Dport.initial^2)/4;

             if nozzle.At/grain.Aport.initial > J   % J over limitation
                    grain.Aport.initial=nozzle.At/J;
                    grain.Dport.initial=(grain.Aport.initial*4/pi)^0.5;
                    grain.Gox.initial=(Mass.propellant.oxidizer/time_burn)/grain.Aport.initial;
            
                    grain.Dport.final=((time_burn*(2*n+1)*a*(2^(2*n+1))*((Mass.propellant.oxidizer/time_burn)^n)/(pi^n))+(grain.Dport.initial^(2*n+1)))^(1/(2*n+1));
                    Rf=grain.Dport.final/grain.Dport.initial;
                    grain.length=4*Mass.propellant.fuel/(density_f*pi*(grain.Dport.final^2-grain.Dport.initial^2));
  
                    grain.Dport.final=grain.Dport.initial*Rf;

                    grain.length=4*Mass.propellant.fuel/(density_f*pi*(grain.Dport.final^2-grain.Dport.initial^2));


end