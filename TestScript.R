# This is an example R script to test README generation

# In order to auto generate/update README files:
  # 1) Add new line calling autoREADME and specifying the new directory
  # IF new directory is from a new repo also do the following:
    # 2) Add new section to YAML file to checkout other repos
    # 3) In the GitHub repo go to Settings -> Actions -> General -> Workflow permissions and select "Read and write permissions"

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

# install.packages("usethis")
# library(usethis)
# install.packages("pkgdown")
# library(pkgdown)
# install.packages("rcmdcheck")
# library(rcmdcheck)
# install.packages("rversions")
# library(rversions)
# install.packages("urlchecker")
# library(urlchecker)
# install.packages('devtools')
# library(devtools)
# devtools::install_github("ahart1/miscFunctions")
# library(miscFunctions)
# devtools::install_github("ahart1/miscFunctions")


# Test README generation
autoREADME(dirREADME = "TestRepo/AnotherFolder")



# Simpler example: https://blog--simonpcouch.netlify.app/blog/r-github-actions-commit/
# More complex example (probably what I want): https://www.r-bloggers.com/2020/09/running-an-r-script-on-a-schedule-gh-actions/
# GitHub documentation: https://docs.github.com/en/actions/learn-github-actions/understanding-github-actions

