classdef Payload2019 < Payload
    %PAYLOAD2019 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
    end
    
    methods
        function obj = Payload2019()
            blockchoice = "payload2019";
            obj@Payload(blockchoice);
        end
        
        function initialize(obj)
        end
    end
end

