
### plot distribution of microbes for disease:

setwd("/Users/Jeanetta-Li/Desktop/essay/#AbundanceData")


## intall packages--
# install.packages('ggplot')
# install.packages('ggpubr')
# install.packages('magrittr')
# install.packages('ggsignif')


library(ggplot2)
library(ggpubr)
library(magrittr)
library(ggsignif)


path_in <- './f2_diseaseGroup_for_Boxplot_log10/Genus/'
### path_in <- './f2_diseaseGroup_for_Boxplot_log10/Species/'
path_out <- './boxPlot_diseaseGroups_log10/Genus/'
### path_out <- './boxPlot_diseaseGroups_log10/Species/'



G_order <- read.table('microbe_info_LM_G.txt',header = FALSE,sep = '\n')
G_order <- as.vector(G_order$V1)

S_order <- read.table('microbe_info_LM_S.txt',header = FALSE,sep = '\n')
S_order <- as.vector(S_order$V1)

N_order <- setNames(c(length(G_order):1),G_order)
### N_order <- setNames(c(length(S_order):1),S_order)

files <- list.files(path=path_in, pattern="*.txt", full.names=TRUE, recursive=FALSE)

lapply(files, function(f_abundance) {

  disease <- strsplit(f_abundance,'/')[1]
  disease <- disease[[1]][5]
  disease <- sub("_meta_data.txt",'',disease)

  if (file.exists(f_abundance)){
    figure_fileName = paste(path_out,disease,".jpg",sep="")
    dat <- read.csv(f_abundance,sep = '\t',header = FALSE)

    names(dat) <- c('tax_id','abundance_log10')

    dat$no <- N_order[match(dat$tax_id,names(N_order))]
    dat[is.na(dat)] <- 0
    dat$no <- as.factor(dat$no)


    p <- ggboxplot(dat,x = 'no', y = 'abundance_log10' ,
              color = 'no',
              bxp.errorbar = T,bxp.errorbar.width=0.2,
              palette= 'jitter', add='jitter',
              add.params = list(size= .1,alpha = .5),
              # outlier.shape = NA,
              # outlier.size = NA,
            ) +
      labs(title = "relative_abundance_Boxplot",subtitle = disease,
           caption = "data source: GMrepo",x = 'tax_id',
           y='RAbudance_log10'
          )+
      scale_x_discrete(labels = rev(G_order))+
      ### scale_x_discrete(labels = rev(S_order))+

      coord_flip()+ # transpose
      theme(
        plot.title = element_text(color = 'black',size = 8,hjust = 0.5),
        plot.subtitle = element_text(color = 'black',size = 6,hjust = 0.5),
        plot.caption = element_text(color = 'black',size = 6,face = 0.5),
        axis.text.y = element_text(color = 'black', size = 4,angle = 0),
        axis.text.x = element_text(color = 'black', size = 4,angle = 0),
        axis.title.x = element_text(color = 'black', size = 6,angle = 0),
        axis.title.y = element_text(color = 'black', size = 6,angle = 90),
        legend.title = element_text(color = 'black', size = 6),
        legend.text = element_text(color = 'black', size = 6),
        panel.border = element_rect(linetype = 'solid', size = .5, fill = NA),
        legend.position = "none"
        )

    ggsave(p, filename=paste(figure_fileName,sep=""), width=5, height=20, units=c("cm"))
    ### ggsave(p, filename=paste(figure_fileName,sep=""), width=5, height=50, units=c("cm"))

  }else{
    print(f_abundance)
  }
})


