%% Initialize model and geometry
% Break our model in two parts. The first part will model the temperature
% distribution throughout the rocket at the payload region while all the
% dry ice is subliminating. The second part of the model will consider what
% happens after the dry ice finishes subliminating. 

thermalmodel1 = createpde('thermal', 'transient');
thermalmodel2 = createpde('thermal', 'transient');

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

generateMesh(thermalmodel1,'Hmax',0.005);
generateMesh(thermalmodel2,'Hmax',0.005);

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
h_c = 950; %W/m^2, convective heat coefficient for air. This is probably wrong. 
sb_const = 5.6703e-8; % W/m^2* C^4
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
 
%% Specify boundary conditions
% Boundary conditions between subdomains are "not needed" in finite
% element method (circa 2013) ... not for our case, anyhow. 

%internalHeatSource(thermalmodel2,qFunc,'Face',1);

thermalBC(thermalmodel1,'Edge',[1,5],'Temperature',-78);
%thermalBC(thermalmodel1,'Edge',[10,11],'Temperature',30); 
%thermalBC(thermalmodel1,'Edge',[1,5],'HeatFlux',qFunc);
thermalBC(thermalmodel1,'Edge',2,'HeatFlux',netFunc,'ConvectionCoefficient',hcFunc,'AmbientTemperature',30);
thermalBC(thermalmodel1,'Edge',[3,4],'Temperature',250); % Temperature here will likely be a function of multiple things in the final product (time, altitude, etc.)
%thermalBC(thermalmodel1,'Edge',3,'Temperature',30); 
%thermalBC(thermalmodel1,'Edge',10,'Temperature',23);

%thermalBC(thermalmodel,'Edge',1,'Temperature',30); 
%thermalBC(thermalmodel,'Edge',4,'Temperature',23);
%thermalBC(thermalmodel,'Edge',5,'Temperature',23);
%thermalBC(thermalmodel,'Edge',6,'Temperature',23);
%thermalBC(thermalmodel,'Edge',7,'Temperature',23);
%thermalBC(thermalmodel2,'Edge',1,'Temperature',23); 
thermalBC(thermalmodel2,'Edge',[2,3],'Temperature',250); 
thermalBC(thermalmodel2,'Edge',1,'HeatFlux',netFunc,'ConvectionCoefficient',hcFunc,'AmbientTemperature',30);
%thermalBC(thermalmodel1,'Edge',3,'Temperature',30); 
%thermalBC(thermalmodel2,'Edge',[12,13],'Temperature',30); 
%% Compute Transient Models

%Solve the first model
tfinal1 = t_s;
tlist = 0:10:tfinal1;
%thermalIC(thermalmodel1,-78,'face',1);%ICs set to -78 C at the payload layer. This would represent the entirity of our 
%layer being filled with dry ice. 
thermalIC(thermalmodel1,0,'face',[1,2,3,4]);
thermalmodel1.SolverOptions.ReportStatistics = 'on';
result1 = solve(thermalmodel1,tlist);
T = result1.Temperature;
T_func = @(locations) interpolateTemperature(result1,locations.x,locations.y,length(tlist)); 
%initfun = @(locations)locations.x.^2 + locations.y.^2;
mpaFace = findThermalProperties(thermalmodel1.MaterialProperties,'Face',[1,2,3]);
mpaFace2 = findThermalProperties(thermalmodel2.MaterialProperties,'Face',[1,2,3,4]);

%% Solve the second mode

tfinal2 = 80000;
tlist2 = 0:25:tfinal2;
thermalIC(thermalmodel2,-78,'face',5);
thermalIC(thermalmodel2, T_func, 'face',[1,2,3,4]);
thermalmodel2.SolverOptions.ReportStatistics = 'on';
result2 = solve(thermalmodel2,tlist2);
T2 = result2.Temperature;

%% Plot the solution

figure; 
for i=1:(length(tlist))
    pdeplot(thermalmodel1,'XYData',T(:,i),'Contour','on','ColorMap','hot'); 
    title(sprintf('Transient Temperature at Final Time (%g seconds)',tlist(i)));
    axis equal
    drawnow
    pause(0.1)
end

%% Plot the solution after the dry ice finishes subliminating. 

for i=1:length(tlist2)
    pdeplot(thermalmodel2,'XYData',T2(:,i),'Contour','on','ColorMap','hot'); 
    title(sprintf('Transient Temperature at Final Time (%g seconds)',tlist2(i)));
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

