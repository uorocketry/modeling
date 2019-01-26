classdef Avionics < Element
    %AVIONICS Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
    end
    
    methods
        function obj = Avionics(blockchoice)
            name = 'avionics';
            obj = obj@Element(name, blockchoice);
            obj.libraryLoc = 'elementsLibrary/avionics';
        end 
    end
end

