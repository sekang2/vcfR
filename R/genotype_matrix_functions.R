

#' @title Genotype matrix functions
#' @name Genotype matrix functions
#' 
#' @description Functions which modify a matrix or vector of genotypes.
#' 
#' @rdname genotype_matrix
#' @aliases alleles2consensus
#' 
#' @param x a matrix of alleles as genotypes (e.g., A/A, C/G, etc.)
#' @param sep a character which delimits the alleles in a genotype (/ or |)
#' @param NA_to_n logical indicating whether NAs should be scores as n
#' 
#' @details 
#' The function \strong{alleles2consensus} converts genotypes to a single consensus allele using IUPAC ambiguity codes for heterozygotes. 
#' Note that some functions, such as ape::seg.sites do not recognize ambiguity characters (other than 'n').
#' This means that these functions, as well as functions that depend on them (e.g., pegas::tajima.test), will produce unexpected results.
#' 
#' Missing data are handled in a number of steps.
#' When both alleles are missing ('.') the genotype is converted to NA.
#' Secondly, if one of the alleles is missing ('.') the genotype is converted to NA>
#' Lastly, NAs can be optionally converted to 'n' for compatibility with DNAbin objects.
#' 
#' @export
alleles2consensus <- function( x, sep = "/", NA_to_n = TRUE ){
#  lookup <- cbind(paste(c('A','C','G','T', 'A','T','C','G', 'A','C','G','T', 'A','G','C','T'),
#                        c('A','C','G','T', 'T','A','G','C', 'C','A','T','G', 'G','A','T','C'),
#                        sep=sep),
#                  c('a','c','g','t', 'w','w','s','s', 'm','m','k','k', 'r','r','y','y'))
  
  lookup1 <- cbind(paste(c('A','C','G','T', 'A','T','C','G', 'A','C','G','T', 'A','G','C','T'),
                         c('A','C','G','T', 'T','A','G','C', 'C','A','T','G', 'G','A','T','C'),
                         sep="/"),
                   c('a','c','g','t', 'w','w','s','s', 'm','m','k','k', 'r','r','y','y'))
  lookup2 <- cbind(paste(c('A','C','G','T', 'A','T','C','G', 'A','C','G','T', 'A','G','C','T'),
                         c('A','C','G','T', 'T','A','G','C', 'C','A','T','G', 'G','A','T','C'),
                         sep="|"),
                   c('a','c','g','t', 'w','w','s','s', 'm','m','k','k', 'r','r','y','y'))
      
  # Both alleles missing, set to NA.
#  x <- gsub( paste(".", ".", sep=sep), NA, x, fixed=TRUE)
  x <- gsub( paste(".", ".", sep="/"), NA, x, fixed=TRUE)
  x <- gsub( paste(".", ".", sep="|"), NA, x, fixed=TRUE)
  
  # One of the alleles missing set to NA.
  x <- gsub( ".", NA, x, fixed=TRUE)
  
  for(i in 1:nrow( lookup1 ))
  {
    x[ x == lookup1[i,1] ] <- lookup1[i,2]
    x[ x == lookup2[i,1] ] <- lookup2[i,2]
  }
  
  if( NA_to_n == TRUE )
  {
    x[ is.na(x) ] <- 'n'
  }
  
  x
}


#' @rdname genotype_matrix
#' @aliases get.alleles
#' 
#' @param x2 a vector of genotypes
#' @param split character passed to strsplit to split the genotype into alleles
#' @param na.rm logical indicating whether to remove NAs
#' @param as.numeric logical specifying whether to convert to a numeric
#' 
#' @details 
#' The function \strong{get.alleles} takes a vector of genotypes and returns the unique alleles.
#' 
#' @export
get.alleles <- function( x2, split="/", na.rm = FALSE, as.numeric = FALSE ){
  x2 <- unlist(strsplit(x2, split))
  if(na.rm == TRUE){
    x2 <- x2[ x2 != "NA" ]
  }
  if(as.numeric == TRUE){
    x2 <- as.numeric(x2)
  }
  x2 <- unique(x2)
  x2
}


##### ##### ##### ##### #####
# EOF.