function tests = testLogger()
% Unit Test - Implements a unit test for a widget or component

% Copyright 2018 The MathWorks,Inc.
%
% 
% 
% 
% 
% 
% ---------------------------------------------------------------------

% Indicate to test the local functions in this file
tests = functiontests(localfunctions);

end %function


%% Test Basic Construction
function testDefaultConstructor(testCase)

fcn = @()uiw.tool.Logger();

testCase.verifyWarningFree(fcn)

end %function


%% Test Construction with Inputs
function testConstructionArguments(testCase)

[~,logName] = fileparts( tempname );
fcn = @()uiw.tool.Logger(logName);

testCase.verifyWarningFree(fcn)


[~,logName] = fileparts( tempname );
fcn = @()uiw.tool.Logger( string(logName) );

testCase.verifyWarningFree(fcn)


[~,logName] = fileparts( tempname );
fcn = @()uiw.tool.Logger(logName,...
    'BufferSize',50,...
    'FileLevel','debug',...
    'DisplayLevel','warning',...
    'LogFile','',...
    'Callback',@(h,e)disp(e));

testCase.verifyWarningFree(fcn)

end %function


%% Test default values
function testDefaultValues(testCase)

log = uiw.tool.Logger();

testCase.verifyEqual( double(log.BufferSize), 100 )
testCase.verifyEqual( log.FileLevel, uiw.enum.LogLevel.USER )
testCase.verifyEqual( log.DisplayLevel, uiw.enum.LogLevel.USER )
testCase.verifyNotEmpty( log.LogFile )
testCase.verifyEmpty( log.Callback )

end %function


%% Test bad inputs
function testBadInputs(testCase)

fcn = @()uiw.tool.Logger(5);
testCase.verifyError(fcn,'MATLAB:invalidType');

end %function


%% Test good values
function testGoodValues(testCase)

[~,logName] = fileparts( tempname );
log = uiw.tool.Logger(logName);

fcn = @()set(log,'BufferSize',10);
verifyWarningFree(testCase,fcn)

fcn = @()set(log,'BufferSize',1000);
verifyWarningFree(testCase,fcn)

fcn = @()set(log,'Callback',@(h,e)disp(e));
verifyWarningFree(testCase,fcn)

fcn = @()set(log,'DisplayLevel','warning');
verifyWarningFree(testCase,fcn)

fcn = @()set(log,'FileLevel','error');
verifyWarningFree(testCase,fcn)

end %function


%% Test bad values
function testBadValues(testCase)

[~,logName] = fileparts( tempname );
log = uiw.tool.Logger(logName);

fcn = @()set(log,'BufferSize',-10);
verifyError(testCase,fcn,'MATLAB:validators:mustBePositive')

if verLessThan('matlab','9.8')
    
    fcn = @()set(log,'BufferSize',[1 2 3]);
    verifyError(testCase,fcn,'MATLAB:type:InvalidInputSize')
    
    fcn = @()set(log,'Callback',[1 2 3]);
    verifyError(testCase,fcn,'MATLAB:UnableToConvert')
    
    fcn = @()set(log,'DisplayLevel','BadValue');
    verifyError(testCase,fcn,'MATLAB:UnableToConvert')
    
    fcn = @()set(log,'FileLevel','BadValue');
    verifyError(testCase,fcn,'MATLAB:UnableToConvert')
    
else
    
    
    fcn = @()set(log,'BufferSize',[1 2 3]);
    verifyError(testCase,fcn,'MATLAB:validation:IncompatibleSize')
    
    fcn = @()set(log,'Callback',[1 2 3]);
    verifyError(testCase,fcn,'MATLAB:validation:UnableToConvert')
    
    fcn = @()set(log,'DisplayLevel','BadValue');
    verifyError(testCase,fcn,'MATLAB:validation:UnableToConvert')
    
    fcn = @()set(log,'FileLevel','BadValue');
    verifyError(testCase,fcn,'MATLAB:validation:UnableToConvert')
    
end

end %function


%% Test log file
function testLogFile(testCase)

[~,logName] = fileparts( tempname );
log = uiw.tool.Logger(logName);

logFile = log.LogFile;
testCase.verifyEqual( exist(logFile,'file'), 2 )

fcn = @()log.write('error','My Error Message');
testCase.verifyWarningFree(fcn)

end %function


%% Test instantiation and deletion
function testInstantiationDeletion(testCase)

log1 = uiw.tool.Logger('TestLogger');
log1.delete();

log2 = uiw.tool.Logger('SecondLogger');

log3 = uiw.tool.Logger('ThirdLogger');

log2a = uiw.tool.Logger('SecondLogger');

log3.delete();


testCase.verifyFalse( isvalid(log1) );
testCase.verifyTrue( isvalid(log2 ));
testCase.verifyFalse( isvalid(log3) );
testCase.verifySameHandle( log2, log2a );

end %function


%% Test changing log file
function testChangeLogFile(testCase)

[~,logName] = fileparts( tempname );
log = uiw.tool.Logger(logName);

logFile = log.LogFile;
testCase.verifyEqual( exist(logFile,'file'), 2 )

newLogFile = tempname;
fcn = @()set(log,'LogFile',newLogFile);
verifyWarningFree(testCase,fcn)

testCase.verifyEqual( exist(newLogFile,'file'), 2 )

fcn = @()log.write('error','My Error Message');
testCase.verifyWarningFree(fcn)

end %function