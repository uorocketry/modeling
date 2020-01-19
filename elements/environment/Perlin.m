classdef Perlin < matlab.System
    properties(DiscreteState)
        y1;
        y2;
    end

    % Pre-computed constants
    properties(Access = private)
        
    end

    methods(Access = protected)
        function setupImpl(obj)
            % Perform one-time calculations, such as computing constants
        end

        function y = stepImpl(obj,u)
            % Implement algorithm. Calculate y as a function of input u and
            % discrete states.
            y = u;
        end

        function resetImpl(obj)
            % Initialize / reset discrete-state properties
        end
        
        function y = perlin(x, spacing, mean, varience)
            segment = floor(x / spacing);
            lenToSegment = segment * spacing;
            global y1;
            global y2;
            if mod(x, spacing) == 0
                % new segment, generate new normals
                y1 = y2;
                y2 = normrnd(mean, varience);
            end
            % Join scalar values with a smoothstep
            y = smoothstep(x, lenToSegment, y1, lenToSegment + spacing, y2);
        end

        function y = smoothstep(x, x1, y1, x2, y2)
            x = (x - x1) / (x2 - x1); 
            % Clamp x between (0,1)
            if x < 0
                x = 0;
            elseif x > 1
                x = 1;
            end
            % Smoothstep
            y = x^3*(x*(x*6-15)+10)*(y2-y1)+y1;
        end

    end
end
