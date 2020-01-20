classdef Aero < Element
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        A_ref=1;
    end
    
    methods
        function obj = Aero(blockchoice)
            name = 'aero';
            obj = obj@Element(name, blockchoice);
            obj.libraryLoc = 'elementsLibrary/aero';
        end
    end
end


