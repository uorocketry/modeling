classdef Payload2021 < Payload
    %PAYLOAD2021 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
    end
    
    methods
        function obj = Payload2021()
            blockchoice = "payload2021";
            obj@Payload(blockchoice);
        end
        
        function initialize(obj)
            obj.assignParameters();
            obj.initialized = true;
        end
    end
end

