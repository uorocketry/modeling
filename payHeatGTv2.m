%% Initialize model and geometry
% Break our model in three parts. The first part will model the temperature
% distribution throughout the rocket at the payload region while the
% dry ice is subliminating and the rocket is in flight. The second and
% third parts of the model calculates the temperature distribution
% throughout the payload section of the rocket when, respectively, the
% rocket is in flight and the rocket isn't in flight. 

thermalmodel1 = createpde('thermal', 'transient');
thermalmodel2 = createpde('thermal', 'transient');
thermalmodel3 = createpde('thermal', 'transient');

% It'll suffice to do things axisymmetrically like before. Create as many
% rectangles as they are layers like so. 
r1 = [3 4 -0.05 0.05 0.05 -0.05 0 0 0.04 0.04]; % Payload Layer
r2 = [3 4 -0.05 0.05 0.05 -0.05 0.04 0.04 0.15 0.15]; % Layer 1
r3 = [3 4 -0.15 -0.05 -0.05 -0.15 0 0 0.15 0.15]; % Layer 2
r4 = [3 4 -0.15 0.05 0.05 -0.15 0.15 0.15 0.153 0.153]; % Payload Aluminum Wall
r5 = [3 4 -0.65 -0.15 -0.15 -0.65 0.03 0.153 0 0]; % Approx. Dimensions of Nosecose. Dimensions will improve as more information comes up

gdm1 = [r2; r3; r4; r5]'; % Model 1
gdm2 = [r2; r3; r4; r5; r1]'; % Model 2

g1 = decsg(gdm1);
g2 = decsg(gdm2);

geometryFromEdges(thermalmodel1,g1);
geometryFromEdges(thermalmodel2,g2);
geometryFromEdges(thermalmodel3,g2);

generateMesh(thermalmodel1,'Hmax',0.005);
generateMesh(thermalmodel2,'Hmax',0.005);
generateMesh(thermalmodel3,'Hmax',0.005);

%Plot out the geometry
figure 
pdegplot(thermalmodel2,'EdgeLabels', 'on', 'FaceLabels','on'); 
axis ([-0.70 0.70 -0.010 0.20]);

%% For Reference

% Insulation Layer 1 (Polyurthlene)
k1 = 0.026; %W/m*C
rho1= 30; %kg/m^3
cp1 = 2100; %J/kg*C
alpha1 = (k1)/(rho1*cp1);

% Payload Layer (Dry Ice)
kp = 0.01663;
rhop = 1562; 
cpp = 791;
alpha2 = (kp)/(rhop*cpp); 

% Wall Layer (fiberglass)
kw = 0.04; % W/m*C
rhow = 150; %kg/m^3
cpw = 1200; %J/kg*C

% Nosecone (carbon fiber aka CFRPs)
% These values were averaged out from a number of other references covering
% a wide variety of applications 

kc = 5; 
rhoc = 1570;
cpc = 1100; 

%% Specify Material Properties

% These parameters need to be checked
absorb_factor = 0.31; % Absorptivity of rocket walls (fiberglass) to solar irradiation.
emmisivity = 0.75;% Infrared emmisivity (Fiberglass) of rocket walls. 

% dry ice properties
mdot = 0.03e-3; %sublimination rate (dry ice)(kg/s)
Ls = (571000); %latent heat of sublimination J/kg(dry ice)
q = -Ls * mdot; % heat source, W 

m_0=0.030; % Initial mass of dry ice (kg)
t_s = (m_0)/mdot; % End of sublimination time


% Environmental properties
h_c = 950; %W/m^2, convective heat coefficient for air assuming forced convection. This is probably wrong. 
h_n = (2.5+25)/2; %W/m^2, covective heat coefficient for air assuming natural convection. This is taken as an average 
                   %of the supposed maximum and minimum values of the coefficient.
sb_const = 5.6703e-8;% W/m^2* C^4
T_sun = 5526.85; % C
R_sun = 696340e3; % radius of the sun, m
D_from_Sun = 152100000e3; % earth-sun distance, m
solar_flux = 1368; %W/m^2
our_solar_flux = (R_sun^2/D_from_Sun^2)*sb_const*T_sun^4;% W/m^2
orbital_eccentricity = 1.0;
radiative_heat_flux =absorb_factor*orbital_eccentricity*cos((34*pi)/180)*solar_flux;

