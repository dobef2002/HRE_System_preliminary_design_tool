%%% nozzle diverging part calculate

function [nozzle,Mass]=nozzle_div_cal(F_avg,cf_vac_loss,P,aeat_cea,Mass,nozzle)

         
               nozzle.At=0.0001*(F_avg/cf_vac_loss/P.chamber);
               nozzle.Dt=(4.*nozzle.At/pi)^0.5;
               nozzle.Ae=nozzle.At.aeat_cea;
               nozzle.De=(4*nozle.Ae/pi)^0.5;
         
         %   nozzle diverging part length calculate  for cone shape nozzle    
               nozzle.length.div=(nozzle.De/2)*cot(15*pi/180)-(nozzle.Dt/2)*cot(15*pi/180);
         
         %   nozzle diverging part length calculate  for bell shape nozzle 
         %   set bell shape nozzle length as XX% of cone shape nozzle
         %   Reference from  rocket propulsion element
   
                               if    aeat_cea <= 10
                                      nozzle.length.div=nozzle.length.div*0.8;
                                 elseif  aeat_cea <= 20 && aeat_cea > 10
                                      nozzle.length.div=nozzle.length.div*0.75;
                                 elseif  aeat_cea <= 30 && aeat_cea > 20
                                      nozzle.length.div=nozzle.length.div*0.72;
                                 elseif  aeat_cea <= 40 && aeat_cea > 30
                                      nozzle.length.div=nozzle.length.div*0.7;
                                 elseif  aeat_cea <= 50 && aeat_cea > 40
                                      nozzle.length.div=nozzle.length.div*0.67;
                                 else
                                      nozzle.length.div=nozzle.length.div*0.6;

        %  strength
               nozzle.th_div=P.throat*nozzle.De/2/cos(15*pi/180)/(nozzle.div.strength*0.95-0.6*P.throat);
               nozzle.th_div_real=P.throat*nozzle.De/2/cos(15*pi/180)/(nozzle.div.strength*0.95-0.6*P.throat);
               nozzle.th_div(nozzle.th_div<0.002)=0.002;

        %  mass
              nozzle_volumn_div.metal_inner=(cot(15*pi/180)*(nozzle.De/2)*nozzle.Ae-cot(15*pi/180)*nozzle.At*(nozzle.Dt/2))/3;
              nozzle_volumn_div.metal_outer=(cot(15*pi/180)*(nozzle.De+2*nozzle.th_div/2)*((pi*(nozzle.De+2*nozzle.th_div)^2)/4)-cot(15*pi/180)*((pi*(nozzle.Dt+2*nozzle.th_div)^2)/4)*((nozzle.Dt+2*nozzle.th_div)/2))/3;
              nozzle.volumn_div.metal=nozzle.volumn_div.metal_outer-nozzle.volumn_div.metal_inner;
              nozzle.volumn_div.insulation_inner=(cot(15*pi/180)*((nozzle.De-2*0.002)/2)*((pi*(nozzle.De-2*0.002)^2)/4)-cot(15*pi/180)*((pi*(nozzle.Dt-2*0.002)^2)/4)*((nozzle.Dt-2*0.002)/2))/3;
              nozzle.volumn_div.insulation=nozzle.volumn_div.metal_inner-nozzle.volumn_div.insulation_inner;
              nozzle.mass_div.metal=nozzle.volunm_div.metal*nozzle.div.density;
              nozzle.mass_div.insulation=nozzle.volumn_div.insulation*nozzle.div_insulation.density;
              Mass.nozzle.div=nozzle.mass_div.metal+nozzle.mass_div.insulation;

end



                                         