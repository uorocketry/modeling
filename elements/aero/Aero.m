classdef Aero < Element
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
    end
    
    methods
        function obj = Aero()
            name = 'aero';
            obj = obj@Element(name, blockchoice);
        end
        
        function initialize(obj)
        end
    end
end

