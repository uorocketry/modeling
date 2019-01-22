classdef Recovery < Element
    %RECOVERY Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
    end
    
    methods
        function obj = Recovery(blockchoice)
            name = 'recovery';
            obj@Element(name, blockchoice);
            obj.libraryLoc = 'elementsLibrary/recovery';
        end
        
        function outputArg = method1(obj,inputArg)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            outputArg = obj.Property1 + inputArg;
        end
    end
end

