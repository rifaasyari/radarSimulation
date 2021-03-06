classdef SimulateModel <handle
    properties
        % class
        diskMode
        parameter
        % matrix
        current
        position
        isConduct
        rMesh
        pMesh
        tMesh
        
        % number
        % string 
        fileName
        
    end
    methods
        % initialization of simulation model
        function obj = SimulateModel( exampleName )
            disp('initialize simulation model')
            obj.parameter = SimulatePar();
            obj.fileName = exampleName;
            obj.diskMode = DiskModel(exampleName, obj.parameter.exampleWidth);
            widthLength = obj.diskMode.edgeWidthSize;
            heightLength = obj.diskMode.edgeHeightSize;
            currentHeight = floor(heightLength/obj.parameter.lineUnitWidth);
            currentWidth = floor(widthLength/obj.parameter.lineUnitLength);
            obj.current = zeros(currentHeight, currentWidth);
            obj.isConduct = zeros(currentHeight, currentWidth);
            obj.position = zeros(currentHeight, currentWidth, 3);
            
            pos1Array = ((1:currentWidth) - 0.5) * obj.parameter.lineUnitLength ...
                - widthLength/2;
            pos2Array = (0.5 - (1:currentHeight)) * obj.parameter.lineUnitWidth ...
                + heightLength/2;
            [pos1Matrix, pos2Matrix] = meshgrid(pos1Array, pos2Array);
            obj.position(:,:,1) = pos1Matrix;
            obj.position(:,:,2) = pos2Matrix;
            obj.isConduct = obj.diskMode.checkConductMat(pos1Array, pos2Array);
            obj.current = obj.calculateCurrentMat(double(pos1Matrix)).*double(obj.isConduct);
            disp('Done !')
        end
        function renewImage(obj, newImage)
            obj.parameter = SimulatePar();
            obj.diskMode.renewDisk(newImage);
            widthLength = obj.diskMode.edgeWidthSize;
            heightLength = obj.diskMode.edgeHeightSize;
            currentHeight = floor(heightLength/obj.parameter.lineUnitWidth);
            currentWidth = floor(widthLength/obj.parameter.lineUnitLength);
            obj.current = zeros(currentHeight, currentWidth);
            obj.isConduct = zeros(currentHeight, currentWidth);
            obj.position = zeros(currentHeight, currentWidth, 3);
            
            pos1Array = ((1:currentWidth) - 0.5) * obj.parameter.lineUnitLength ...
                - widthLength/2;
            pos2Array = (0.5 - (1:currentHeight)) * obj.parameter.lineUnitWidth ...
                + heightLength/2;
            [pos1Matrix, pos2Matrix] = meshgrid(pos1Array, pos2Array);
            obj.position(:,:,1) = pos1Matrix;
            obj.position(:,:,2) = pos2Matrix;
            obj.isConduct = obj.diskMode.checkConductMat(pos1Array, pos2Array);
            obj.current = obj.calculateCurrentMat(double(pos1Matrix)).*double(obj.isConduct);
        end
        
        % calculate the surface current
        function value = calculateCurrent(obj, xPosition)
            incidentAngle = obj.parameter.incidentAngle;
            B0 = obj.parameter.B0;
            k = obj.parameter.k;
            miu0 = 4 * pi * 10^(-7);
            lineUnitWidth = obj.parameter.lineUnitWidth;
            Bv = exp(1j * xPosition * sin(incidentAngle)*k)* B0;
            Bvt = Bv * cos(incidentAngle);
            Hvt = Bvt/miu0;
            value = Hvt * lineUnitWidth;
        end
        
        % calculate the surface current matrix form
        function value = calculateCurrentMat(obj, xPosition)
            incidentAngle = obj.parameter.incidentAngle;
            B0 = obj.parameter.B0;
            k = obj.parameter.k;
            miu0 = 4 * pi * 10^(-7);
            lineUnitWidth = obj.parameter.lineUnitWidth;
            Bv = exp(1j .* xPosition .* sin(incidentAngle).*k).* B0;
            Bvt = Bv .* cos(incidentAngle);
            Hvt = Bvt./miu0;
            value = Hvt .* lineUnitWidth;
        end
        
        % start simulation
        function startSimulation(obj)
            k = obj.parameter.k;
            r = obj.parameter.r;
            lineUnitLength = obj.parameter.lineUnitLength;
            currentMatrix = obj.current;
            pos = obj.position;
            
            thetaStep = obj.parameter.thetaStep;
            phiStep = obj.parameter.thetaStep;
            thetaArray = 0:thetaStep:pi/2;
            phiArray  = -pi:phiStep:pi;
            [thetaMesh ,phiMesh] = meshgrid(thetaArray, phiArray);
            
            [height, width] = size(thetaMesh);
            rhoMesh = zeros(height, width);
            disp(height);
            parfor i  = 1:height
                disp(i);
                for j = 1:width
                    theta = thetaMesh(i,j);
                    phi = phiMesh(i,j);
                    x0 = r * cos(theta)*cos(phi);
                    y0 = r * cos(theta)*sin(phi);
                    z0 = r * sin(theta);
                    [Er, ETheta] = calculateElectricIntensity(...
                        [x0,y0,z0],...
                        currentMatrix, ...
                        k,  ...
                        pos, ...
                        lineUnitLength);
                    r1 = abs(Er + ETheta).^2;
                    % calculate power
                    r1 = sum(r1(:));
                    rhoMesh(i,j) = r1;
                end
            end
            obj.pMesh = phiMesh;
            obj.rMesh = rhoMesh;
            obj.tMesh = thetaMesh;

            [X, Y, Z] = sph2cart(phiMesh, thetaMesh, rhoMesh);
            figure;
            mesh(X,Y,Z);
            axis equal
            save newResult phiMesh thetaMesh rhoMesh currentMatrix
        end
        
        
        
        % simulate one point without parallel method
        function rPower = simulateOnePoint(obj)
            k = obj.parameter.k;
            r = obj.parameter.r;
            lineUnitLength = obj.parameter.lineUnitLength;
            currentMatrix = obj.current;
            pos = obj.position;
            testTheta = obj.parameter.testTheta;
            testPhi = obj.parameter.testPhi;
            
            theta = testTheta;
            phi = testPhi;
            x0 = r * cos(theta)*cos(phi);
            y0 = r * cos(theta)*sin(phi);
            z0 = r * sin(theta);
            [Er, ETheta] = calculateElectricIntensity(...
                [x0,y0,z0],...
                currentMatrix, ...
                k,  ...
                pos, ...
                lineUnitLength);
            r1 = abs(Er + ETheta).^2;
            % calculate power
            rPower = sum(r1(:));
        end
    end
    methods(Static)
    end
end