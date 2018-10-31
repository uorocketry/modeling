classdef DummyAvionics < Element
    %DUMMYAVIONICS Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        
    end
    
    methods
        function obj = DummyAvionics()
            name = 'avionics';
            obj = obj@Element(name, blockchoice);
        end
        
        function initialize(obj)
        end
    end
end

