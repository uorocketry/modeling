classdef SimpleEnvironment < Element
    %SIMPLEENVIRONMENT Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
    end
    
    methods
        function obj = SimpleEnvironment()
            name = 'environment';
            obj = obj@Element(name, blockchoice);
        end
        
        function initialize(obj)
        end
    end
end

