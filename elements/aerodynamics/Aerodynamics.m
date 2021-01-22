classdef Aerodynamics < Element
    %AVIONICS Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
    end
    
    methods
        function obj = Aerodynamics(blockchoice)
            name = 'aerodynamics';
            obj = obj@Element(name, blockchoice);
            obj.libraryLoc = 'elementsLibrary/aerodynamics';
        end 
    end
end

