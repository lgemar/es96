classdef PulsePoint
    properties
        p % position
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
            h = plot3(x, y, z, 'r');
        end
        
        function [P] = vertical_plane_constraint(P, x_pos, n1, n2)
            % n1, n2 are indices of refraction, going into and coming out
            % of the surface, respectively
            d = x_pos - P.p(1); 
            P.pos_prev = P.p; 
            P.p = P.p + (d*P.dir)/(P.dir(1)); 
           
            P.dir = refract_ray(P.pos_prev, P.p, [1 0 0]', n1, n2); 
        end
        
        function P = lens_constraint(P, ctr, r, n1, n2) 
             % point of intersection on lens
             dtoarc = @(d) sum((P.p + d*P.dir - ctr).^2) - r^2;
             d = fzero(dtoarc, 0);
             % Update Pulse variables for refraction
             P.pos_prev = P.p; 
             P.p = P.p + d*P.dir; 
             % find new direction
             P.dir = refract_ray(P.pos_prev, P.p, ctr - P.p, n1, n2);
        end
        
        function [P, P2] = spherical_mirror_constraint(P, ctr, R, n1, n2)
            % Initialize bleed through pulse
            reflectivity = 0.99975; 
            
            % Determine if pulse is inside the sphere
            
            % Find the intersection point
            dtoarc = @(d) sum((P.p + d*P.dir - ctr).^2) - R^2;
            d = fzero(dtoarc, 0); 
            % Update Pulse variables bleed through
            P.pos_prev = P.p;
            P.p = P.p + d*P.dir;
            % **CHECK - is this correct for refraction?            
            P.dir = refract_ray(P.pos_prev, P.p, ctr - P.p, n1, n2); 

            % Update Pulse variables for reflection
            new_dir = reflect_ray(P.pos_prev, P.p, ctr - P.p);
            P2 = PulsePoint(P.p, new_dir);
            P2.pow = (reflectivity) * P.pow;
            P.pow = (1 - reflectivity) * P.pow;
    end
    end
end