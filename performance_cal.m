%%% Calculate HRE system performance and takeoff weight

function [performance,Mass]=performance_cal(Mass,isp_vac_real,total_impulse,Rf,eff_,ballistic)

       Mass.payload=200; %assume payload is 200kg
       Mass.propellant.total_real=Mass.propellant.fuel+Mass.propellant.ACS+Mass.propellant.oxidizer_real;
       
      % Mass.propellant.total_real=total propellant weight include residual and H2O2 for ACS
      %Mass.propellant.total=total avaliable propellant weight whichis not include residual and H2O2 for ACS
      %prformance

       performance.isp_vs_mass=isp_vac_real*eff_/Mass.total;
       
       performance.massisp=ballistic.It_deliver*eff_/Mass.total;
     
       performance.Massratio=Mass.total/(Mass.total-Mass.propellant.total); 

       performance.Massratio2=Mass.propellant.total/Mass.total;

       performance.Massratio3=Mass.propellant.total/(Mass.total+Mass.payload);

       performance.takeoff1_massratio=Mass.propellant.total/(Mass.propellant.total+Mass.primaryStructure);

       % solution 1

       performance.takeoff1_massratio2=Mass.propellant.total/Mass.takeoff1;

       % solution 2

       performance.takeoff2_massratio2=Mass.propellant.total/Mass.takeoff2;

       % solution 3

       performance.delta_velocity=9.80665*isp_vac_real*eff_*log(Mass.total+Mass.payload)/(Mass.total+Mass.payload-Mass.propellant.total));
       performance.takeoff1_delta_velocity_withoutpayload=9.80665*isp_vac_real*eff_*log((Mass.takeoff1-Mass.payload)/(Mass.takeoff1-Mass.payload-Mass.propellant.total));

       performance.isp=isp_vac_real*eff_;

end


       
  