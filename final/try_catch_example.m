
try
    
    WaitSecs(5)
    operation1 = 1+1    
    error('MONTOYA')
      
catch ME
    
    sca
    ListenChar(0)
    
    rethrow(ME)
    
    disp('hello')
    
end

    
    

