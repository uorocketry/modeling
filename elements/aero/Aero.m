classdef Aero < Element
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        %Inertia Matrix
        InertiaMatNoEngine
        
        %body diameters
        dn
        db
        du
        
        %body lengths
        ln
        lb
        lc
        l_TS
        l_TR
        
        %fin geometry
        lr
        lt
        lm
        lf
    end
    
    methods
        function obj = Aero(blockchoice)
            name = 'aero';
            obj = obj@Element(name, blockchoice);
        end
        
        function initialize(obj)
        end
    end
end

