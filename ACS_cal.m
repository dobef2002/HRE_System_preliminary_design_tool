%%% calculate ACS part

function  Mass=ACS_cal(Mass)
  
             %  calculate the propellant mass for  ACS
             It_ACS=userinputdata.ACS_It;  %  input the total impluse requriment of ACS
             Isp_ACS=150; % (s)  assume 150s for 95% H2O2 as mono propellant     
             Mass.propellant.ACS=(It_ACS/Isp_ACS)*1.05;  %  1.05 mass margin  for resedual
             Mass.ACS=userinputdata.ACS.mass;

end
