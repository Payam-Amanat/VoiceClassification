% data augmentation
% استفاده از تابع

%for each one that we have already created , we want to augemnt about 20
%from each , first we need to input the address of each and put all of them
%in a folder , then we can seperate them , or each time we have to change
%the name of output folder name to be saved with a new name based on our
%voice sound.Indeed , I did it based on the fisrt description...

voicess = ['bale' , 'na' , 'salam' , 'khodahafez' , 'lotfan' , 'tashakor' , 'bebakhshid' , 'komak' , 'tavaghof' ...
    'boro' , 'chap' , 'rast' , 'bala' , 'paiin' , 'shoro'  , 'payan' ,'baz' , 'baste' , 'roshan' , 'khamosh']

inputFilePath = 'Payam-khamosh.wav';
numAugmentations = 20;
outputDirectory = 'augmented_audio_Payam_all';

augmentedFiles = augmentAudio(inputFilePath, numAugmentations, outputDirectory);

disp('Augmented files created:');
disp(augmentedFiles);
outputDir = outputDirectory;
function augmentedAudioFiles = augmentAudio(filePath, numAugmentations, outputDir)
    % خواندن فایل صوتی اصلی
    [audioData, fs] = audioread(filePath);
    
    % ایجاد دایرکتوری خروجی در صورت عدم وجود
    if ~exist(outputDir, 'dir')
        mkdir(outputDir);
    end
    
    % لیست از توابع افزایش داده‌ها
    augmentationFunctions = {@changeSpeed, @addNoise, @shiftTime};
    
    augmentedAudioFiles = cell(numAugmentations, 1);
    
    for i = 1:numAugmentations
        % انتخاب تصادفی یک تابع افزایش داده‌ها
        funcIndex = mod(i,3)+1;
        augmentedAudio = augmentationFunctions{funcIndex}(audioData, fs);
        
        % ذخیره فایل صوتی جدید
        [~, name, ext] = fileparts(filePath);
        newFileName = fullfile(outputDir, [name, '_augmented_', num2str(i), ext]);
        audiowrite(newFileName, augmentedAudio, fs);
        augmentedAudioFiles{i} = newFileName;
    end
end

% توابع افزایش داده‌ها

function augmentedAudio = changeSpeed(audioData, fs)
    % تغییر سرعت پخش (با ضریب بین 0.8 تا 1.2)
    speedFactor = 0.8 + (1.2-0.8).*rand(1,1);
    augmentedAudio = resample(audioData, round(fs*speedFactor), fs);
end


function augmentedAudio = addNoise(audioData, fs)
    % افزودن نویز سفید با سطح بین 0.001 تا 0.005
    noiseLevel = 0.001 + (0.005-0.001).*rand(1,1);
    noise = noiseLevel * randn(size(audioData));
    augmentedAudio = audioData + noise;
end

function augmentedAudio = shiftTime(audioData, fs)
    % جابجایی زمانی (با حداکثر جابجایی 0.1 ثانیه)
    shiftTime = -0.1 + (0.1-(-0.1)).*rand(1,1);
    shiftSamples = round(shiftTime * fs);
    augmentedAudio = circshift(audioData, shiftSamples);
end