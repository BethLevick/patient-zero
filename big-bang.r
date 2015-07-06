############################################################################################################
### Main file to run Twitter searches and update the network ###
### Once setup and functions file have been loaded once, this section should not be re run ###
##########################################################################################################
## set working drive to find setup and functions code files files
setwd("C:/Users/Bethany/Dropbox/ThresholdFestival-Shared/big-bang_R/git-files")
source("functions.r")
source("setup.r")
##########################################################################################################
### Run from here to perform Twitter search and add to Network object ###
## Search twitter for anyone using the #tag
## on first run previous is set in the setup file
## from then on it is the time this code was last run - set at the bottom of this document
## set working drive for Twitter credentials
setwd( "C:/Users/Bethany/Dropbox/ThresholdFestival-Shared/" )
## perform twitter search
s <- searchTwitter('#BigBangNW', n=1000, since="2015-01-01", cainfo="cacert.pem")

## set up vectors to store data
user <- vector()
tme <- vector()
tweet <- vector()

## for the each of the matching tweets
for(k in 1:length(s)){
tmp.l <- s[[k]]		#pull out kth list of status results per search

	#take each part of the Twitter object and push to the appropriate vectors
	user <- c( user, tmp.l$screenName)
	tme <- c( tme, as.character(tmp.l$created) )
	tweet <- c( tweet, tmp.l$text )
	
}

## bind together as data frame
tSearch <- data.frame( user=user, tme=tme, tweet=tweet ) 
## convert to character to allow
tSearch$user <- as.character( tSearch$user )
tSearch$tme <- as.character( tSearch$tme )
tSearch$tweet <- as.character( tSearch$tweet )

## now need to know how many names are there to generate IDs for
for(i in 1:nrow(tSearch)){
## for each tweet, split the string by white spaces
splt <- strsplit( tSearch$tweet[i], " ", fixed=TRUE )
#print(splt)
## extract the vector from the resulting list object
spl <- as.vector(splt[[1]])
#print(spl)
## group size is the number of words in the tweet without a hashtag or @ in them
tSearch$group.size[i] <- length(which(grepl("[#@]",spl)==FALSE))
}

## convert time stamp to R date format
tSearch$tme <- strptime( tSearch$tme, format="%Y-%m-%d %H:%M:%S" )
####################################################################################
## add new groups to network ##
## Generate a list of ID groups
clusters <- addNewTweets( tSearch, previous )

## for each vector in the list
for(i in 1:length(clusters)){
## generate the set of new connections and rbind this to the main data frame
dat <- rbind( dat, connections( clusters[[i]], centid ) )
}

## set working drive for saving snapshots
setwd( "C:/Users/Bethany/Documents/big-bang-snapshots" )
## save the data frame at this point to get a snapshot of the data
filename <- paste( "snapshot", format( Sys.time(), "%H-%M-%S" ), sep="_" )
filename <- paste( filename, "RData", sep="." )

## REACTIVATE SAVE FUNCTION ON THE DAY - COMMENTED OUT FOR NOW BECAUSE DROPBOX SPACE
#save( dat, file=filename )

## save time at end of run to get new tweets in next run
previous <- strptime( Sys.time(), format="%Y-%m-%d %H:%M:%S" )
####################################################################################
## update the iGraph network object
g <- updateNetwork( dat )
####################################################################################
## to run infection
#create the first infect.mat
#centid to be infected from start
infect.mat<-firstinfectMat(dat,'IDAAA')
#do some infecting
infect.mat<-infectMe(infect.mat,0.5)
#replot network
updateNetwork(dat,infect.mat)
####################################################################################