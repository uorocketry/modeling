classdef Ascent < Element
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        aerodynamics
    end
    
    methods
        function obj = Ascent(blockchoice)
            name = 'ascent';
            obj = obj@Element(name, blockchoice);
            obj.libraryLoc = 'elementsLibrary/ascent';
        end
        
        function set.aerodynamics(obj,val)
            assert(isa(val,'Aerodynamics'),'aerodynamics needs to be of type Aerodynamics, currently is a %s.',class(val));
            obj.aerodynamics = val;
        end

    end
end


