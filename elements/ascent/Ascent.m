classdef Ascent < Element
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        A_ref=1;
    end
    
    methods
        function obj = Ascent(blockchoice)
            name = 'ascent';
            obj = obj@Element(name, blockchoice);
            obj.libraryLoc = 'elementsLibrary/ascent';
        end
    end
end


