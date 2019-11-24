classdef HybridEngine < RocketEngine
    %HybridEngine Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        oxiTank
        
        % injector parameters
        A_ih                                                                % area of injector holes                            [m^2]
        nIHoles                                                             % number of injector holes                          [dimless]
        injector_Cd                                                         % coefficient of discharge of injector              [dimless]

        % paraffin regression model parameters
        a                                                                   % emperical value : a                               [dimless]
        n                                                                   % emperical value : n                               [dimless]

        % nozzle parameters
        %Ae                                                                 % exit area of nozzle                               [m^2]
        At                                                                  % throat area of nozzle                             [m^2]
        Ai                                                                  % inlet area of nozzle                              [m^2]

        % thermochemical properties
        k                                                                   % specific heat ratio for N2O + Paraffin            [dimless]
        gasConst                                                            % gas constant for N2O + Paraffin                   [Joule/(Kg*K)]

        % fudge factors (efficiencies)
        etaCombustion                                                       % combustion efficiency                             [dimless]
        etaNozzle                                                           % nozzle efficiency                                 [dimless]

        % fuel grain parameters
        Dfg_inner                                                           % inner diameter of fuel grain (init port diameter) [m]
        Dfg_outer                                                           % outer diamter of fuel grain                       [m]
        Lfg                                                                 % length of fuel grain                              [m]
        rho_fuel                                                            % density of fuel                                   [Kg/m^3]
        initMassFuel                                                        % initial mass of fuel 
    
        % Other Geometry
        Lpostcc                                                             % Length of Post Combustion Chamber                 [m]
        Lprecc                                                              % Length of Pre Combustion Chamber                  [m]
    end
    
    methods
        function obj = HybridEngine(blockchoice)
            obj = obj@RocketEngine(blockchoice);
            obj.oxiTank = NitrousTank('nitrousTank1');
        end
        
        function set.oxiTank(obj,val)
            assert(isa(val,'PVessel'),'aero needs to be of type PVessel, currently is a %s.',class(val));
            obj.oxiTank = val;
        end

        function initialize(obj)
            obj.assignParameters();
            obj.oxiTank.initialize();
            
            % calculate initial mass of fuel
            obj.initMassFuel = obj.rho_fuel*(((obj.Dfg_outer/2)^2 - ...
                                              (obj.Dfg_inner/2)^2)*obj.Lfg);
            
            obj.initialized = true;
        end
    end
end
