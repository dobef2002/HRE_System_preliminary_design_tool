%%%  calculate chamber size

function  chamber=chamber_cal(grain,P,chamber)
  
          insulation_th=0.005;
          chamber.D=grain.Dport.final+2*insulation_th;
          chamber.length=grain.length;
          chamber.volumnn=(chamber.length)*pi*(chamber.D^2)/4;

          chamber.th=P.chamber*1.05*1.05*1.25*chamber.D/2/(0.95*chamber.strength-0.6*P.chamber*1.05*1.05*1.25);
          chamber.th_real=chamber.th;
          chamber.th(chamber.th<0.002)=0.002;

end
