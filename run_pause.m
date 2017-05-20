function [] = run_pause(~, ~)
    persistent state;
    if(isempty(state))
        state = 1;
    end
    if(state)
        state = 0;
        uiwait();
        return;
    else
        state = 1;
        uiresume();
        return;
    end
end