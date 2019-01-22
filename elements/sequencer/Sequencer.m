classdef Sequencer < Element
    %FSV1 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
    end
    
    methods
        function obj = Sequencer(blockchoice)
            name = 'sequencer';
            obj = obj@Element(name, blockchoice);
            obj.libraryLoc = 'elementsLibrary/sequencer';
        end
    end
end

