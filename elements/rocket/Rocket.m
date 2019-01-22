classdef Rocket < Element
    %ROCKET Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        aero = Aero.empty;
        propulsion = RocketEngine.empty;
        recovery
        sequencer
    end
    
    methods
        function obj = Rocket(blockchoice)
            name = 'rocket';
            obj = obj@Element(name, blockchoice);
        end
    end
end

