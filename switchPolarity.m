function switchPolarity(sFileName)

load(sFileName);

Avg = -Avg;

if exist('PolaritySwitchedTo','var')
    PolaritySwitchedTo = -PolaritySwitchedTo;
else
    PolaritySwitchedTo = -1;
end

if ~exist('Var','var')
    Var = [];
end

save(sFileName,'Conditions','AvgC','Avg','Var','MicC','Mic','St','Hw','Rc','PolaritySwitchedTo');
fprintf('file %s saved with inverted polarity\n',sFileName);
