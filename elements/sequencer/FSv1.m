classdef FSv1 < Element
    %FSV1 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        
    end
    
    methods
        function obj = FSv1(blockchoice)
            name = 'sequencer';
            obj = obj@Element(name, blockchoice);
        end
        
        function initialize(obj)
        end
    end
end

