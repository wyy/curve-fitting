function myfit(varargin)
%% myfit
% default arguments
index = 5001:9000;
path = '.';
dir_pattern_1 = 'off=*';
dir_pattern_2 = 'Q=*';
file_pattern = 'on=* off=*.xls';
filter_on = 0;
% optional arguments
for i = 1:length(varargin)
    option = varargin{i};
    if regexpi(option, 'Q=*') == 1
        dir_pattern_2 = [option, '*'];
    elseif regexpi(option, 'on=*') == 1
        file_pattern = regexprep(file_pattern, 'on=\*', option);
    elseif regexpi(option, 'off=*') == 1
        file_pattern = regexprep(file_pattern, 'off=\*', option);
        dir_pattern_1 = [option, '*'];
    elseif regexpi(option, 'filter') == 1
        if i < length(varargin) && regexp(varargin{i+1}, '\d+') == 1
            filter_on = str2num(varargin{i+1});
        else
            filter_on = 3;
        end
    elseif ~regexp(option, '\d+') == 1
        type('README.md')
    end
end
% directory and file
fid = fopen('fitresult.txt', 'wt');
fprintf(fid, '\ny =  y0 + A*sin(2*pi*x/T)\n\n');
fprintf(fid, '%10s %10s %10s %10s %36s\n', 'y0', 'A', 'T', 'A/y0', 'file');
fprintf('\ny =  y0 + A*sin(2*pi*x/T)\n\n');
fprintf('%10s %10s %10s %10s %36s\n', 'y0', 'A', 'T', 'A/y0', 'file');
dirs1 = dir(fullfile(path, dir_pattern_1));
for i = 1:length(dirs1)
    if ~dirs1(i).isdir
        continue
    end
    path_1 = fullfile(path, dirs1(i).name);
    dirs2 = dir(fullfile(path_1, dir_pattern_2));
    for j = 1:length(dirs2)
        if ~dirs2(j).isdir
            continue
        end
        path_2 = fullfile(path_1, dirs2(j).name);
        files = dir(fullfile(path_2, file_pattern));
        for k = 1:length(files)
            if files(k).isdir
                continue
            end
            path_3 = fullfile(path_2, files(k).name);
            file = fullfile(dirs1(i).name, dirs2(j).name, files(k).name);
            [y0, A, T, xc] = fitfile(path_3, index, file, filter_on);
            fprintf(fid, '%10g %10g %10g %10g %36s\n', y0, A, T, A/y0, file);
            fprintf('%10g %10g %10g %10g %36s\n', y0, A, T, A/y0, file);
        end
    end
end
fclose(fid);

function [y0, A, T, xc] = fitfile(filename, index, file, filter_on)
%% fitfile
% x, y data
data = xlsread(filename);
x = data(:, 1);
y = data(:, 2);
y = (y - 1) * 250;
% Print Q vs. time to file
[pathstr, name, ext] = fileparts(file);
dir_name = fullfile('fitdata', pathstr);
if ~exist(dir_name, 'dir')
    mkdir(dir_name)
end
fid = fopen(fullfile(dir_name, [name, '.txt']), 'wt');
fprintf(fid, '%11s%11s\n', 'time(s)', 'Q(ml/s)');
fprintf(fid, '%11g%11g\n', [x, y]');
fclose(fid);
% fit x y
x = x(index, 1);
y = y(index, 1);
% filter
if filter_on > 0
    n = filter_on;
    band = zeros(size(x));
    band(2+n:end-n) = 1;
    band(1) = 1;
    ty = fft(y) .* band;
    y = ifft(ty);
    [pathstr, name, ext] = fileparts(file);
    file = fullfile(pathstr, [name, '.filter', ext]);
end
% fit
[fitresult, gof] = createFit(x, y, file);
% fitresult(x) =  a0 + a1*cos(x*w) + b1*sin(x*w)
cv = coeffvalues(fitresult);
a0 = cv(1);
a1 = cv(2);
b1 = cv(3);
w = cv(4);
% y =  y0 + A*sin(2*pi*(x-xc)/T)
y0 = a0;
A = sqrt(a1^2 + b1^2);
T = 2*pi/w;
xc = - asin(a1/A)*T/(2*pi);

function [fitresult, gof] = createFit(xData, yData, file)
%% Fit
% Fit model to data.
[fitresult, gof] = fit( xData, yData, 'fourier1' );
% Plot fit with data.
hf = figure( 'Name', file, 'DefaultAxesFontSize', 13 );
h = plot( fitresult, xData, yData );
legend( h, 'Q vs. t', 'Curve fitting', 'Location', 'NorthEast' );
% Label axes
xlabel( 't(s)' );
ylabel( 'Q(ml/s)' );
grid on
% Print figure to file
[pathstr, name, ext] = fileparts(file);
dir_name = fullfile('fitfigure', pathstr);
if ~exist(dir_name, 'dir')
    mkdir(dir_name)
end
print(hf, '-dpng', fullfile(dir_name, [name, '.png']))
close(hf)
