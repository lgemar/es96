function c = blues(m)
%BLUES Linear blue-tone color map.
%   BLUE(M) returns an M-by-3 matrix containing a "blue" colormap.
%   BLUE, by itself, is the same length as the current colormap.
%
%   For example, to reset the colormap of the current figure:
%
%             colormap(blues)
%
%   See also HSV, GRAY, HOT, COOL, BONE, PINK, FLAG, 
%   COLORMAP, RGBPLOT.

if nargin < 1, m = size(get(gcf,'colormap'),1); end
c = min(1,gray(m)*diag([.75 .75 1.5]));
