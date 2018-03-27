lineNum = 75;
lineUnitLength = 0.0003;
B0 = 0.01;
k = 418.879;
incidentAngle = pi/9;
length = lineNum * lineUnitLength;

figure;


sparkLength = 0.003;
dutyCycle = 1;

disk_conductor = generateDisk( ...
    'conductor', ...
    lineUnitLength, ...
    length, ...
    sparkLength, ...
    dutyCycle);
subplot(5,1,1);
plot(disk_conductor);

sparkLength = 0.0009;
dutyCycle = 0.1;
disk_regular_1 = generateDisk( ...
    'regularConductSpark', ...
    lineUnitLength, ...
    length, ...
    sparkLength, ...
    dutyCycle);
subplot(5,1,2);
plot(disk_regular_1);


sparkLength = 0.0009;
dutyCycle = 0.3;
disk_regular_2 = generateDisk( ...
    'regularConductSpark', ...
    lineUnitLength, ...
    length, ...
    sparkLength, ...
    dutyCycle);
subplot(5,1,3);
plot(disk_regular_2);


sparkLength = 0.003;
dutyCycle = 0.3;
disk_regular_3 = generateDisk( ...
    'regularConductSpark', ...
    lineUnitLength, ...
    length, ...
    sparkLength, ...
    dutyCycle);
subplot(5,1,4);
plot(disk_regular_3);


sparkLength = 0.0009;
dutyCycle = 0.2;
disk_unregular = generateDisk( ...
    'randomConductSpark', ...
    lineUnitLength, ...
    length, ...
    sparkLength, ...
    dutyCycle);
subplot(5,1,5);
plot(disk_unregular);