classdef PulsePoint
    properties
        p
        pos_prev
        dir
        pow
    end
    methods
        function P = PulsePoint(position, velocity)
            P.pos_prev = position; 
            P.p = position;
            P.dir = velocity / sum(velocity.^2); 
            P.pow = 1; 
        end
        
        function P = draw(P)
            x = [P.pos_prev(1) P.p(1)];
            y = [P.pos_prev(2) P.p(2)];
            z = [P.pos_prev(3) P.p(3)];
            %h = plot3(x, y, z, 'r', 'LineWidth', P.pow * 20);
            h = plot3(x, y, z, 'r');
        end
        
        function [P, P2] = vertical_plane_constraint(P, x_pos)
            P2 = []; 
            d = x_pos - P.p(1); 
            P.pos_prev = P.p; 
            P.p = P.p + d*P.dir; 
            new_dir = [-P.dir(1), P.dir(2), P.dir(3)]'; 
            P2 = PulsePoint(P.p, new_dir); 
        end
        
        function P = lens_constraint(P, ctr, r, n1, n2, dt) 
             dtoarc = @(d) sum((P.p + d*P.dir - ctr).^2) - r^2;
             d = fzero(dtoarc, 0);
             % Update Pulse variables for refraction
             P.pos_prev = P.p; 
             P.p = P.p + d*P.dir; 
             P.dir = refract_ray(P.pos_prev, P.p, ctr - P.p, n1, n2);
        end
        
        function [P, P2] = spherical_mirror_constraint(P, ctr, r, dt)
            % Initialize bleed through pulse
            P2 = []; 
            reflectivity = 0.9; 
            
            % Determine if pulse is inside the sphere
            inside_sphere = sqrt( sum( (P.p - ctr).^2 ) ) < r;  
            
            % Find the intesection point
            if( inside_sphere ) 
                dtoarc = @(d) sum((P.p + d*P.dir - ctr).^2) - r^2;
                d = fzero(dtoarc, 0); 
                % Update Pulse variables bleed through
                P.pos_prev = P.p; 
                P.p = P.p + d*P.dir; 
                P.pow = (1 - reflectivity) * P.pow; 
                
                % Update Pulse variables for reflection
                new_dir = reflect_ray(P.pos_prev, P.p, ctr - P.p);
                P2 = PulsePoint(P.p, new_dir); 
                P2.pow = (reflectivity) * P.pow;   
            end
        end
    end
end