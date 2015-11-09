# Libraries
library(ggplot2)
library(ggtree) # from bioconductor
library(ape) # dev version from ape website repo
library(phangorn)
library(reshape2)
library(dplyr)

# Removes any bootstrap values < user-defined cutoff. 
bsFixr <- function(bsvec, bsval) {
  for(x in 1:length(bsvec)) {
    if(bsvec[x] != "" && as.numeric(as.character(bsvec[x])) < bsval) {
      bsvec[x] <- NA
    }
  }
  return(bsvec)
}

# Removes labels from nodes that are not tips
lbFixr <- function(df) {
  for(x in 1:length(df$label)) {
    if(df$isTip[x] != TRUE) {
      df$label[x] <- NA
    }
  }
  return(df)
}

# Import the newick tree file, perform a midpoint root, add the bootstrap values, and capture the tip labels and the clade members. 
# Returns a named list containing a ggtree object (tree) and a vector of tip labels (tips).
importTree <- function(treefile, bsval = bsval) {
  intree <- read.tree(file = treefile)
  mptree <- midpoint(intree)
  bstree <- new("raxml", 
                phylo = mptree, 
                bootstrap = data.frame(node = (1:Nnode(mptree)) + Ntip(mptree), bootstrap = mptree$node.label))
  bstree@bootstrap$bootstrap <- bsFixr(bstree@bootstrap$bootstrap, bsval = bsval)
  tips <- bstree@phylo$tip.label
  outtree <- ggtree(bstree, ladderize = FALSE)
  outtree$data <- lbFixr(outtree$data)
  print(outtree$data)
  return(list(tree = outtree, tips = tips))
}

basetree <- function(mytree, bssize = 3, bscol = "black", tipsize = 5, lgsize = 12, lgtitle = 12, scsize = 9, treewdth = 2.35, spacing = max(mytree$tree$data$x)) {
  eval(substitute(
    expr = {
      ot <- mytree$tree +
        geom_text(data = mytree$tree$data, 
                  aes_string(label = "label"), 
                  hjust = -0.25, size = tipsize) +
        geom_text(aes(label = bootstrap), size = bssize, color = bscol, hjust = 1.1, vjust = -0.4) +
        xlim(NA, treewdth * spacing) +# Determines space for labels to the right of the tree tips.
        theme_classic()
    }
    ))
  return(ot %>% add_legend(font.size = scsize))
}

### End Functions