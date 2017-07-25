function [ dl ] = getGlobalCoordsFix( dl )

try
    numFrames = size(dl,2);
    moves = 0;
    for i = 1:numFrames
        %dl(i).ElapsedTime = dl(i).ElapsedTime{1};
        if dl(i).CameraStepCols ~= 0
            moves = 1;
        end
        
        if dl(i).CameraStepRows ~=0
            moves = 1;
        end
        if moves
            dl(i).GblCentroidColNew = dl(i).LclCentroidCol + dl(i - 2).TotalOffsetCols;
            dl(i).GblCentroidRowNew = dl(i).LclCentroidRow + dl(i - 2).TotalOffsetRows;
        else
            dl(i).GblCentroidColNew = dl(i).LclCentroidCol + dl(i).TotalOffsetCols;
            dl(i).GblCentroidRowNew = dl(i).LclCentroidRow + dl(i).TotalOffsetRows;
        end
    end
catch err
    rethrow(err);
end

end

