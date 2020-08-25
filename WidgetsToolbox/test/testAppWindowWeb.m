classdef testAppWindowWeb < matlab.unittest.TestCase
    % testAppWindow - Unit Test for uiw.abstract.AppWindow
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
      App testHelper.AppWindowHelper
  end
 
  
  %% Setup and Teardown
    methods (TestClassSetup)
        function setupOnce(testCase)
            testCase.App = testHelper.AppWindowHelper();
        end
    end
    
    methods (TestClassTeardown)
        function teardownOnce(testCase)
            delete(testCase.App);
        end
    end
    
    
    %% Unit Tests
    methods (Test)
        
        
        function testFigureName(testCase)
            
            expName = 'App Window Test Helper';
            
            name = testCase.App.Title;
            testCase.verifyEqual(name,expName);
            
            name = testCase.App.Figure.Name;
            testCase.verifyEqual(name,expName);
            
        end %function
        
        
        function testPreferences(testCase)
            
            defaultPos = [0 0 1 1];
            newPos = [123 123 456 456];
            
            % Set preference with a default
            [~] = testCase.App.getPreferenceTest('Position',defaultPos);
            
            % Set preference to a new value
            testCase.App.setPreferenceTest('Position',newPos);
            
            % Verify we can get the new preference value back
            pos = testCase.App.getPreferenceTest('Position',defaultPos);
            testCase.verifyEqual(pos,newPos);
            
        end %function
        
        
        
        function testFigureDeletion(testCase)
            
            % Verify deleting the app deletes the uifigure
            app = testHelper.AppWindowHelper();
            fig = app.Figure;
            delete(app);
            testCase.verifyFalse( isvalid(fig) );
            
            % Verify deleting the uifigure deletes the app
            app = testHelper.AppWindowHelper();
            fig = app.Figure;
            delete(fig);
            testCase.verifyFalse( isvalid(app) );
            
        end %function
        
    end %methods (Test)
    
end %classdef