function [itdidx, ildidx, St, bRunning] = GetNextStimulusIndices(St, Rc)
    
    bRunning = true;
    
    if ~isfield(Rc, 'Randomization')
        Rc.Randomization = 'running';
    end
    
    switch Rc.Randomization
        case 'running'
            switch St.PresentationType
                case 'L/R/B'
                    ildidx     = randi(length(St.ILD),1);
                    itdidx    = randi(length(St.ITD)+2,1);
                case 'simple binaural'
                    ildidx     = randi(length(St.ILD),1);
                    itdidx    = randi(length(St.ITD),1);
            end
        case 'fixed'
            if isfield(St, 'temp') && isfield(St.temp, 'indexlist') && isfield(St.temp, 'indexpointer')
                St.temp.indexpointer = St.temp.indexpointer + 1;
                if St.temp.indexpointer+1 > size(St.temp.indexlist, 1)
                    bRunning = false;
                end
                itdidx = St.temp.indexlist(St.temp.indexpointer, 1);
                ildidx = St.temp.indexlist(St.temp.indexpointer, 2);
            else
                [T, L] = ndgrid(1:length(St.ITD), 1:length(St.ILD));
                T = T(:);
                L = L(:);
                St.temp.indexlist = [];
                for r = 1:Rc.MaxRepsPerCond
                    order = randperm(length(T));
                    St.temp.indexlist = [St.temp.indexlist; [T(order), L(order)]];
                end
                itdidx = [];
                ildidx = [];
                St.temp.indexpointer = 0;
            end
    end
