classdef Aero < Element
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        %Inertia Matrix
        InertiaMatNoEngine
        
        %body diameters
        dn                              % diameter at nosecone base
        db                              % average diameter of body
        df                              % diameter of body at leading point of fin
        du                              % diameter at body at starting of tail cone
        dd                              % diameter of bottom on tail cone
        
        %body lengths
        ln                              % length of nosecone
        lb                              % length of body
        lc                              % length of tailcone
        l_TS                            % total horizontal length (ie. fin tip to fin tip)
        l_TR                            % total vertical length of rocket
        
        %body areas
        Ar                              % reference area (base of nosecone)
        A_fp                            % fin planform area
        A_fe                            % exposed fin planform area
        
        %fin geometry
        lr                              % fin root length
        lt                              % fin tip length
        lw                              % fin root length - fin tip length
        lm                              % fin major length
        ls                              % fin horizontal length
        tf                              % fin thickness
        nf                              % number of fins
        
        % Inportant Locations
        Xf                              %Fin location from nosetip
        Xc                              %Tail cone location from nosetip
        Xcp                             %center of pressure location from nosetip
        
        % other coeffs
        K_BF                            % coefficient that accounts for increase in normal force due to fin interference
        Rs                              % fin section ratio
        k_fb                            % fin-body infereference coeff 
        k_bf                            % body-fin intereference coeff
        del                             % experimental coeff 1 (to calculate AoA effects)
        eta                             % experimental coeff 2 (to calculate AoA effects)
        
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

