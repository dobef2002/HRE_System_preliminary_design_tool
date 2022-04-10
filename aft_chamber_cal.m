%%% calculate mass of chamber and size of after chamber

function [chamber,Mass]=aft_chamber_cal(Mass,grain,nozzle,chamber)
  
       %L*=5
        chamber.after.Lstar=5;  % (m)
        chamber.after.volumn_theory=chamber.after.Lstar*nozzle.At;
        chamber.after.volumn=chamber.after.volumn_theory-nozzle.volumn_con.insulation_inner-grain.Aport.initial*grain.length;

      % after chamber volumn
        chamber.after.length=chamber.after.volumn/((pi*chamber.D^2)/4);
        chamber.mass=(((pi*(chamber.D+2*chamber.th)^2)/4)-((pi*chamber.D^2)/4))*(chamber.length+chamber.after.length)*chamber.density;
       Mass.chamber=chamber.mass;
end
