classdef Payload < Element
    %PAYLOAD Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
    end
    
    methods
        function obj = Payload(blockchoice)
            name = 'payload';
            obj = obj@Element(name, blockchoice);
            obj.libraryLoc = 'elementsLibrary/payload';
        end
    end
end

