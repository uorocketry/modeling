classdef SingleStageSolidRocketV2 < Rocket
    %SINGLESTAGESOLIDROCKET Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        %Rocket Properties no Fuel Grain
        emptyMass                       % Mass of rocket without fuelgrain                              [Kg]
        emptyCG                         % Center of gravity of rocket without fuelgrain                 [m]
    end
    
    methods
        function obj = SingleStageSolidRocketV2(blockchoice)
            obj@Rocket(blockchoice);
            obj.ascent = SingleBodyAscent('Ascentv2');
            obj.propulsion = SolidMotor('SolidMotor');
            obj.recovery = SingleChute('SingleChute');
            obj.sequencer = FSv1('FSv1');
            obj.avionics = AvionicsCharacterization('AvionicsCharacterization');
            obj.environment = SimpleEnv("Earthv1");
            obj.payload = Payload2019();
        end
        
        function initialize(obj)
            
            obj.assignParameters();
            
            obj.ascent.initialize();
            obj.propulsion.initialize();
            obj.recovery.initialize();
            obj.sequencer.initialize();
            obj.avionics.initialize();
            obj.payload.initialize();
            obj.environment.initialize();
            
            obj.initialized = true;
        end
    end
end