classdef SingleStageSolidRocket < Rocket
    %SINGLESTAGESOLIDROCKET Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        %Rocket Properties no Fuel Grain
        emptyMass                       % Mass of rocket without fuelgrain                              [Kg]
        emptyCG                         % Center of gravity of rocket without fuelgrain                 []
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
            
            obj.assignParameters();
            
            obj.aero.initialize();
            obj.propulsion.initialize();
            obj.recovery.initialize();
            obj.sequencer.initialize();
            obj.avionics.initialize();
            obj.payload.initialize();
            
            obj.initialized = true;
        end
    end
end

