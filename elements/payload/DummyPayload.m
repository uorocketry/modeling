classdef DummyPayload < Element
    %DUMMYPAYLOAD Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        
    end
    
    methods
        function obj = DummyPayload()
            name = 'payload';
            obj = obj@Element(name, blockchoice);
        end
        
        function initialize(obj)
        end
    end
end

