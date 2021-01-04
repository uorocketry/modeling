classdef HybridRocket < Rocket
    %HybridRocket Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        %Rocket Properties no Fuel Grain
        emptyMass                       % Mass of rocket without fuelgrain                              [Kg]
        emptyCG                         % Center of gravity of rocket without fuelgrain                 [m]
    end
    
    methods
        function obj = HybridRocket(blockchoice)
            obj@Rocket(blockchoice);
            obj.ascent = SingleBodyAscent('Ascentv2');
            obj.propulsion = HybridEngine('HREV1');
            obj.recovery = SingleChute('SingleChute');
            obj.sequencer = FSv1('FSv1');
            obj.avionics = AvionicsCharacterization('AvionicsCharacterization');
            obj.environment = SimpleEnv("Earthv2");
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

