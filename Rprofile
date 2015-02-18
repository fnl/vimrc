options("repos"=c(CRAN="http://cran.es.r-project.org/", RSTUDIO="http://cran.rstudio.com/"))
options(max.print=100) # stop spamming the console
options(tab.width=2)
options(stringsAsFactors = FALSE) # text mining ahoy!

# Create an invisible environment for all functions so they don't clutter your workspace.
.env <- new.env()

# Return names(df) in single column, numbered matrix format.
.env$n <- function(df) matrix(names(df)) 

# Single character shortcuts for summary() and head().
.env$h <- utils::head
.env$n <- base::names
.env$s <- base::summary
# ht==headtail, i.e., show the first and last 10 items of an object
.env$ht <- function(d) rbind(head(d,10),tail(d,10))

# Returns a logical vector TRUE for elements of X not in Y
.env$"%nin%" <- function(x, y) !(x %in% y) 

# Read data on clipboard.
.env$read.clipboard <- function(...) {
	ismac <- Sys.info()[1] == "Darwin"
	if (!ismac) read.table(file="clipboard", ...)
	else read.table(pipe("pbpaste"), ...)
}

# Open Finder to the current directory on mac
.env$Finder <- function(...) if (Sys.info()[1] == "Darwin") system("open .")

# attach the newly created functions
attach(.env)

# .First() run at the start of every R session.
.First <- function() {
	cat("\nStarted R session at ", date(), "\n")
}
 
# .Last() run at the end of the session
.Last <- function() {
	cat("\nClosing R session at ", date(), "\n")
}
