% quick convenience function for returning a string that displays with rgb
% color through the latex interpreter.
%
% ch = rgbchar(str,rgb)
function ch = rgbchar(str,rgb)

ch = sprintf('{\\color[rgb]{%f %f %f}%s}',rgb(1),rgb(2),rgb(3),str);
