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
        
        % important Locations
        Xf                              %fin location from nosetip                                      [m]
        Xc                              %tail cone location from nosetip                                [m]
        Xcp_nose                        %center of pressure location of nosecone from nosetip           [m]
        Xcp_body                        %center of pressure location of body from nosetip               [m]
        Xcp_fins                        %center of pressure location of fins from nosetip               [m]
        
        % CNalpha Components
        CNalpha_nose                    % stability derivative component of nosecone                    []
        CNalpha_fins                    % stability derivative component of fins                        []
        
        % other coeffs
        K_BF                            % coefficient that accounts for increase in normal force due to fin interference
                                        %                                                               []
        Rs                              % fin section ratio                                             []
        k_fb                            % fin-body infereference coeff                                  [] 
        k_bf                            % body-fin intereference coeff                                  []
        del                             % experimental coeff 1 (to calculate AoA effects)               []
        eta                             % experimental coeff 2 (to calculate AoA effects)               []
        kinVisc                         % kinematic viscosity of air ***                                []
        K                               % experimental coeff for correction of stability derivative     []
        
        % other parameters
        surfaceR                        % roughness of the surface of rocket                            [micometers]
        finessRatio                     % the 'fineness' ratio of rocket                                []
        initQuaternions                 % initial quaternions defining the starting orientation         []
        
        % Table Data and breakpoints
        skinFrictionCorrection          % correction factor for skin friction as a function of mach     []
        baseDrag                        % lookup for base drag as a function of mach                    []
        noseDrag                        % lookup for nose cone drag as a function of mach               []
        LeadingEdgeDrag                 % lookup for leading edge drag as a function of mach            []
        qStagRatio                      % lookup for stagnation ratio as a function of mach             []
        machRange                       % breakpoints for lookups above                                 []
        
        etaTable                        % table for correction factor used in AOA correction            []
        etaAOABreakpoints               % AOA breakpoints for eta correction factor                     []
        
        delTable                        % table for correction factor used in AOA correction            []
        delAOABreakpoints               % AOA breakpoints for del correction factor                     []
        
        LtoHcoeff                       % lookup for LtoH coefficient                                   []
        LtoHratio                       % breakpoint for LtoH coefficient lookup                        []
       
        % airbrake model table data
        cmdAngleBreakpoints             % breakpoints that specify the input cmd airbrake angle         []
        speedBreakpoints                % breakpoints that specify the input speed (kinematic, earth)   [m/s] 
        increaseInAxialDrag             % delta drag for breakpoint values in table for airbrake model  [N]
        
        % aero consts
        REC = 5*10^5;                   % critical Reylnolds number according to Mandell et al [1973]   [] 
        
    end
    
    methods
        function obj = SingleBodyAero(blockchoice)
            obj@Aero(blockchoice);
        end
        
        function initialize(obj)  
            obj.assignParameters();
            
            % Calculate componentwise Xcp and CNalpha
            obj.Xcp_nose = 0.466*obj.ln;                % for ogive nosecone
            obj.Xcp_body = obj.ln + 0.5*obj.lb;         % correction for lift
            
            obj.Xcp_fins = obj.Xf + ...
                           (obj.lm*(obj.lr + 2*obj.lt))/(3*(obj.lr + obj.lt)) + ...
                           0.6*(obj.lr + obj.lt - ((obj.lr*obj.lt)/(obj.lr+obj.lt)));
            
            obj.CNalpha_nose = 2;                       % hmmmm, this seems odd
            
            obj.K_BF = 1 + ((0.5*obj.df)/(obj.ls + 0.5*obj.df));
            obj.CNalpha_fins = obj.K_BF*((4*obj.nf*((obj.ls)/(obj.dn))^2)/(1+sqrt(1 + ((2*obj.lm)/(obj.lr + obj.lt))^2)));
            
            obj.initialized = true;
        end
    end
end

