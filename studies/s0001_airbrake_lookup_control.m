%=========================================================================%
% Airbrake Lookup Control Study
% Date: April 27th 2019
%
% Description:
% This is the study that will determine the lookup table which will be
% implemented on flight avionics. The avionics characterization model will 
% be used in the Jackalope model to run this study. 
%
% Parameters Involved:
% Avionics :: airbrakeDeploySpeed
% Avionics :: airbrakeDeployCmd
%
% Outputs Considered:
% Position_E, velocity_E, acceleration_E,
%
% ========================================================================%

% Desired Apogee Threshold
apogeeThres = 10;   %[m]
desApogee = 3048;   %[m]

% Specify desired range of involved parameters for the study
deploySpeedRange = 50:10:250;   %[m/s]
deployCmdRange = [0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0];

% Setting up the simulation Element (ie. Jackalope) and Simulation object
elem = SingleStageSolidRocket('Jackalope');
elem.initialize();

sim = Simulation(elem);

sim.endTime = 100;
sim.timeProfile = 0:sim.simElement.timeStep:sim.endTime;

sim.simInput = struct();
sim.simInput.time = sim.timeProfile;

%Setup study datastructures if needed
%index           :  1   2   3   4   5   6   7   8   9   10 
%delpoly command : [0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0]
%lowestErrorData = zeros(size(deployCmdRange));
lowestErrorApogeeCorresponding = zeros(size(deployCmdRange));
lowestErrorCorresponding = desApogee.*ones(size(deployCmdRange));

%Run the study
for ds = deploySpeedRange
    for dc = deployCmdRange
        fprintf('Simulation Run : DS_%d DC_%d\n', ds, dc);
        sim.simElement.avionics.airbrakeDeploySpeed = ds;
        sim.simElement.avionics.airbrakeDeployCmd = dc;
        res = sim.run();
        
        fprintf('Simulation Run Complete : DS_%d DC_%d\n', ds, dc);
        
        position_E = res.find('position_E');
        apparentVelocityMag = res.find('VaMag_B');
        airbrakeCmdAngle = res.find('airbrakeCmdAngle');
        
        apogee = max(position_E.Values.Data(:,3));
        apogeeWritten = apogee.*ones(size(position_E.Values.Time));
        dsWritten = ds.*ones(size(position_E.Values.Time));
        
        if(((desApogee - apogeeThres) <= apogee) && (apogee <= (desApogee + apogeeThres)))
            fprintf('Apogee Tolerance Found : DS_%d DC_%d\n', ds, dc);
            %headers = ['time[s]','altitude[m]','apparentVelocity[m/s]', 'airbrakeCmd[dimless]', 'apogee[m]', 'deploySpeed[m/s]'];
            dataMatrix = [position_E.Values.Time position_E.Values.Data(:,3) apparentVelocityMag.Values.Data airbrakeCmdAngle.Values.Data apogeeWritten dsWritten];
            %csvwrite(sprintf('results\\s0001_airbrake_lookup_control\\DS-%d_DC_-%d_apo-%d', ds, dc, apogee), headers)
            csvwrite(sprintf('results\\s0001_airbrake_lookup_control\\DS-%d_DC_-%d_apo-%d.csv', ds, dc, apogee), dataMatrix);  
            
            errApo = abs(apogee - desApogee);
            
            if(errApo < lowestErrorCorresponding(dc*10))
                lowestErrorCorresponding(dc*10) = errApo;
                lowestErrorApogeeCorresponding(dc*10) = apogee;
            end
        end
    end
end

files = dir('results\\s0001_airbrake_lookup_control\*.csv');
runs = {};
figure(1);

% plot atitude profiles for each run within threshold
for count = 1:length(files)
    tempMat = csvread(files(count).name);
    nString = sprintf('DS-%d_DC-%d', tempMat(1,6), tempMat(length(tempMat)-2,4));
    runs{count} = nString;
    plot(tempMat(:,1), tempMat(:,2));
    hold on;
end

%legend(runs);
title('Altitude Profile for Runs with Altitude Less Than 10m');
xlabel('time[s]');
ylabel('altitude[m]');
grid;

altBreakPts = [];
velBreakPts = [];
airbrakeCmdVals = [];

