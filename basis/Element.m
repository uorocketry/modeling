classdef Element < handle
    %ELEMENT Abstract parent class that all elements will inherit from;
    %   These elements will be used to model anything and everything that
    %   uorocketry needs to perform studies upon
    %==================================================================
    % Date Created: Oct 7th 2018
    %==================================================================
    
    properties (SetAccess = protected)
        name                            %detailed name of the element
        libraryLoc                      %location of simulink library where element lives
        initialized = false             %initialization flag
    end
    
    properties
        blockChoice                     %block choice from simulink library
        timeStep                        %time step the element will be run at
    end
    
    methods(Abstract)
        
        % This method is responsible for initializing (in whichever way)
        % an instance of an element so that it can be used during a 
        % simulation.
        %
        % This method is abstract in this class so that it is imposed on
        % children classes to implement. That is, children of this class
        % must implement this method for completeness.
        initialize(obj)

    end
    
    methods
        
        function obj = Element(name, blockChoice)
            % A template constructor for any class that inherits this,
            % super grandparent class
            
            if nargin > 0
                obj.name = name;
            end
            if nargin > 1
                obj.blockChoice = blockChoice;
            end
        end
        
        function elements = getSubElements(obj)
            % This method will return a list of subelements for any
            % element object
            
            %get properties of the current element object
            props = properties(obj);
            elements = {};
            
            %covert properties to struct
            for i = 1:length(props)
                % If any property in the this element objct is of type
                % element, it is a subelement
                if (isa(obj.(props{i}), 'Element'))
                    elements{end + 1} = obj.(props{i}); %#ok<AGROW>
                end 
            end
            
        end
        
    end
    
    methods (Access = protected)
        
        function structure = genStruct(obj)
            % This method converts this instance of the Element class into
            % a structure that can be consumed by the simulink model
            
            % Get all properties of this instance of the Element class
            props = properties(obj);
            
            for i = 1:length(props)
                if (isa(obj.(props{i}),'Element'))
                    % Recursively generate structures for all embedded
                    % elements
                    structure.(obj.(props{i}).name) = obj.(props{i}).genStruct();
                else
                    % Get value of property if it is not an element
                    structure.(props{i}) = obj.(props{i});
                end
            end
        end
             
    end
end