% Create coefficient functions to accomodate axisymmetric approximations
%qFunc = @(region,state) (q*region.y);% The internal heat generation term is in W/m^3
hcFunc = @(region,state) (h_c*region.y);
hnFunc = @(region,state) (h_n*region.y);
netFunc = @(region,state)(radiative_heat_flux)*region.y; 
%Net heat of rocket surface when accounting for 
%radiation and convection

% Specify Thermal Properties for each one of our layers 


thermalProperties(thermalmodel1,'ThermalConductivity',@kfun, ...
                                        'MassDensity',@mfun, ...
                                        'SpecificHeat',@cfun);

thermalProperties(thermalmodel2,'ThermalConductivity',@kfun, ...
                                        'MassDensity',@mfun, ...
                                        'SpecificHeat',@cfun);
                                    
thermalProperties(thermalmodel3,'ThermalConductivity',@kfun, ...
                                        'MassDensity',@mfun, ...
                                        'SpecificHeat',@cfun);      
                                    
 
%% Specify boundary conditions for the first part of the model 

thermalBC(thermalmodel1,'Edge',[1,5],'Temperature',-78);
thermalBC(thermalmodel1,'Edge',2,'HeatFlux',netFunc,'ConvectionCoefficient',hcFunc,'AmbientTemperature',30);
thermalBC(thermalmodel1,'Edge',[3,4],'HeatFlux',netFunc,'ConvectionCoefficient',hcFunc,'AmbientTemperature',30);

%% Specify boundary conditions for the second part of the model 

thermalBC(thermalmodel2,'Edge',1,'HeatFlux',netFunc,'ConvectionCoefficient',hcFunc,'AmbientTemperature',30);
thermalBC(thermalmodel2,'Edge',[2,3],'HeatFlux',netFunc,'ConvectionCoefficient',hcFunc,'AmbientTemperature',30);

%% Specify boundary conditions for the third part of the model 

thermalBC(thermalmodel3,'Edge',1,'HeatFlux',netFunc,'ConvectionCoefficient',hcFunc,'AmbientTemperature',30);
thermalBC(thermalmodel3,'Edge',[2,3],'HeatFlux',netFunc,'ConvectionCoefficient',hnFunc,'AmbientTemperature',30);

%% Solve the first part

tfinal1 = t_s;
tlist = 0:10:tfinal1;
thermalIC(thermalmodel1,0,'face',[1,2,3,4]);
thermalmodel1.SolverOptions.ReportStatistics = 'on';
result1 = solve(thermalmodel1,tlist);
T = result1.Temperature;
T_func = @(locations) interpolateTemperature(result1,locations.x,locations.y,length(tlist)); 


%% Solve the second part

tfinal2 = tfinal1+500; % Ideally, this time would reflect the amount of time 
% it would take for the rocket to touch down from the point in its trajectory that all of its dry ice has subliminated
tlist2 = tfinal1:10:tfinal2;
thermalIC(thermalmodel2,-78,'face',5);
thermalIC(thermalmodel2, T_func, 'face',[1,2,3,4]);
thermalmodel2.SolverOptions.ReportStatistics = 'on';
result2 = solve(thermalmodel2,tlist2);
T2 = result2.Temperature;
T2_func = @(locations) interpolateTemperature(result2,locations.x,locations.y,length(tlist2)); 


%% Solve the third part

tfinal3 = tfinal2+80000; % The amount of time from the rocket touching down to its recovery. 
tlist3 = tfinal2:10:tfinal3;
thermalIC(thermalmodel3, T2_func, 'face',[1,2,3,4,5]);
thermalmodel3.SolverOptions.ReportStatistics = 'on';
result3 = solve(thermalmodel3,tlist3);
T3 = result3.Temperature;


%% Returns the time at the payload in which the temperature is greater than or equal to 4 degrees celcius. 

