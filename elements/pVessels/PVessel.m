classdef PVessel < Element
    %PVESSEL Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        L_OxiTank
        D_OxiTank
        volumeTank
    end
    
    methods
        function obj = PVessel(blockchoice)
            name = 'pvessel';
            obj = obj@Element(name, blockchoice);
            obj.libraryLoc = 'elementsLibrary/pvessel';
        end
    end
end