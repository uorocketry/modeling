classdef SingleStageSolidRocket < Rocket
    %SINGLESTAGESOLIDROCKET Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
    end
    
    methods
        function obj = SingleStageSolidRocket(blockchoice)
            obj@Rocket(blockchoice);
            obj.aero = SingleBodyAero('Aerov1');
            obj.propulsion = SolidMotor('SolidMotor');
            obj.recovery = SingleChute('SingleChute');
            obj.sequencer = FSv1('FSv1');
            obj.avionics = AvionicsV1('Avionicsv1');
            obj.payload = Payload2019();
        end
        
        function initialize(obj)
        end
    end
end
