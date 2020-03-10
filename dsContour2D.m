function [xcont, ycont] = dsContour2D(x, y, alpha, dtdeg)
% DSCONTOUR2D calculates a 2D direct sampling contour.
%   Inputs:
%   x,y - Sample of data.
%   alpha - Exceedance probability of the contour.
%   dtdeg - Directional step in degrees.

% Initialisation.
dt = dtdeg * pi / 180;
t = (dt : dt : 2 * pi)';
Nx = length(x);
Nt = length(t);
Np = length(alpha);
r = zeros(Nt, Np);
xcont = zeros(Nt, Np);
ycont = zeros(Nt, Np);

% Find radius for each angle.
for i = 1 : length(t)
    if Nx > 1e6
        fprintf('   angle %u/%u\n',i,Nt)
    end
    z = x * cos(t(i)) + y * sin(t(i));
    r(i, :) = quantile(z, 1 - alpha);
end

% Find intersection of lines.
t = [t;dt];
r = [r;r(1,:)];
denominator = sin(t(2:end)).*cos(t(1:end-1)) - sin(t(1:end-1)).*cos(t(2:end));
for j = 1 : Np
    xcont(:,j) = (sin(t(2 : end)) .* r(1 : end - 1, j) - sin(t(1 : end - 1)) .* r(2 : end, j)) ./ denominator;
    ycont(:,j) = (-cos(t(2 : end)) .* r(1 : end - 1, j) + cos(t(1 : end - 1)) .* r(2 : end, j)) ./ denominator;
end
end
