classdef UnitCell < handle
    % UnitCell 
    %   Ref: Introduction to the use the UB matrix, A. T. Savici (2011)
    % https://github.com/mantidproject/documents/blob/master/Design/UBMatriximplementationnotes.pdf
    % https://docs.mantidproject.org/v4.1.0/concepts/Lattice.html
    
    properties
        a = 1
        b = 1
        c = 1
        alpha = 90
        beta = 90
        gamma = 90
    end
    
    properties (Access = private) % cartesian coordinate system vectors.
        ivec = [1 0 0];
        jvec = [0 1 0];
        kvec = [0 0 1];
    end
    
    properties(Dependent)
       V
       CellVol
       a_vec
       b_vec
       c_vec
       astar
       bstar
       cstar
       alphastar
       betastar
       gammastar
       astar_vec
       bstar_vec
       cstar_vec
       Bmat
    end
    
    methods
        function obj = UnitCell(a,b,c,alpha,beta,gamma)
            if nargin ~= 6
                error('Number of input is invalid, 6 parameters are required');    
            end
            obj.a = a;
            obj.b = b;
            obj.c = c;
            obj.alpha = alpha;
            obj.beta = beta;
            obj.gamma = gamma;            
             
        end
        
        function V = get.V(obj) % normalized volume of cell
            V = sqrt(1-cosd(obj.alpha)^2-cosd(obj.beta)^2-cosd(obj.gamma)^2 ...
                + 2*cosd(obj.alpha)*cosd(obj.beta)*cosd(obj.gamma));
        end
        function CellVol = get.CellVol(obj) % unit cell volume
            CellVol = obj.a*obj.b*obj.c*obj.V;
        end
        function a_vec = get.a_vec(obj)
            a_vec = obj.a*obj.ivec;
        end        
        function b_vec = get.b_vec(obj)
            b_vec = obj.b*cosd(obj.gamma)*obj.ivec + obj.b*sind(obj.gamma)*obj.jvec;
        end        
        function c_vec = get.c_vec(obj)
            ci = obj.c*cosd(obj.beta);
            cj = obj.c*(cosd(obj.alpha)-cosd(obj.gamma)*cosd(obj.beta))/sind(obj.gamma);
            ck = obj.c*obj.V/sind(obj.gamma);
            c_vec = ci*obj.ivec + cj*obj.jvec + ck*obj.kvec;
        end
        function astar = get.astar(obj)
            astar = sind(obj.alpha)/obj.V/obj.a;
        end
        function bstar = get.bstar(obj)
            bstar = sind(obj.beta)/obj.V/obj.b;
        end    
        function cstar = get.cstar(obj)
            cstar = sind(obj.gamma)/obj.V/obj.c;
        end
        function astar_vec = get.astar_vec(obj)
            astar_vec = cross(obj.b_vec, obj.c_vec)/obj.CellVol;
        end
        function bstar_vec = get.bstar_vec(obj)
            bstar_vec = cross(obj.c_vec, obj.a_vec)/obj.CellVol;
        end
        function cstar_vec = get.cstar_vec(obj)
            cstar_vec = cross(obj.a_vec, obj.b_vec)/obj.CellVol;
        end
        function alphastar = get.alphastar(obj)
            alphastar = acosd((cosd(obj.beta)*cosd(obj.gamma)-cosd(obj.alpha))/sind(obj.beta)/sind(obj.gamma));
        end
        function betastar = get.betastar(obj)
            betastar = acosd((cosd(obj.gamma)*cosd(obj.alpha)-cosd(obj.beta))/sind(obj.gamma)/sind(obj.alpha));
        end
        function gammastar = get.gammastar(obj)
            gammastar = acosd((cosd(obj.alpha)*cosd(obj.beta)-cosd(obj.gamma))/sind(obj.alpha)/sind(obj.beta));
        end
        function Bmat = get.Bmat(obj)
            Bmat = zeros(3,3);
            Bmat(1,1) = obj.astar;
            Bmat(1,2) = obj.bstar*cosd(obj.gammastar);
            Bmat(1,3) = obj.cstar*cosd(obj.betastar);
            Bmat(2,2) = obj.bstar*sind(obj.gammastar);
            Bmat(2,3) = -obj.cstar*sind(obj.betastar)*cosd(obj.alpha);
            Bmat(3,3) = 1/obj.c;
        end
        
        function out = Qhkl_vec(obj,h,k,l)
            out = h*obj.astar_vec + k*obj.bstar_vec + l*obj.cstar_vec;
        end          
        function out = Qhkl_abs(obj,h,k,l)
            out = norm(obj.Qhkl_vec(h,k,l));
        end
      
    end
    
end

