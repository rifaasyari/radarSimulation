
% incident wave simulation start angle (degree)
startAngle = 0;

% incident wave simulation end angle (degree)
endAngle = 60;

% simulate step of angle (degree)
angleStep = 1;

% number of line element. the totla length of simulated object is lineNum *
% lineUnitLength
lineNum = 200;

% line element length (meter)
lineUnitLength = 0.001;

% incident electromagnatic intensity, magnatic part (Tesla)
B0 = 1e-9;

% the size of spark (meter)
sparkLength = 0.002;

% the duty cycle of generated disk. Ideally we thought the conduct chip
% (spark) as 1 and the insulator part is 0
dutyCycle = 0.1;

% There are 5 disk mode
% 'conductor', the disk are totally made by conductor, in this situation
%               the parameter dutyCycle will not work. The non-conduct
%               part is made by insulator.
% 'regularConductSpark', the spark will appear regularly. The non-conduct
%               part is made by insulator.
% 'randomConductSpark', the spark will appear randomly. The non-conduct
%               part is made by insulator.
% 'regularSemiConductSpark', the spark will appear regularly. The
%               non-conduct part is made by semiconductor.
% 'randomSemiConductSpark', the spark will appear randomly, The non-conduct
%               part is made by semiconductor.

% You can specify the semi parameter in 'generateDisk.m'
diskMode = 'randomConductSpark';

% Distance (meter)
r = 250;

% wave property
k = 1256.637;


simulateWithParameter(...
    startAngle,...
    endAngle,...
    angleStep,...
    lineNum,...
    lineUnitLength,...
    B0,...
    sparkLength,...
    dutyCycle,...
    diskMode,...
    r, k)