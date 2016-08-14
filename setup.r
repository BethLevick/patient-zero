############################################################################################################
### Set up environment ###
### BL 06/07/15 ###
### All set up code (i.e. run once to load packages etc. is now in this file ###
### This file is run at the top of big-bang.r ###
#####################################################################################################
### Load iGraph package for plotting networks ###
require(igraph)

### Load twitteR package for Twitter searches and managing Tweet data ###
library (twitteR)
### set working drive to pull Twitter authorisation from ###
### TODO: ensure this is correct on machine we take to Aintree ###
setwd( "" )
## load credentials
load("twitteR_credentials")
## check connection - will print [TRUE]
registerTwitterOAuth(twitCred)
##########################################################################################################
### Set up network structure to add connections to
## Create a central ID to which everyone is connected
centid <- "IDAAA"

## set up an initial data store with just the central id related to itself
dat <- matrix( ncol=2, nrow=1, c(centid, centid) )

## set up some options for plotting the graphics, means we don't have to put it in each time we gen a plot
### TODO: talk to AM, does this need to be removed/altered to fit her infection formatting?
igraph.options(vertex.color="orange", vertex.frame.color="darkblue", edge.color="darkblue", 
	edge.arrow.mode=0, vertex.label.family="helvetica")

#to set up network object, this gets updated below
g <- graph.data.frame(dat, directed=FALSE)	

## For testing: set time as first Jan to pick up old Tweets
prev.char <- "2015-01-01 01:01:01 BST"
previous <- strptime( prev.char, format="%Y-%m-%d %H:%M:%S" )

## For on the day: set initial time as one hour previous to the current time
## This will then ignore the test/promotional tweets sent previously
#previous <- strptime( Sys.time(), format="%Y-%m-%d %H:%M:%S" )
#previous$hour <- previous - 1
##########################################################################################################