T_func_alt = @(x,y,t) interpolateTemperature(result1,x,y,t);
T2_func_alt = @(x,y,t) interpolateTemperature(result2,x,y,t); 
T3_func_alt = @(x,y,t) interpolateTemperature(result3,x,y,t); 


for i=1:length(tlist)
        if (T_func_alt(0,0.02,i) >= 4)
            disp('Temperature exceeds 4 degrees celsius at a time of');
            disp(tlist(i));
            disp('seconds');
            break;
        end
end

for i=1:length(tlist2)
          if (T2_func_alt(0,0.02,i) >= 4)
            disp('Temperature exceeds 4 degrees celsius at a time of');
            disp(tlist2(i));
            disp('seconds');
            break;
          end
end

for i=1:length(tlist3)
          if (T3_func_alt(0,0.02,i) >= 4)
            disp('Temperature exceeds 4 degrees celsius at a time of');
            disp(tlist3(i));
            disp('seconds');
            break;
          else
              if (i==length(tlist3))
             disp('Time at which payload temperature exceeds 4 degrees is beyond calculated range. Final temperature is..');
             disp(T3_func_alt(0,0.02,i));
             disp('At a time of');
             disp(tlist3(i));
             disp('seconds');
              end
          end
end
       
        
%% Plot the solution to the first part of the model

figure; 
for i=1:(length(tlist))
    pdeplot(thermalmodel1,'XYData',T(:,i),'Contour','on','ColorMap','hot'); 
    title(sprintf('Transient Temperature at Final Time (%g seconds)',tlist(i)));
    axis equal
    drawnow
    pause(0.1)
end

%% Plot the solution to the second part of the model

for i=1:length(tlist2)
    pdeplot(thermalmodel2,'XYData',T2(:,i),'Contour','on','ColorMap','hot'); 
    title(sprintf('Transient Temperature at Final Time (%g seconds)',tlist2(i)));
    axis equal
    drawnow
    pause(0.1)
end

%% Plot the solution to the third part of the model

for i=1:length(tlist3)
    pdeplot(thermalmodel3,'XYData',T3(:,i),'Contour','on','ColorMap','hot'); 
    title(sprintf('Transient Temperature at Final Time (%g seconds)',tlist3(i)));
    axis equal
    drawnow
    pause(0.1)
end

%% Functions 

% Assigns a different thermal conductivity based on region ID. We take into account 
% that the model assigns region IDs to different coordinates of the geometry in matrix
% form. 

function k = kfun(region,state)
k1 = 0.026; % Polyurthelene
kw = 0.040; % Fiberglass
kp = 0.0166; % Dry Ice
kc = 5; % Carbon Fiber


for i= 1:length(region.subdomain)
 if region.subdomain(i) == 1
     k = kc*region.y;
 elseif region.subdomain(i) == 2
     k = k1*region.y;
 elseif region.subdomain(i) == 3
     k = k1*region.y;
 elseif region.subdomain(i) == 4
     k = kw*region.y; 
 elseif region.subdomain(i) == 5
     k = kp*region.y;
 end
end

end

% Assigns a different specific heat based on region ID. 

function c = cfun(region,state)
c1 = 2100;
cw = 1200;
cp = 791;
cc = 1100;

for i = 1:length(region.subdomain)
  if region.subdomain(i) == 1
     c = c1*region.y;
  elseif region.subdomain(i) == 2
     c = c1*region.y;
  elseif region.subdomain(i) == 3
     c = c1*region.y;
  elseif region.subdomain(i) == 4
     c = cw*region.y; 
  elseif region.subdomain(i) == 5
     c = cp*region.y; 
     
  end
end

    
end

% Assigns a different mass density based on region ID. 

function rho = mfun(region,state)
rho1 = 30;
rhop = 1562;
rhow = 150;
rhoc = 1570;

for i = 1:length(region.subdomain)
  if region.subdomain(i) == 1
     rho = rhoc;
  elseif region.subdomain(i) == 2
     rho = rho1;
  elseif region.subdomain(i) == 3
     rho = rho1;
  elseif region.subdomain(i) == 4
     rho = rhow;
  elseif region.subdomain(i) == 5
     rho = rhop;
  end
end
    
end

