classdef AvionicsCharacterization < Avionics
    %AVIONICSCharacterization Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        % airbrake properties
        airbrakeDeploySpeed
        airbrakeDeployCmd
        
        % recovery deployment parameters
        descentTwoDeployAltitude
    end
    
    methods
        function obj = AvionicsCharacterization(blockchoice)
            obj@Avionics(blockchoice);
        end
        
        function initialize(obj)
            obj.assignParameters();
            obj.initialized = true;
        end
    end
end


