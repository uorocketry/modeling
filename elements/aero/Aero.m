classdef Aero < Element
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        %Inertia Matrix
        InertiaMatNoEngine
        
        %body diameters
        dn                              % diameter at nosecone base                                     [m]
        db                              % average diameter of body                                      [m]
        df                              % diameter of body at leading point of fin                      [m]
        du                              % diameter at body at starting of tail cone                     [m]
        dd                              % diameter of bottom on tail cone                               [m]
        
        %body lengths
        ln                              % length of nosecone                                            [m]
        lb                              % length of body                                                [m]
        lc                              % length of tailcone                                            [m]
        l_TS                            % total horizontal length (ie. fin tip to fin tip)              [m]
        l_TR                            % total vertical length of rocket                               [m]
        
        %body areas
        Ar                              % reference area (base of nosecone)                             [m^2]
        A_fp                            % fin planform area                                             [m^2]
        A_fe                            % exposed fin planform area                                     [m^2]
        
        %fin geometry
        lr                              % fin root length                                               [m]
        lt                              % fin tip length                                                [m]
        lw                              % fin root length - fin tip length                              [m]
        lm                              % fin major length                                              [m]
        ls                              % fin horizontal length                                         [m]
        tf                              % fin thickness                                                 [m]
        nf                              % number of fins                                                [dimless]
        
        % Inportant Locations
        Xf                              %Fin location from nosetip                                      [m]
        Xc                              %Tail cone location from nosetip                                [m]
        Xcp                             %center of pressure location from nosetip                       [m]
        
        % other coeffs
        K_BF                            % coefficient that accounts for increase in normal force due to fin interference
                                        %                                                               []
        Rs                              % fin section ratio                                             []
        k_fb                            % fin-body infereference coeff                                  [] 
        k_bf                            % body-fin intereference coeff                                  []
        del                             % experimental coeff 1 (to calculate AoA effects)               []
        eta                             % experimental coeff 2 (to calculate AoA effects)               []
        
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

