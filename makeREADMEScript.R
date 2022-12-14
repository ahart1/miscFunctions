# This is an example R script to test README generation

##### Updating/generating new README files #####
# README in specified dirREADME below updated every Monday
# May also run manually: GitHub profile -> miscFunctions -> All Workflows -> auto-generate-readme on left -> Click "Run workflow" on right (can specify branch)
# May uncomment 'push: branches: [ master ]' lines in the YAML to update on each push to miscFunctions (CAUTION: frequent pushes could result in running out of GitHub action minutes!)

##### Auto generating/updating new README files #####
# In order to auto generate/update README files:
  # 1) Add new line calling autoREADME and specifying the new directory
  # IF new directory is from a new repo also do the following:
    # 2) Add new section to YAML file to checkout other repos
    # 3) In the GitHub repo go to Settings -> Actions -> General -> Workflow permissions and select "Read and write permissions"
    # 4) Add new section to YAML file to commit updated README files

##### Update/generate README files #####
autoREADME(dirREADME = "TestRepo/AnotherFolder")
autoREADME(dirREADME = "TestRepo/TestFolder")
autoREADME(dirREADME = "TestThis", title = "Test Title", description = "This is an example README generated in several steps to confirm that autoREADME function and associated GitHub action works correctly.")

##### Debugging #####
# If the GitHub action does not work try:
  # 1) Check that the personal action token is still active
    # 1a) GitHub profile -> Settings -> <> Developer settings -> Personal access tokens -> check expiration for token
    # 1b) If expired, create a new token & copy token
    # 1c) Navigate to miscFunctions -> Settings -> Secrets -> Actions -> Edit the personal access secret with the new token
  # 2) Check that all repos for which README files should be generated have read/write permission for actions (default = only read permission)
    # 2a) Check GitHub repo -> Settings -> Actions -> General -> Workflow permissions
    # 2b) Make sure "Read and write permissions" option is selected
  # 3) Check frequency with which action is triggered
    # 3a) Currently set up to run weekly, this can be edited by:
    # 3b) Change schedule using 'cron' in YAML file OR
    # 3c) Uncomment the 'push: branches: [ master ]' lines in the YAML so action run on every push (CAUTION: frequent pushes could result in running out of GitHub action minutes!)
  # 4) Check that your existing README has a File and Folder header and the first line of the table:
    ##  # File/Folder Title
    ##  | File        | Description | # Swap out Folder in this line for the folder section
    ##  | ----------- | ----------- |
    # 4a) NOTE: The README causing errors may be only on GitHub if you haven't pulled changes recently!
  # 5) Confirm that you are running the action in miscFunctions directory, if you try running the action elsewhere the script won't find the autoREADME function and other errors will be generated.

##### Resources #####
# Simpler example: https://blog--simonpcouch.netlify.app/blog/r-github-actions-commit/
# More complex example (probably what I want): https://www.r-bloggers.com/2020/09/running-an-r-script-on-a-schedule-gh-actions/
# GitHub documentation: https://docs.github.com/en/actions/learn-github-actions/understanding-github-actions
# Add and commit option I did use: https://github.com/marketplace/actions/add-commit
# Autocommit option I didn't use: https://github.com/marketplace/actions/git-auto-commit
# Info on GITHUB_TOKENS: https://dev.to/github/the-githubtoken-in-github-actions-how-it-works-change-permissions-customizations-3cgp#:~:text=Just%20go%20to%20your%20repository,changes)%20or%20Read%2Donly%20.
# Documentation for GitHub actions for R (standard offerings): https://github.com/r-lib/actions
# Using secrets in a workflow: https://docs.github.com/en/actions/security-guides/encrypted-secrets

