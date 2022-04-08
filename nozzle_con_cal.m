%%%  nozzle converge part calculate

function [nozzle,Mass]=nozzle_con_cal(P,nozzle,Mass,chamber)

       % length calculate
       % assume half angle of convergen part is 30 degree
   
      nozzle.length.con_1=(chamber.D/2)*cot(60*pi/180);
      nozzle.length.con_2=(nozzle.Dt/2)*cot(60*pi/180);
      nozzle.length.con= nozzle.length.con_1-nozzle.length.con_2;
      nozzle.length.con=nozzle.length.con*0.6;
     
       % Thickness of metal and insulation material

      nozzle.th_con=P.chamber*1.05*1.05*1.25*chamber.D/2/cos(60*pi/180)/(nozzle.con.strebgth*0.95-0.6*P.chamber*1.05*1.05*1.25);
      nozzle.th_con_real=P.chamber*1.05*1.05*1.25*chamber.D/2/cos(60*pi/180)/(nozzle.con.strebgth*0.95-0.6*P.chamber*1.05*1.05*1.25);
      nozzle.th_con(nozzle.th_con<0.002)=0.002;
      
       %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

      nozzle.volumn_con.metal_inner=pi*(nozzle.length.con*(chamber.D^2+nozzle.Dt^2+nozzle.Dt*chamber.D)/4)/3;
      nozzle.volumn_con.metal_outer=pi*nozzle.length.con*(((chamber.D+2*nozzle.th_con)^2+(nozzle.Dt+2*nozzle.th_con)^2+(nozzle.Dt+2*nozzle.th_con)*((chamber.D+2*nozzle.th_con)))/4)/3;
      nozzle.volumn_con.metal=nozzle.volumn_con.metal_outer-nozzle.volumn_con.metal_inner;
      nozzle.volumn_con.insulation_inner=pi*nozzle.length.con*(((chamber.D-2*0.005)^2+(nozzle.Dt-2*0.005)^2+(nozzle.Dt-2*0.005)*((chamber.D-2*0.005)))/4)/3;
           
            %  Volumn of rounf table  V=(pi*h*(D^2+d^2+Dd)/4)/3  

      nozzle.mass_con.metal=nozzle.con.density*nozzle.volumn_con.metal;
      nozzle.mass_con.insulation=nozzle.con_insulation.density*nozzle.volumn_con.insulation; 
      Mass.nozzle.con=nozzle.mass_con.metal+nozzle.mass_con.insulation;   
      Mass.nozzle.total=Mass.nozzle.con+Mass.nozzle.div;

end
      