classdef testSingleSessionApp < matlab.unittest.TestCase
    % testSingleSessionApp - Unit Test for uiw.abstract.SingleSessionApp
    %
    % Notes:
    %
    %
    
    % Copyright 2018 The MathWorks, Inc.
    %
    % 
    %   
    % ---------------------------------------------------------------------
    
    %% Properties
  properties
      App testHelper.SingleSessionAppHelper
  end
 
  
  %% Setup and Teardown
    methods (TestClassSetup)
        function setupOnce(testCase)
            testCase.App = testHelper.SingleSessionAppHelper();
        end
    end
    
    methods (TestMethodSetup)
        function setup(testCase)
            testCase.App.markClean();
            testCase.App.onNewSession();
        end
    end
    
    methods (TestClassTeardown)
        function teardownOnce(testCase)
            delete(testCase.App);
        end
    end
    
    
    %% Unit Tests
    methods (Test)
        
        function testSaveSession(testCase)
            
            % Set up a dirty session with a valid file path, to avoid
            % prompting for a filename
            testCase.App.markClean();
            Session = struct('Status','Session With Path');
            sessionPath = [tempname '.mat'];
            save(sessionPath,'Session');
            testCase.App.addSession(Session,sessionPath);
            testCase.App.markDirty();
            
            % Save with no args
            testCase.App.onSaveSession()
            
            % Save with flag arg
            testCase.App.markDirty();
            testCase.App.onSaveSession(false)
            
            % Save with all args
            testCase.App.markDirty();
            testCase.App.onSaveSession(false,Session,sessionPath)
            
        end %function
        
        
        function testOpenSession(testCase)
            
            % Create a saved session
            Session = struct('Status','Session to Load');
            sessionPath = [tempname '.mat'];
            save(sessionPath,'Session');
            
            % Load the session
            testCase.App.onOpenSession(sessionPath)
            
            status = testCase.App.Session.Status;
            testCase.verifyEqual(status,'Session to Load');
            
        end %function
        
        
        function testCloseSession(testCase)
            
            % Don't typically have a close session capability on single
            % session apps, but test this anyway
            
            % First, save the session without prompting
            sessionPath = [tempname '.mat'];
            testCase.App.helperSetSessionPath(sessionPath);
            
            % Mark it dirty again
            testCase.App.markDirty();
            
            % Now, it should get saved. Using an override to avoid the
            % prompt here:
            statusOk = testCase.App.onCloseSession();
            
            testCase.assumeTrue(statusOk)
            testCase.verifyEqual( exist(sessionPath,'file'), 2 )
            
        end %function
        
        
        function testFigureName(testCase)
            
            expName = 'Single Session App Test Helper - untitled';
            
            name = testCase.App.Title;
            testCase.verifySubstring(name,expName);
            
            name = testCase.App.Figure.Name;
            testCase.verifySubstring(name,expName);
            
        end %function
        
        
        function testPreferences(testCase)
            
            defaultPos = [0 0 1 1];
            newPos = [123 123 456 456];
            
            % Set preference with a default
            [~] = testCase.App.getPreference('Position',defaultPos);
            
            % Set preference to a new value
            testCase.App.setPreference('Position',newPos);
            
            % Verify we can get the new preference value back
            pos = testCase.App.getPreference('Position',defaultPos);
            testCase.verifyEqual(pos,newPos);
            
        end %function
        
        
        
        function testFigureDeletion(testCase)
            
            % Verify deleting the app deletes the uifigure
            app = testHelper.SingleSessionAppHelper();
            fig = app.Figure;
            delete(app);
            testCase.verifyFalse( isvalid(fig) );
            
            % Verify deleting the uifigure deletes the app
            app = testHelper.SingleSessionAppHelper();
            fig = app.Figure;
            delete(fig);
            testCase.verifyFalse( isvalid(app) );
            
        end %function
        
    end %methods (Test)
    
end %classdef