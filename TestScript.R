# This is an example R script to test README generation

# In order to auto generate/update README files:
  # 1) Add new line calling autoREADME and specifying the directory
  # 2) Add new section to YAML file to checkout other repos

# Test README generation
autoREADME(dirREADME = "TestRepo/AnotherFolder")

# Add steps to set up R environment, load R packages, run my script

# Simpler example: https://blog--simonpcouch.netlify.app/blog/r-github-actions-commit/
# More complex example (probably what I want): https://www.r-bloggers.com/2020/09/running-an-r-script-on-a-schedule-gh-actions/
# GitHub documentation: https://docs.github.com/en/actions/learn-github-actions/understanding-github-actions

