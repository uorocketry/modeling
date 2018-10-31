classdef SingleChute < Element
    %SINGLECHUTE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
    end
    
    methods
        function obj = SingleChute(blockchoice)
            name = 'recovery';
            obj = obj@Element(name, blockchoice);
        end
        
        function initialize(obj)
        end
    end
end

