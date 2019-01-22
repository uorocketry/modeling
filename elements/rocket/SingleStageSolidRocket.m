classdef SingleStageSolidRocket < Rocket
    %SINGLESTAGESOLIDROCKET Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
    end
    
    methods
        function obj = SingleStageSolidRocket(blockchoice)
            obj@Rocket(blockchoice);
        end
        
        function initialize(obj)
        end
    end
end

