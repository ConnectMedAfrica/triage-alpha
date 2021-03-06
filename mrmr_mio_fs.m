function [ criterion ] = mrmr_mio_fs(trainX,trainY,testX,testY)
    %% Feature Selection
    tenfoldCVP = cvpartition(trainY,'KFold',10);
    feaMIO = mrmr_miq_d(int64(trainX),int64(trainY),300);
    xMIVals = [];  mioErrVals = [];
    for m=1:4:length(feaMIO)
        xMIVals(end+1) = m;
        mioErrVals(end+1) = transpose(crossval(@my_fun_lib,trainX(:,feaMIO(1:m)),trainY,'partition',tenfoldCVP))/tenfoldCVP.TestSize;
    end
    [minVal minIndex] = min(mioErrVals);
    mioFeatures = feaMIO(1:xMIVals(minIndex));
      %% Parameter Selection
%    bestcv = 0;
%     for c = .01:1000
%       for g = .00001:.001:100
%         cmd = ['-v 3 -s 0 -t 2 -c ', num2str(c), ' -g ', num2str(g)];
%         cv = svmtrain(trainY, trainX(:,maxrelFeatures), cmd);
%         if (cv >= bestcv),
%           bestcv = cv; bestc = c; bestg = g;
%         end
%         fprintf('%g %g %g (best c=%g, g=%g, rate=%g)\n', bestc, bestg, bestcv);
%       end
%     end

    bestc = 120;
    bestg = .002;
    
    %% Test Model
    model = svmtrain(trainY, trainX(:,mioFeatures),['-s 0 -t 2 -c ' num2str(bestc) ' -g ' num2str(bestg)]);
    criterion = sum(svmpredict(testY, testX(:,mioFeatures), model) ~= testY);

end
