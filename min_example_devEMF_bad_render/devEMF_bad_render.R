library(ggtree) # from github (GuangchuangYu/ggtree)
library(devEMF) # Archival version 1.2 from Cran
library(gridSVG)
library(grid)
library(grImport2)

# Custom functions

## Altered from original ggtree version such that it takes SVG files and offset has effect when align = FALSE.
annotation_image3 <- function(tree_view, img_info, width=0.1, align=TRUE, linetype="dotted", linesize =1, offset=0) {
  df <- tree_view$data
  idx <- match(img_info[,1], df$label)
  x <- df[idx, "x"]
  y <- df[idx, "y"]
  
  images <- lapply(img_info[,2], importIconSvg)
  
  width <- width * diff(range(df$x))
  if (align) {
    xmin <- max(df$x) + offset
    xmin <- rep(xmin, length(x))
    xmax <- xmin + width
  } else {
    xmin <- x - width/2 + offset
    xmax <- x + width/2
  }
  
  ymin <- y - 7 * width/2
  ymax <- y + 7 * width/2
  image_layers <- lapply(1:length(xmin), function(i) {
    annotation_custom(xmin=xmin[i], ymin=ymin[i],
                      xmax=xmax[i], ymax=ymax[i],
                      grob = images[[i]])
  })
  
  tree_view <- tree_view + image_layers
  
  if (align && (!is.null(linetype) && !is.na(linetype))) {
    tree_view <- tree_view + geom_segment(data=df[idx,],
                                          x=xmin, xend = x*1.01,
                                          y = y, yend = y,
                                          linetype=linetype, size=linesize)
  }
  tree_view
}

## Image import function for annotation_image3()
importIconSvg <- function(fname) {
  return(gTree(children = gList(pictureGrob(readPicture(fname), ext = "gridSVG"))))
}

# End custom functions



# Demo

## Read in a newick tree file
nwk <- system.file("extdata", "sample.nwk", package="ggtree")
tree <- read.tree(nwk)

## Make a basic ggtree
prettytree <- ggtree(tree) +
              theme_tree() +
              geom_tiplab()
prettytree

## Create the data frame linking taxa and icons
img_info <- data.frame(taxa = na.omit(prettytree$data$label), 
                       image = c(rep("noun_62621_cc.svg", 6), rep("noun_231825_cc.svg", 7)), 
                       stringsAsFactors = FALSE)

## Add the svg icons; this is the plot I want to render in EMF.
out_img <- annotation_image3(prettytree, img_info, linetype = NULL, width = 0.06, offset = 1)

## With devEMF icons missing or low quality when image viewed in PowerPoint on Win7
emf(file = "testout.emf", width = 7, height = 7)
out_img
grDevices::dev.off()

## Basic svg render looks as expected when image viewed in IE11 on Win7
svg(file = "testout.svg", width = 7, height = 7)
out_img
grDevices::dev.off()

## PDF also renders as expected
pdf(file = "testout.pdf", width = 7, height = 7)
out_img
grDevices::dev.off()
