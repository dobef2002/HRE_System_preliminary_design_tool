 % calculate engine mass
 function Mass=engine_mass_cal(Mass)
   
            Mass.payload=userinputdata.payload;

           % mass margin
           Mass.catalyst=1.5*Mass.propellant.flowrate;  %  assume 150g catalyst/ 0.1kg mass flowrate --> 1.5kg / kg
           Mass.Tank.oxidizer_pipe=(Mass.Tank.oxidizer+Mass.Tank.gas)*0.5;
           Mass.Tank.oxidizer_system=Mass.Tank.oxidizer+Mass.Tank.oxidizer_pipe;
            % Overall oxidizer system mass margin 50% --> for diaphfram, mounting support, pipe
           Mass.primaryStructure=Mass.ACS+Mass.propellant.ACS+Mass.nozzle.total+Mass.chamber+Mass.propellant.oxidizer_residual+Mass.Tank.oxidizer+Mass.Tank.gas+Mass.He+Mass.case+Mass.catalyst;

          % Takeoff weight
          
          Mass.takeoff1=Mass.payload+Mass.propellant.total+Mass.primaryStructure;
          

          Mass.total=Mass.ACS+Mass.propellant.ACS+Mass.nozzle.total+Mass.chamber+Mass.propellant.total+Mass.propellant.oxidizer_residual+Mass.Tank.oxidizer_system+Mass.Tank.gas+Mass.He+Mass.case+Mass.catalyst;
          Mass.structure=Mass.total*0.2;     %  Overall mass margin for structure support  
          Mass.total=Mass.total+Mass.structure;
          Maass.takeoff2=Mass.payload+Mass.total;
          Mass.secondaryStructure=Mass.structure+Mass.Tank.oxidizer_pipe;

end

