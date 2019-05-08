classdef Rocket < Element
    %ROCKET Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        aero
        propulsion
        recovery
        sequencer
        avionics
        payload
        environment
    end
    
    methods
        function obj = Rocket(blockchoice)
            name = 'rocket';
            obj = obj@Element(name, blockchoice);
            obj.libraryLoc = 'elementsLibrary/rocket';
        end
        
        function set.aero(obj,val)
            assert(isa(val,'Aero'),'aero needs to be of type Aero, currently is a %s.',class(val));
            obj.aero = val;
        end
        
        function set.propulsion(obj,val)
            assert(isa(val,'RocketEngine'),'propulsion needs to be of type RocketEngine, currently is a %s.',class(val));
            obj.propulsion = val;
        end
        
        function set.recovery(obj,val)
            assert(isa(val,'Recovery'),'recovery needs to be of type Recovery, currently is a %s.',class(val));
            obj.recovery = val;
        end
        
        function set.sequencer(obj,val)
            assert(isa(val,'Sequencer'),'sequencer needs to be of type Sequencer, currently is a %s.',class(val));
            obj.sequencer = val;
        end
        
        function set.avionics(obj,val)
            assert(isa(val,'Avionics'),'avionics needs to be of type Avionics, currently is a %s.',class(val));
            obj.avionics = val;
        end
        
        function set.payload(obj,val)
            assert(isa(val,'Payload'),'payload needs to be of type Payload, currently is a %s.',class(val));
            obj.payload = val;
        end
        
        %TODO: Make a generic parent class for all environments and change
        %      this assertion
        function set.environment(obj,val)
            assert(isa(val,'SimpleEnv'),'environment needs to be of type SimpleEnv, currently is a %s.',class(val));
            obj.environment = val;
        end

    end
end

