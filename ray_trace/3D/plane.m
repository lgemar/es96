classdef plane
    properties
        normal % Normal
        point % Point on plane
    end
    methods
        function P = plane(normal, point)
            P.normal = normal;
            P.point = point;
        end
    end
end