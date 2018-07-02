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
            if isfield(St, 'indexlist') && isfield(St, 'indexpointer')
                St.indexpointer = St.indexpointer + 1;
                if St.indexpointer+1 > size(St.indexlist, 1)
                    bRunning = false;
                end
                itdidx = St.indexlist(St.indexpointer, 1);
                ildidx = St.indexlist(St.indexpointer, 2);
            else
                [T, L] = ndgrid(1:length(St.ITD), 1:length(St.ILD));
                T = T(:);
                L = L(:);
                for r = 1:Rc.MaxRepsPerCond
                    order = randperm(length(T));
                    St.indexlist = [St.indexlist; [T(order), L(order)]];
                end
            end
    end
