classdef Simulation < handle
    %SIMULATION Class that is responsible for configuring, running, and
    %   post-processing a simulation
    %==================================================================
    % Date Created: Oct 7th 2018
    %==================================================================
    
    properties
        simMode = SimMode.NORM;         % simulation mode
        sysModel                        % simulink model name
        simInput                        % struct of inputs to be fed into the simulation
        simElement                      % element object to be simulated
        timeProfile                     % the time profile that inputs to a simulation must follow
        endTime                         % the ending time of the simulation in seconds
    end
    
    properties (SetAccess = private)
        res                             % processed results structure
        logs                            % 'logsout' from simulink
        simStatus                       % simulation status
    end
    
    properties (Access = private)
        % Don't worry about these!
        fileID = 1;
    end
    
    methods
        function obj = Simulation(element)
            % Constructor function that initializes the element and creates 
            % the Simulation Object
            
            assert(isa(element,'Element'),'element needs to inherit from type Element, currently is a %s.',class(element));
            
            obj.sysModel = 'blankpage';
            obj.simElement = element;
            obj.simStatus = SimState.INSTANTIATED;
        end
        
        function set.simMode(obj,val)
            assert(isa(val,'SimMode'),'simMode needs to be of type SimMode, currently is a %s.',class(val));
            obj.simMode = val;
        end
                
        function res = run(obj)
            % Configures and simulates the instance of the Simulation class
            % as defined by obj. Returns results of the simulation in a
            % structure named 'res'.
            bdclose all;
            obj.configureModel();
            
            obj.simulate();
            
            obj.process();
            
            res = obj.res;
        end
        
        function obj = configureModel(obj)
            % Performs all necessary steps to configure the instance of the
            % Simulation class. This includes generating top level simulink
            % diagram by bringing in element block, environment block and
            % generating input blocks
            
            % Get element name and library location to be used to generate
            % and configure the sysModel
            elementName = obj.simElement.name;
            elementLibraryLoc = obj.simElement.libraryLoc;
            
            % Generate a system model
            modelName = obj.sysModel; 
            fprintf(obj.fileID, 'Performing magic ....\n');
            obj.simulinkMagic(modelName,...
                              elementName,...
                              elementLibraryLoc);
            
            % Assign all variables to simulink workspace
            simulinkWS = get_param(modelName, 'modelworkspace');
            simulinkWS.assignin(elementName, obj.simElement.genStruct());
            simulinkWS.assignin('endTime', obj.endTime);
            simulinkWS.assignin('timeStep', obj.simElement.timeStep);
            simulinkWS.assignin('simInput', obj.simInput);
            simulinkWS.assignin('timeProfile', obj.timeProfile);
            
            % Set simulation status to configured
            obj.simStatus = SimState.CONFIGURED;
        end
        
        function obj = simulate(obj)
            % Simulates the simulink model and generates output
            
            tic
            fprintf(obj.fileID,'========================================\n');
            fprintf(obj.fileID,'Beginning of Simulation:\n');
            fprintf(obj.fileID,'========================================\n');
            
            switch (obj.simMode)
                case SimMode.NORM
                    sim(obj.sysModel);
                    obj.logs = logsout;
                case SimMode.RAPIDACCEL
                    sim(obj.sysModel,'SimulationMode','rapid');
                    obj.logs = logsout;
            end
            
            fprintf(obj.fileID,'========================================\n');
            fprintf(obj.fileID,'End of Simulation');
            fprintf(obj.fileID,'Simulation took %.4g s\n',toc);
            fprintf(obj.fileID,'========================================\n');

        end
        
        function obj = process(obj)
            % Processes the logs from the simulink model
            obj.res = obj.logs;
            obj.simStatus = SimState.POST_PROCESSED;
        end
        
        function openModel(obj)
            % openModel simply opens the system model if the desire is to
            % manually run simulations - or just look at the model in
            % general.
            
            fprintf(obj.fileID,'Opening model ....\n'); 
            
            open_system(obj.sysModel);
            
            % Make simulink diagram look a little better... just a little
            Simulink.BlockDiagram.arrangeSystem(obj.sysModel);
        end

    end
    
    methods(Access = private)
        
        function simulinkMagic(obj, modelName,...
                               elementName,...
                               elementLibraryLoc)
            % This method generates the top level of the system model in  
            % the 'blackpage.slx' model file. All required connections and
            % blocks required to run any simulation will be configured for
            % this top level.
            
            load_system(modelName);
            
            desElementBlockPath = sprintf('%s/%s', modelName, elementName);

            % clock block and handles for these blocks in simulink
            try
                add_block('simulink/Sources/Clock',...
                          sprintf('%s/%s', modelName, 'clock'));
                add_block(elementLibraryLoc,...
                          desElementBlockPath);
                
                clockHandles = get_param(sprintf('%s/clock', modelName),...
                                         'PortHandles');
                
                elementHandles = get_param(desElementBlockPath,...
                                           'PortHandles');
                
                elementInportHandles = find_system(desElementBlockPath,...
                                                   'LookUnderMasks','all',...
                                                   'FollowLinks','on',...
                                                   'FindAll', 'on',...
                                                   'SearchDepth',1,...
                                                   'BlockType','Inport');
                
                elementOutportHandles = find_system(desElementBlockPath,...
                                                    'LookUnderMasks','all',...
                                                    'FollowLinks','on',...
                                                    'FindAll', 'on',...
                                                    'SearchDepth',1,...
                                                    'BlockType','Outport');
            catch
                errorMsg = 'Error 1: Model was not generated!';
                error(errorMsg);
            end
            
            % Try generating all the connections 
            try
                pathInputStruct = 'obj.simInput';
                obj.magicInportConnections(modelName,...
                                           pathInputStruct,...
                                           elementHandles,...
                                           elementInportHandles,...
                                           clockHandles);
                
                obj.magicOutportConnections(modelName,...
                                            elementHandles,...
                                            elementOutportHandles);
            catch
                errorMsg = 'Error 2: Model was not generated!';
                error(errorMsg);
            end
        end
        
        function magicInportConnections(obj,...
                                        modelName,...
                                        pathInputStruct,...
                                        elementHandles,...
                                        elementInportHandles,...
                                        clockHandles)
            % Method to begin the recursive process to generate all
            % connections between simInputs, environment block and element
            % block
            
            % Find blockchoice path in library by manipulating the given
            % block choice and library location of the template block of 
            % any given modeled element
            slashIndecies = strfind(obj.simElement.libraryLoc, '/');
            blockChoicePath = sprintf('%s%s',...
                                      obj.simElement.libraryLoc(1:slashIndecies(end)),...
                                      obj.simElement.blockChoice);
            
            blockChoiceInportHandles = find_system(blockChoicePath,...
                                                   'SearchDepth',1,...
                                                   'LookUnderMasks','all',...
                                                   'FollowLinks','on',...
                                                   'FindAll', 'on',...
                                                   'BlockType','Inport');
                                               
            inportNamesBC = get_param(blockChoiceInportHandles, 'name');
            
            % Main loop to generate all connections. Call the correct
            % resursive function depending on if the input signal is a
            % singleton, a vector or a bus
            for i=1:length(elementInportHandles)
                portName = get_param(blockChoiceInportHandles(i), 'name');
                portIndexBC = find(contains(inportNamesBC, portName), 1);
                
                if(~isempty(portIndexBC))
                    subPath = sprintf('%s.%s', pathInputStruct, portName);
                    sigDimension = size(eval(subPath));
                    
                    if (isstruct(eval(subPath)))
                        obj.magicInportBus(modelName,...
                                           elementHandles.Inport(i),...
                                           subPath,...
                                           clockHandles);
                    elseif (sigDimension > 1)
                        obj.magicInportVector(modelName,...
                                              elementHandles.Inport(i),...
                                              subPath,...
                                              clockHandles,...
                                              sigDimension(1));
                    else
                        obj.magicInportSingleton(modelName,...
                                                 elementHandles.Inport(i),...
                                                 subPath,...
                                                 clockHandles);
                    end
                else
                    groundPath = obj.magicBlockName(modelName,...
                                                    'ground');
                    add_block('simulink/Commonly Used Blocks/Ground',...
                              groundPath);
                          
                    groundHandles = get_param(groundPath, 'portHandles');
                    
                    add_line(modelName,...
                             groundHandles.Outport,...
                             elementHandles.Inport(i),...
                             'autorouting', 'on');
                end
            end
            
            if(~isempty(elementHandles.Enable))
                add_block('simulink/Commonly Used Blocks/Constant',...
                          sprintf('%s/%s',modelName, 'enable_sig'));
                
                ensigHandles = get_param(sprintf('%s/%s', modelName,...
                                                 'enable_sig'),...
                                         'PortHandles');
                
                add_line(modelName, ensigHandles.Outport,...
                         elementHandles.Enable);
            end
        end
        
        function magicInportBus(obj,...
                                modelName,...
                                inportHandleConnection,...
                                subPath,...
                                clockHandles)
            % Method to handle the generation of bus inputs for any
            % simulation element. This method will recursively be called
            % for all nested bus inputs
            
            busPath = obj.magicBlockName(modelName, 'CreatorOfBus');
            fieldsInStruct = eval(sprintf('fieldnames(%s)',subPath));
            lengthOfStruct = sprintf('%d', length(fieldsInStruct));
            
            add_block('simulink/Commonly Used Blocks/Bus Creator',...
                      busPath);
            set_param(busPath, 'Inputs', lengthOfStruct);
            busCHandles = get_param(busPath, 'portHandles');
            
            add_line(modelName,...
                     busCHandles.Outport,...
                     inportHandleConnection,...
                     'autorouting', 'on');
                 
            for i=1:length(fieldsInStruct)
                furtherSubPath = sprintf('%s.%s', subPath,...
                                        fieldsInStruct{i});
                sigDimension = size(eval(furtherSubPath));
                
                if (isstruct(eval(furtherSubPath)))
                    obj.magicInportBus(modelName,...
                                       busCHandles.Inport(i),...
                                       furtherSubPath,...
                                       clockHandles);
                elseif (sigDimension(1) > 1)
                    obj.magicInportVector(modelName,...
                                          busCHandles.Inport(i),...
                                          furtherSubPath,...
                                          clockHandles,...
                                          sigDimension(1));
                else
                    obj.magicInportSingleton(modelName,...
                                             busCHandles.Inport(i),...
                                             furtherSubPath,...
                                             clockHandles);
                end
            end
        end
        
        function magicInportVector(obj,...
                                   modelName,...
                                   inportHandleConnection,...
                                   subPath,...
                                   clockHandles,...
                                   vectorSize)
            % Method to handle the creation of vector inputs for
            % any simulation element. This method will use a mux block to
            % create vector inputs in simulink
            
            dotIndex = strfind(subPath, '.');
            sigName = subPath(dotIndex(end)+1:end);
            
            muxPath = obj.magicBlockName(modelName,...
                                         'mux');
            add_block('simulink/Commonly Used Blocks/Mux',...
                      muxPath);
            set_param(muxPath, 'Inputs', sprintf('%d', vectorSize));
            muxHandles = get_param(muxPath, 'portHandles');
            
            add_line(modelName,...
                     muxHandles.Outport,...
                     inportHandleConnection,...
                     'autorouting', 'on');
            lineHandles = get_param(muxPath, 'linehandles');
            set_param(lineHandles.Outport,...
                      'name', sigName);
                  
            for i=1:vectorSize
                vectorPath = sprintf('%s(%d,:)',...
                                     subPath,...
                                     i);
                obj.magicInportSingleton(modelName,...
                                         muxHandles.Inport(i),...
                                         vectorPath,...
                                         clockHandles);
            end
        end
        
        function magicInportSingleton(obj,...
                                      modelName,...
                                      inportHandleConnection,...
                                      subPath,...
                                      clockHandles)
            % Method to handle the creation of 1D lookup tables and make
            % appropritate connections with clock and given
            % inportHandleConnection. This is the ending point of all
            % recursive inport connection generations
            
            tablePath = strrep(subPath,...
                               'obj.',...
                               '');
            
            dotIndex = strfind(tablePath, '.');
            sigName = tablePath(dotIndex(end)+1:end);
            
            lookupTablePath = obj.magicBlockName(modelName,...
                                                 sigName);
                                             
            add_block('simulink/Lookup Tables/1-D Lookup Table',...
                      lookupTablePath);
            set_param(lookupTablePath, 'NumberOfTableDimensions',...
                      '1');
            set_param(lookupTablePath, 'BreakpointsSpecification',...
                      'Explicit Values');
            set_param(lookupTablePath, 'BreakpointsForDimension1',...
                      'timeProfile');
            set_param(lookupTablePath, 'Table',...
                      tablePath);
            lookupTableHandles = get_param(lookupTablePath, 'portHandles');
            
            add_line(modelName,...
                     clockHandles.Outport,...
                     lookupTableHandles.Inport,...
                     'autorouting', 'on');
            
            add_line(modelName,...
                     lookupTableHandles.Outport,...
                     inportHandleConnection,...
                     'autorouting', 'on');
                 
            lineHandles = get_param(lookupTablePath, 'linehandles');
            set_param(lineHandles.Outport,...
                      'name', sigName);
        end
        
        function magicOutportConnections(obj,...
                                         modelName,...
                                         elementHandles,...
                                         outportHandles)
            % Method to generate all outport connections. On the top level,
            % only a connection to a terminator is required
            %desBlockPath = sprintf("%s/%s",modelName,obj.simElement.name);
            %blockChoiceHandles = get_param(desBlockPath,...
            %                               'PortHandles');
            %blockChoiceOutportHandles = blockChoiceHandles.Outport;
            
            for i=1:length(outportHandles)
                
                terminatorPath = obj.magicBlockName(modelName,...
                                                    'terminator');
                add_block('simulink/Commonly Used Blocks/Terminator',...
                          terminatorPath);
                terminatorHandles = get_param(terminatorPath,...
                                              'portHandles');
                                          
                add_line(modelName,....
                         elementHandles.Outport(i),...
                         terminatorHandles.Inport);
                
            end
        end
        
        function alias = magicBlockName(obj,...
                                        modelName,...
                                        desiredBlockAlias,...
                                        trial)
            % This method generates strings that represent block paths on
            % the top level. If two blocks with the same name are added
            % into a single simulink model, an error is thrown. To avoid
            % this, unique names are generated before an attempt to use the
            % add_block function
                                    
            if ~exist('trial', 'var')
                trial = 1;
            end
            
            aliasesInModel = get_param(modelName, 'blocks');
            
            temptingAttempt = sprintf('%s%d', desiredBlockAlias,...
                                      trial);
            
            if (~isempty(find(strcmp(aliasesInModel, temptingAttempt), 1)))
                alias = obj.magicBlockName(modelName,...
                                           desiredBlockAlias,...
                                           trial+1);
            else
                alias = sprintf('%s/%s', modelName, temptingAttempt);
            end
        end
    end
end

