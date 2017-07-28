function patchContourAndSkel( env )
    
    addAllCodePaths();
    %globalEnv = setGlobalEnv();
    env = getEnv_extractContourAndSkelPatch(env);
    
    processName = 'PatchContourAndSkel';
    [ studyInstancePath, f, g, theTimeStamp] = initializeProcess( processName, env);

    %% Output Destination
    
 %%   outputCsvFile = sprintf('%s%s_%s.csv',studyInstancePath,env.OutputCsvFileName, theTimeStamp);
 outputCsvFile = sprintf('%s%s.csv',studyInstancePath,env.OutputCsvFileName);
    fprintf(g, '\n\nCSV OutputFile: %s\n', outputCsvFile); 
    
   %% outputMatFile = sprintf('%s%s_%s.mat',studyInstancePath,env.OutputMatFileName, theTimeStamp);
   outputMatFile = sprintf('%s%s.mat',studyInstancePath,env.OutputMatFileName);
    fprintf(g, 'Matlab Variable Output File: %s\n', outputMatFile); 

       
   %% Initialize Loop           
    endFrame = env.EndFrame;

    % Load the Matlab structure array variable from disk 
    inputMatFile = sprintf('%s%s.mat', studyInstancePath, env.InputMatFileName');
    S = load(inputMatFile);
    dl = S.dl;
       
    iDatarow = 0;
    iFrame = 0;
    startFrame = env.StartFrame;

    fprintf(g, '\n\nStart Frame: %s \n', num2str(startFrame));
    fprintf(g, 'End Frame: %s \n', num2str(endFrame));  
    %% Execute loop
    errorFrames = '';
    tic
    while iFrame < endFrame 

        iFrame = iFrame+1   
        
        %Start collecting data after the start frame is reached
        if iFrame >= startFrame                    
          iDatarow = iDatarow +1;
          
          if isempty(dl(iDatarow).NumRows)
              dl(iDatarow).SegStatus = 'Bad';
          else
              dl(iDatarow).SegStatus = 'Good';
          end
          toc
        end
    end  
    
    disp('FINISHED')
   
    %% Save data to disk
   
    %Save the structure array to disk as a Matlab variable
    save(outputMatFile,'dl', '-v7.3');
    
    %Save feature data to a csv file 
    
    dl = rmfield(dl,'Sktp');
    dl = rmfield(dl,'Contour');
    T = struct2table(dl);
    writetable(T, outputCsvFile);
  
    timeSpent = toc
    fprintf(g, 'Execution Time: %s \n', timeSpent);
    fprintf(g, '\nError Frames: \n\n %s', errorFrames);
    fclose(f);
    fclose(g);
    clear f;
    clear g;
    
end
