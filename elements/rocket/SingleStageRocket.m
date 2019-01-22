classdef SingleStageRocket < Element
    %SINGLESTAGEROCKET Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        aero = Aero.empty;
        propulsion = SolidMotor.empty;
        
    end
    
    methods
        
        function obj = SingleStageRocket(blockchoice)
            name = 'rocket';
            obj = obj@Element(name, blockchoice);
        end
        
        function initialize(obj)
        end
    end
end

