classdef FSv1 < Sequencer
    %FSV1 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        launchTowerLength                       % length of launch tower            [m]
        launchTowerOrientation                  % orientation of launch tower       [rad]
    end
    
    methods
        function obj = FSv1(blockchoice)
            obj@Sequencer(blockchoice);
        end
        
        function initialize(obj)
            obj.assignParameters();
            obj.initialized = true;
        end
    end
end

