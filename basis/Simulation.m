classdef Simulation < handle
    %SIMULATION Class that is responsible for configuring, running, and
    %   post-processing a simulation
    %==================================================================
    % Date Created: Oct 7th 2018
    %==================================================================
    
    properties
        simMode = SimMode.RAPIDACCEL;   % simulation mode
        sysModel                        % simulink model name
        simInput                        % struct of inputs to be fed into the simulation
    end
    
    properties (SetAccess = private)
        simElement                      % element object to be simulated
        res                             % processed results structure
        logs                            % 'logsout' from simulink
        simStatus                       % simulation status
    end
    
    properties (Access = private)
        fileID = 1;
    end
    
    methods
        function obj = Simulation(element)
            % Constructor function that initializes the element and creates 
            % the Simulation Object
            
            assert(isa(element,'Element'),'element needs to inherit from type Element, currently is a %s.',class(element));
            
            obj.sysModel = [];
            obj.simElement = element;
            obj.simStatus = SimState.INSTANTIATED;
        end
        
        function set.simMode(obj,val)
            assert(isa(val,'SimMode'),'simMode needs to be of type SimMode, currently is a %s.',class(val));
            obj.simMode = val;
        end
        
        function res = run(obj)
            % Configures and simulates the instance of the Simulation class
            % as defined by obj. Returns results of the simulation in a
            % structure named 'res'.
            
            obj.configureModel()
            
            obj.simulate()
            
            obj.process()
            
            res = obj.res;
        end
        
        function obj = configureModel(obj)
            % Performs all necessary steps to configure the instance of the
            % Simulation class
            
            obj.simStatus = SimState.CONFIGURED;
        end
        
        function obj = simulate(obj)
            % Simulates the simulink model and generates output
            
            tic
            fprintf(obj.fileID,'========================================');
            fprintf(obj.fileID,'Beginning of Simulation:\n');
            fprintf(obj.fileID,'========================================');
            
            
            
            fprintf(obj.fileID,'========================================');
            fprintf(obj.fileID,'End of Simulation');
            fprintf(obj.fileID,'Simulation took %.4g s\n',toc);
            fprintf(obj.fileID,'========================================');

        end
        
        function obj = process(obj)
            % Processes the logs from the simulink model
        
            obj.simStatus = SimState.POST_PROCESSED;
        end
    end
end

