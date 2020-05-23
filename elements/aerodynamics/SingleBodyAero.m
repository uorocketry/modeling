classdef SingleBodyAero < Aerodynamics
    %SINGLEBODYAERO Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        
        %body diameters
        dn                              % diameter at nosecone base                                     [m]
        db                              % average diameter of body                                      [m]
        df                              % diameter of body at leading point of fin                      [m]
        du                              % diameter of body at starting of tail cone                     [m]
        dd                              % diameter of bottom on tail cone                               [m]
        deq                             % equivalent diameter used for moment damping                   [m]
        
        %body lengths
        ln                              % length of nosecone                                            [m]
        lb                              % length of body                                                [m]
        lc                              % length of tailcone                                            [m]
        l_TS                            % total horizontal length (ie. fin tip to fin tip)              [m]
        l_TR                            % total vertical length of rocket                               [m]
        
        %body areas
        Ar                              % reference area (base of nosecone)                             [m^2]
        Ap                              % planform area of rocket                                       [m^2]
        A_fp                            % fin planform area                                             [m^2]
        A_fe                            % exposed fin planform area                                     [m^2]
        A_fwt                           % wetted area fins                                              [m^2]
        A_fxs                           % fin cross section area                                        [m^2]
        A_ll                            % exposed area of launch lug                                    [m^2]
        A_ab                            % fully deployed airbrake area                                  [m^2]
        A_bwt                           % wetted area body                                              [m^2]
        A_nSide                         % projected area of nosecone (sideview)                         [m^2]
        
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
        K                               % experimental coeff for correction of stability derivative     []

        % lookup tables for correction factors
        etaTable                        % table for correction factor used in AOA correction            []
        etaAOABreakpoints               % AOA breakpoints for eta correction factor                     []
        
        delTable                        % table for correction factor used in AOA correction            []
        delAOABreakpoints               % AOA breakpoints for del correction factor                     []
               
        % airbrake model table data
        cmdAngleBreakpoints             % breakpoints that specify the input cmd airbrake angle         []
        speedBreakpoints                % breakpoints that specify the input speed (kinematic, earth)   [m/s] 
        increaseInAxialDrag             % delta drag for breakpoint values in table for airbrake model  [N]
        
        % aero consts
        REC = 5*10^5;                   % critical Reylnolds number according to Mandell et al [1973]   [] 

        %Nose Cone Drag Table
        noseConeDragTable1              %Nose cone pressure drag for breakpoint mach nums
        noseConeBreakpoints1            %break points that specify input mach
        
        noseConeDragTable2              %Nose cone pressure drag for breakpoint mach nums
        noseConeBreakpoints2            %break points that specify input mach
    end
    
    methods
        function obj = SingleBodyAero(blockchoice)
            obj@Aerodynamics(blockchoice);
        end
        
        function initialize(obj)
            obj.assignParameters();
            
            % Calculate reference area (base of nosecone)
            obj.Ar = pi*(obj.dn/2)^2;
            
            % Calculate planform aera of rocket
            obj.Ap = obj.dn*obj.lb;
                        
            % Calculate remaining geometries from provided quantities
            obj.lw = obj.lr - obj. lt;      % fin root length - fin tip length
            
            % major fin length
            % TODO: actually compute this!
            obj.lm = 0.14;
            
            % Calculate the wetted area of one fin
            obj.A_fwt = ((obj.lr + obj.lt)/2)*obj.ls;
            
            % total horizontal length
            obj.l_TS = 2*(obj.ls + (obj.df/2))*sin(pi/obj.nf);
            
            % Calculate componentwise Xcp and CNalpha
            obj.Xcp_nose = (obj.ln*obj.Ar - 0.004552288224)/(obj.Ar);       %0.466*obj.ln;                % for ogive nosecone
            obj.Xcp_body = obj.ln + 0.5*obj.lb;                             % correction for lift
            
%             obj.Xcp_fins = obj.Xf + ...
%                            (obj.lm*(obj.lr + 2*obj.lt))/(3*(obj.lr + obj.lt)) + ...
%                            0.6*(obj.lr + obj.lt - ((obj.lr*obj.lt)/(obj.lr+obj.lt)));
                       
            obj.Xcp_fins = (obj.lw/3)*((obj.lr + 2*obj.lt)/(obj.lr + obj.lt))...
                           + (1/6)*((obj.lr^2 + obj.lt^2 + obj.lr*obj.lt)/(obj.lr + obj.lt));
            
            obj.CNalpha_nose = 2;                       % hmmmm, this seems odd
            
            obj.K_BF = 1 + ((0.5*obj.df)/(obj.ls + 0.5*obj.df));
            obj.CNalpha_fins = obj.K_BF*((4*obj.nf*((obj.ls)/(obj.dn))^2)/(1+sqrt(1 + ((2*obj.lm)/(obj.lr + obj.lt))^2)));
                        
            % Calculate fin-body and body-fin infereference coeffs
            obj.Rs = obj.l_TS/obj.df;
            
            obj.k_fb = 0.8065*(obj.Rs^2) + 1.1553*obj.Rs;
            obj.k_bf = 0.1935*(obj.Rs^2) + 0.8174*obj.Rs + 1;
            
            % Calculate fin planer area and exposed fin planer area
            obj.A_fe = 0.8*(obj.lr + obj.lt)*obj.ls;
            obj.A_fp = obj.A_fe + 0.5*obj.df*obj.lr;
            
            % Calculate equivalent diameter Deq for moment damping
            obj.deq = (obj.A_nSide + (obj.l_TR-obj.ln)*2*(obj.dn/2))/(obj.l_TR);
            
            obj.initialized = true;
        end

    end
end

