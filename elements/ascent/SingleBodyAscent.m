classdef SingleBodyAscent < Ascent
    %SINGLEBODYAERO Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        %Inertia Matrix
        InertiaMatNoEngine              % inertia matrix of rocket (flight config) Yes engine , no propellent                     [Kg*m^2]
                
        % initial orientation
        initQuaternions                 % initial quaternions defining the starting orientation         []        
    end
    
    methods
        function obj = SingleBodyAscent(blockchoice)
            obj@Ascent(blockchoice);
            obj.aerodynamics = SingleBodyAero('barrowmanExt');
        end
        
        function initialize(obj)  
            params = obj.assignParameters();
            
            obj.aerodynamics.initialize();
                                    
            % Calculate initial orientation
            phi_2 = params.lauchTowerOrientation(1)/2;
            theta_2 = params.lauchTowerOrientation(2)/2; 
            psi_2 = params.lauchTowerOrientation(3)/2;
            
            obj.initQuaternions = [ cos(phi_2)*cos(theta_2)*cos(psi_2) + sin(phi_2)*sin(theta_2)*sin(psi_2);...
                                    sin(phi_2)*cos(theta_2)*cos(psi_2) - cos(phi_2)*sin(theta_2)*sin(psi_2);...
                                    cos(phi_2)*sin(theta_2)*cos(psi_2) + sin(phi_2)*cos(theta_2)*sin(psi_2);...
                                    cos(phi_2)*cos(theta_2)*sin(psi_2) - sin(phi_2)*sin(theta_2)*cos(psi_2)];
            
            obj.initialized = true;
        end
    end
end

