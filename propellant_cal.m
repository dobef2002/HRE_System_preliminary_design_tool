%%%% propellant calculate

function Mass=propellant_cal(F_avg,total_impulse,of_cea,isp_vac_real)

          Mass.propellant.oxidizer_residual_factor=0.03;
          
          Mass.propellant.total=total_impulse/isp_vac_real; % theory total propellant requriment
          Mass.propellant.fuel=Mass.propellant.total/(1+of_cea);
          Mass.propellant.oxidizer=Mass.propellant.total-Mass.propellant.fuel;
          Mass.propellant.flowrate=F_avg/isp_vac_real;
          Mass.propellant.oxidizer_residual=Mass.propellant.oxidizer*Mass.propellant.oxidizer_residual_factor;
          Mass.propellant.oxidizer_real=Mass.propellant.oxidizer+Mass.propellant.oxidizer_residual;

end