### R files to run the Project Patient Zero demo at the North West Big Bang Fair 2015 ###
### Bethany Levick and Amanda Minter, University of Liverpool ###
### Code written by BL and AM, Git repository and documentation maintained by BL ###

### Written and run in the R statistical computing environment
### The R Core Team, 2015. 

### Using the igraph package
### Csardi & Nepusz 2006, The igraph package for complex network research http://igraph.org
### using the twitteR package
### Gentry 2013, twitteR: the R based Twitter client. http://CRAN.R-project.org/package=twitter

### Files
### setup.r establishes the working environment: loads R packages, sets network image formatting
### sets initial time of search (set as 1st Jan 2015)
### This will only capture Tweets posted within the window that the API can access them (9 days)
### functions.r containins functions written by BL and AM
### big-bang.r is the main file used to run the demo on the day