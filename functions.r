#######################################################################################################
### Functions to run big-bang.r ###
### All functions written by BL and AM are in this file ###
### Called by the big-bang.r file at the top ###
#####################################################################################################
## FUNCTIONS ##

### uniqueID ###
## generates a unique ID number 
## comprising "ID" and a 3 digit number 
## No information is taken - ID has no relation to inputted name/nick name
## returns character string in format "ID000"
uniqueID <- function(){
return( paste( "ID", sample( c(0:9), 1 ), sample( c(0:9), 1 ), sample( c(0:9), 1 ), sep="", collapse="" ) )
}

## example usage, e.g. to generate a group of IDs
## group.ids <- c( uniqueID(), uniqueID(), uniqueID() )

### connections ###
## Take entered IDs as a vector (i.e. a cluster in the network) and the central id 
## find all new connection events (within group and with central node
## return a matrix of all new connection events to concatenate to the main data object
connections <- function(idvec, centid){
# if only 1 ID entered
if( length(idvec==1) ){
	rows <- c(idvec[1], centid)
}
## if there is more than 1 ID entered
if( length(idvec>1) ){
	# if more than 1 ID entered
	# find all combination pairs of the entered id's
	rows <- as.matrix( expand.grid( data.frame( a=idvec, b=idvec ) ) )
	# remove self self pairs
	rows <- rows[rows[,1]!=rows[,2],]
	# add on to this each id with the central id
	rows <- rbind( rows, matrix( c( idvec, c(rep(centid, length(idvec))) ), ncol=2, nrow=length(idvec)  ) ) 
}
return(rows)
}

## Example usage
#newdat <- connections( c(uniqueID(), uniqueID(), uniqueID()), centid )

### newConnect ###
## takes newly generated rows of connections data and binds to main data set
## BL - not sure if this is needed now: accounted for in AMs code 
## and snapshots are saved following the Twitter search
newConnect <- function( olddata, newdata, storlist ){
	#updateSnapshot( olddata, newdata, storlist )
	return( rbind( olddata, newdata ) )
}

## example usage
## x <- newConnect( dat, newdat, snapshot )

## addNewTweets
## takes the formatted results from a twitter search, and the time at the previous search
## Finds new tweets, and generates a string of IDs for the words in each one
## i.e. the tweet "Chell GLaDoS Wheatly #pp0bb" would generate a group of 3 IDs
## a list object is returned with a list item for each tweet
## each list item is a vector of the IDs
addNewTweets <- function(tSearch, previous){

sset <- tSearch[tSearch$tme>previous,]

## Use this value to generate IDs and connections in the above
## make a list object to store vectors
groups <- list()
## for each row in the tSearch data frame (each new tweet)
for( i in 1:nrow(sset) ){
## make an empty vector to build on
id.vec <- vector()
## for the size of the group
for(k in 1:sset$group.size[i]){
## generate a unique ID and concatenate this onto the vector
id.vec <- c(id.vec, uniqueID())
}
## move this to the list object to store
groups[[i]] <- id.vec
}

return(groups)

}


### updateNetwork ###
## Just a wrapper function for updating the igraph object ##
## Again - in light of AM's code is this needed? ##
updateNetwork <- function( dat ){
## generate new network object
g <- graph.data.frame(dat, directed=FALSE)
## plot
plot(g, layout=layout.random(g))
## return new network object	
return( g )
}
#########################################################################################################
#########################################################################################################
## AM functions for infection
####firstinfectMat######
#function to create the first infect.mat
firstinfectMat<-function(dat,centid,centid.infect=TRUE){
  #find all the unique id numbers
  unique.ids<-unique(c(dat))
  infected<-rep(0,length(unique.ids))
  #make a matrix to combine this info
  #so that i can match id to infection status
  infect.mat<-cbind(unique.ids,infected)
  
  #if we want centid to be infected
  if(centid.infect==TRUE)   infect.mat[which(infect.mat[,'unique.ids']==centid),'infected']<-1

  return(infect.mat)
}


####infectMat####
#creates new infect.mat based on old infection matrix and new connection matrix
infectMat<-function(newdat,infect.mat){
  unique.ids<-unique(c(newdat))
  #find the ids that already have infection
  match.vec<-match(infect.mat[,'unique.ids'],unique.ids)
  #make everything else have infection 0
  newinfect.mat<-cbind(unique.ids[-match.vec],rep(0,length(unique.ids[-match.vec])))
  #rbind the old infect.mat with the new
  infect.mat<-rbind(infect.mat,newinfect.mat)
  #return new infect.mat
  return(infect.mat)
}


####infectMe####
#function of connection matrix with infection matrix
###probability of infection theta
infectMe<-function(infect.mat,theta){
  #for those that are not infected
  #infect them with prob theta
  infect.mat[which(infect.mat[,'infected']==0),'infected']<-rbinom(length(infect.mat[which(infect.mat[,'infected']==0),'infected']),1,theta)
  #return updated matrix
  return(infect.mat)
}

#added new lines so that the colour vector of the nodes is also updated
#arguments are the connection matrix and the infection matrix
updateNetwork <- function(dat,infect.mat ){
  ## generate new network object
  g <- graph.data.frame(dat, directed=FALSE)
  ##update colours of nodes

  V(g)$infected<-infect.mat[,'infected']  
  V(g)$color <- "green"
  V(g)[ infected ==1 ]$color <- "red"
  ## plot
  plot(g, layout=layout.random(g))
  ## return new network object  
  return( g )
}
#####################################################################################################