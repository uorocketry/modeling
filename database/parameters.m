function retParams = parameters(seek)
%PARAMETERS Returns the desired parameters for Simulation Elements
%   This function will act not only as a function to retrieve parameters
%   used to initialize Simulation Elements but also as the master parameter
%   database. In other words, this is the base truth of parameters that are
%   known.

if (seek == "SingleStageSolidRocket")
        retParams = struct();
end

if (seek == "SingleBodyAero")
        
        retParams = struct();
    
        %Inertia Matrix
        retParams.InertiaMatNoEngine = 0;
        
        %body diameters
        retParams.dn = 0;                             % diameter at nosecone base                                     [m]
        retParams.db = 0;                             % average diameter of body                                      [m]
        retParams.df = 0;                             % diameter of body at leading point of fin                      [m]
        retParams.du = 0;                             % diameter at body at starting of tail cone                     [m]
        retParams.dd = 0;                             % diameter of bottom on tail cone                               [m]
        
        %body lengths
        retParams.ln = 0;                             % length of nosecone                                            [m]
        retParams.lb = 0;                             % length of body                                                [m]
        retParams.lc = 0;                             % length of tailcone                                            [m]
        retParams.l_TS = 0;                           % total horizontal length (ie. fin tip to fin tip)              [m]
        retParams.l_TR = 0;                           % total vertical length of rocket                               [m]
        
        %body areas
        retParams.Ar = 0;                             % reference area (base of nosecone)                             [m^2]
        retParams.A_fp = 0;                           % fin planform area                                             [m^2]
        retParams.A_fe = 0;                           % exposed fin planform area                                     [m^2]
        
        %fin geometry
        retParams.lr = 0;                             % fin root length                                               [m]
        retParams.lt = 0;                             % fin tip length                                                [m]
        retParams.lw = 0;                             % fin root length - fin tip length                              [m]
        retParams.lm = 0;                             % fin major length                                              [m]
        retParams.ls = 0;                             % fin horizontal length                                         [m]
        retParams.tf = 0;                             % fin thickness                                                 [m]
        retParams.nf = 0;                             % number of fins                                                [dimless]
        
        % Inportant Locations
        retParams.Xf = 0;                             %Fin location from nosetip                                      [m]
        retParams.Xc = 0;                             %Tail cone location from nosetip                                [m]
        retParams.Xcp = 0;                            %center of pressure location from nosetip                       [m]
        
        % other coeffs
        retParams.K_BF = 0;                           % coefficient that accounts for increase in normal force due to fin interference
                                                      %                                                               []
        retParams.Rs = 0;                             % fin section ratio                                             []
        retParams.k_fb = 0;                           % fin-body infereference coeff                                  [] 
        retParams.k_bf = 0;                           % body-fin intereference coeff                                  []
        retParams.del = 0;                            % experimental coeff 1 (to calculate AoA effects)               []
        retParams.eta = 0;                            % experimental coeff 2 (to calculate AoA effects)               []

end 

if (seek == "SolidMotor")
    retParams = struct();
end

if (seek == "SolidMotor")
    retParams = struct();
end

if (seek == "SingleChute")
    retParams = struct();
end

if (seek == "AvionicsV1")
    retParams = struct();
end 

if (seek == "Payload2019")
    retParams = struct();
end

if (seek == "FSv1")
    retParams = struct();
end

end

