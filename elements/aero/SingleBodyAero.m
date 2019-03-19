classdef SingleBodyAero < Aero
    %SINGLEBODYAERO Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        %Inertia Matrix
        InertiaMatNoEngine              % inertia matrix of rocket (flight config)                      [Kg*m^2]
        
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
        A_fwt                           % wetted area fins                                              [m^2]
        A_fxs                           % fin cross section area                                        [m^2]
        A_ll                            % exposed area of launch lug                                    [m^2]
        A_ab                            % fully deployed airbrake area                                  [m^2]
        A_bwt                           % wetted area body                                              [m^2]
        
        %fin geometry
        lr                              % fin root length                                               [m]
        lt                              % fin tip length                                                [m]
        lw                              % fin root length - fin tip length                              [m]
        lm                              % fin major length (mean aero chord)                            [m]
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
        kinVisc                         % kinematic viscosity of air ***                                []
        
        % other params
        surfaceR                        % roughness of the surface of rocket                            [micometers]
        finessRatio                     % the 'fineness' ratio of rocket                                []
        Cn                              % stability derivative
        
        % Table Data and breakpoints
        skinFrictionCorrection          % correction factor for skin friction as a function of mach     []
        baseDrag                        % lookup for base drag as a function of mach                    []
        noseDrag                        % lookup for nose cone drag as a function of mach               []
        LeadingEdgeDrag                 % lookup for leading edge drag as a function of mach            []
        qStagRatio                      % lookup for stagnation ratio as a function of mach             []
        machRange                       % breakpoints for lookups above                                 []
        
        LtoHcoeff                       % lookup for LtoH coefficient                                   []
        LtoHratio                       % breakpoint for LtoH coefficient lookup                        []
        
    end
    
    methods
        function obj = SingleBodyAero(blockchoice)
            obj@Aero(blockchoice);
        end
        
        function initialize(obj)  
            obj.assignParameters();
            obj.initialized = true;
        end
    end
end

