% تنظیمات اولیه شبکه
inputLayerSize = inputSize;
numClasses = numel(categories(labels));

% طراحی معماری شبکه
layers = [
    sequenceInputLayer(inputLayerSize)
    fullyConnectedLayer(512)
    reluLayer
    fullyConnectedLayer(256)
    reluLayer
    fullyConnectedLayer(128)
    reluLayer
    fullyConnectedLayer(numClasses)
    softmaxLayer
    classificationLayer];

% تنظیمات آموزش
options = trainingOptions('adam', ...
    'MaxEpochs', 50, ...
    'MiniBatchSize', 32, ...
    'InitialLearnRate', 0,001, ...
    'Plots', 'training-progress');

% آموزش شبکه
net = trainNetwork(data, labels, layers, options);