function dl = extractAllFeatures( env )
%UNTITLED11 Summary of this function goes here
%   Detailed explanation goes here
    
       
    %Add code paths for all subdirectories
    addAllCodePaths();
    %globalEnv = setGlobalEnv();
    
    %Get the configuration parameters for this process
    env = getEnv_extractAllFeatures(env);
    
    %Initialize the logging
    processName = 'ExtractAllFeatures';
    [ studyInstancePath, f, g, ~] = initializeProcess( processName, env);
   
       %% Set up data source 
   
    videoInputFile = sprintf('%s\\%s', env.VideoInputDir, env.VideoInputName );

    %Get number of frames from a VideoReader object
    obj = VideoReader(videoInputFile);
    numFrames = obj.NumberOfFrames;
    clear obj;

    %Get most other info from a VideoFileReader object
    videoFReader = vision.VideoFileReader(videoInputFile);
    
    %% Load crop information into memory
    
    %Load the crop frame size and crop location for each frame.
    %If cropping is not used, set the size to the size of the entire image,
    %and set all the crop locations to (1,1).
    if env.Cropping == 1
        [cropLoc, ~]= loadCropLocations();
    else
        cropLoc = ones(numFrames,2);
    end
    
    if env.ShotChanges == 1 
        [cameraSteps, resolution, stepSize, epoch] = loadCameraStepsEpoch( env ); %reads from file
    else
        cameraSteps = zeros(numFrames,2);
        resolution = 1;
        stepSize = 0;
        % Load epoch information into memory
        epoch = transpose(0:0.1:numFrames);
    end
    %Report the pixels Per Step = mm/step * pixels/mm 
    pixelsPerStep = stepSize * resolution;
    
    % Load the Matlab structure array variable from disk 
    if isempty(env.InputMatFileName) 
        [fileName,pathName,~] = uigetfile;
        inputMatFile = sprintf('%s%s', pathName, fileName);
    else
        inputMatFile = sprintf('%s%s', studyInstancePath, env.InputMatFileName);
    end
    S = load(inputMatFile);
    dl = S.dl;
    
    %Set up an output file
    outputCsvFile = sprintf('%s%s.csv', studyInstancePath, env.OutputCsvFileName);
    outputMatFile = sprintf('%s%s.mat', studyInstancePath, env.OutputMatFileName);
     
    %Set the start frame and end frame
    startDatarow = env.StartDatarow;
    if length(dl) < env.EndDatarow;
        endDatarow = length(dl);
    else
        endDatarow = env.EndDatarow;
    end
    fprintf(g, 'Start Frame: %s \n', num2str(startDatarow));
    fprintf(g, 'End Frame: %s \n', num2str(endDatarow));
    
    %Load the number of image rows and columns in each row
    numRows = dl(startDatarow).NumRows;
    numCols = dl(startDatarow).NumCols;
    fprintf(g, 'Number of Image Rows: %s \n', num2str(numRows));
    fprintf(g, 'Number of Image Cols: %s \n', num2str(numCols));
    
            
    %% Process each row
    tic
    errorRows = '';
    i = startDatarow;
    while ~isDone(videoFReader) && i < endDatarow 
       
       videoFrame = step(videoFReader);
        try
            %Display the datarow
            if i == 1 || mod(i,env.DisplayRate) == 0
                disp(i);
                toc
            end
            [dl, ~] = loadCameraInfo(resolution, ...
                                                    cameraSteps(i,:),...
                                                    pixelsPerStep,...
                                                    cropLoc(i,:), ...
                                                    env,dl,i );
                
                %Grab the current frame.  The current format conists of 
                %RGB with a GS image in each channel
                gsImage =  im2uint8(videoFrame(:,:,1));

                %Segment the image and get a flag indicating whether a loop
                [bwImage, ~] =  cornerThresh(gsImage, ...
                                                    env.EstArea, ...
                                                    env.StructElementSize );

                %Extract the contour from the bw image.  Keep in local 
                %coordinates  
                [perimRow, perimCol] = find( bwperim( bwImage ) );
                contour = [perimRow, perimCol];
                
           %get the BW Image - contour is saved in local coordinates
            bwImage = contour2BwImage(contour, [numRows, numCols]);

            %Load the shape and size features dervied from the binary image
            [dl, ~] = loadBwShapeAndSize( bwImage, dl, i);
            
            %Load the features determined by analysis of the skewer
            %representation of the skeleton
            dl = loadSktpSkewerStats(dl, i );

            %Load the width profile of each end
            %dl = loadWidthProfiles(distTransform, env.WidthProfileRange, dl, i);

            %Load bending stats
            dl = loadBendingStats(env.BendingSampleSize,dl, i);

            %Load mean sktp movement
            if i == 1;
                dl(i).SktpMovement = 0;
            else
                dl(i).SktpMovement = getSktpMovement(dl(i).Sktp, dl(i-1).Sktp);
            end
            
            %Get direction 
            result = getDirection(env.RowsForAverage, env.DirectionSktpSampleSize,dl,i);
            dl(i).DirectionCode = result;
            
            %Load trajectory info
            dl = loadTrajectoryInfo(dl, i);
            
            i=i+1;
        catch err
             newError = sprintf('\n Frame %s: %s', num2str(i),  getReport(err,'extended'));
             errorRows = strcat(errorRows, newError );    
        end
    end
    
    %Save the structure array to disk as a Matlab variable
    save(outputMatFile,'dl', '-v7.3');
    
    %Save feature data to a csv file 
    dl = rmfield(dl,'Sktp');
    dl = rmfield(dl,'Contour');
    dl = dl(startDatarow:endDatarow);
    T = struct2table(dl); 
    writetable(T, outputCsvFile  );
    
    timeSpent = toc;
    fprintf(g, 'Execution Time: %s \n', timeSpent);
    fprintf(g, '\n Error Frames: \n\n %s', errorRows);
    fclose(f);
    fclose(g);
    clear f;
    clear g;
    
   
    
    
end
    

