function E = basics_dotrial(P, E)

thisCond = P.preallocBlocks{E.iBlock}{E.iTrial};
thisJitter = rand()*P.jitterTime;

WaitSecs(thisJitter);
disp(thisCond); strtTime=GetSecs();

waitForResp = true;
while waitForResp

    [keyIsDown, respTime, keyCode] = KbCheck;
    
    if keyCode(P.leftKey)

        waitForResp=false;
        resp = 'left';

    elseif keyCode(P.rightKey)

        waitForResp=false;
        resp = 'right';

    end

end

RT = respTime-strtTime;

trialSummary = struct('resp', resp, 'RT', RT, 'exp_cond', thisCond);
if ~isfield(E, 'log')
    E.log = trialSummary;
else
    E.log(end+1) = trialSummary;
end


end