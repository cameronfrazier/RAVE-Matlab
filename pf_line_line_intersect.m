function [point, errorMsg] = pf_line_line_intersect(lines)
% calculate intersection point of two 2d lines specified with 2 points each
% (X1, Y1; X2, Y2; X3, Y3; X4, Y4), while 1&2 and 3&4 specify a line.
% Gives back NaN or Inf/-Inf if lines are parallel (= when denominator = 0)
% see http://en.wikipedia.org/wiki/Line-line_intersection

    errorMsg = '';
    point = [];

    % Input Check
    if size(lines,1) ~= 4 || size(lines,2) ~= 2, error('Input lines have to be specified with 2 points'), end
    
    [e1,m1] = unit(lines(2,:)-lines(1,:));
    p1 = lines(1,:);
    e2 = unit(lines(4,:)-lines(3,:));
    p2 = lines(3,:);
    
    
    lhs = e1(1)*e2(2) - e1(2)*e2(1); %cross([v1 0],[v2 0]);
    if lhs == 0 % Parallel lines
        point = [];
    else
        rhs = (p2(1)-p1(1))*e2(2) - (p2(2)-p1(2))*e2(1); %cross([p2-p1, 0],[v2 0]);
        a = sum(rhs.^2)^0.5/sum(lhs.^2)^0.5;

        if a < m1
%             lines
%             disp([2.1 a; lhs rhs; e1]);
            point = p1 + e1 * a;
                
        %else
            %disp([2.2 lhs rhs a]);        
        end
    end
end