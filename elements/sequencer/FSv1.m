classdef FSv1 < Sequencer
    %FSV1 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        launchTower                 % vector defining launch tower                      [m]
        launchTowerLength           % length of launch tower                            [m]
        lauchTowerOrientation       % orientation (roll, pitch, yaw) of launch tower    [degree]
    end
    
    methods
        function obj = FSv1(blockchoice)
            obj@Sequencer(blockchoice);
        end
        
        function initialize(obj)
            obj.assignParameters();
            
            phi_2 = obj.lauchTowerOrientation(1)/2;
            theta_2 = obj.lauchTowerOrientation(2)/2; 
            psi_2 = obj.lauchTowerOrientation(3)/2;

            q = [ cos(phi_2)*cos(theta_2)*cos(psi_2) + sin(phi_2)*sin(theta_2)*sin(psi_2);...
                            sin(phi_2)*cos(theta_2)*cos(psi_2) - cos(phi_2)*sin(theta_2)*sin(psi_2);...
                            cos(phi_2)*sin(theta_2)*cos(psi_2) + sin(phi_2)*cos(theta_2)*sin(psi_2);...
                            cos(phi_2)*cos(theta_2)*sin(psi_2) - sin(phi_2)*sin(theta_2)*cos(psi_2)];
            
            q0_sq = q(1)^2;
            q1_sq = q(2)^2;
            q2_sq = q(3)^2;
            q3_sq = q(4)^2;

            q0q1 = q(1)*q(2);
            q0q2 = q(1)*q(3);
            q0q3 = q(1)*q(4);
            q1q2 = q(2)*q(3);
            q1q3 = q(2)*q(4);
            q2q3 = q(3)*q(4);

            tf = [ (q0_sq + q1_sq - q2_sq - q3_sq)   2*(q1q2-q0q3)                    2*(q0q2+q1q3);
                    2*(q1q2+q0q3)                    (q0_sq - q1_sq + q2_sq - q3_sq)  2*(q2q3-q0q1);
                    2*(q1q3-q0q2)                    2*(q0q1+q2q3)                    (q0_sq - q1_sq - q2_sq + q3_sq)];
        
            launchTower_E = [0;...
                             0;...
                             obj.launchTowerLength];    
            
            obj.launchTower = inv(tf)*launchTower_E; 
            
            obj.initialized = true;
        end
    end
end

