classdef SolidMotor < Element
    %SOLIDMOTOR Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
    end
    
    methods
        function obj = SolidMotor(blockchoice)
            name = 'propulsion';
            obj = obj@Element(name, blockchoice);
        end
        
        function initialize(obj)
        end
    end
end

