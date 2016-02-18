
#Script generated from diff exp

#Create installation dir for packages
libDir <- "/Users/fac2003/.metaRlibs"
dir.create(file.path(libDir), showWarnings = FALSE, recursive = TRUE)
.libPaths(c(libDir))

#create the output dir
dir.create(file.path("/Users/fac2003/R_RESULTS/model"), showWarnings = FALSE, recursive = TRUE)
if (!( require("biomaRt")|require("limma")|require("edgeR") )) {
 if (!require("BiocInstaller")) { 
     source("http://bioconductor.org/biocLite.R", local=TRUE)  
 }
  
   biocLite(ask=FALSE, c("biomaRt","limma","edgeR"))
  library("biomaRt")
library("limma")
library("edgeR")

} 










if (!require("plyr")) {install.packages("plyr",repos='http://cran.us.r-project.org'); library("plyr")};
if (!require("Cairo")) {install.packages("Cairo",repos='http://cran.us.r-project.org'); library("Cairo")};
if (!require("limma")) {install.packages("limma",repos='http://cran.us.r-project.org'); library("limma")};
if (!require("data.table")) {install.packages("data.table",repos='http://cran.us.r-project.org'); library("data.table")};
if (!require("edgeR")) {install.packages("edgeR",repos='http://cran.us.r-project.org'); library("edgeR")};
if (!require("graphics")) {install.packages("graphics",repos='http://cran.us.r-project.org'); library("graphics")};
if (!require("pheatmap")) {install.packages("pheatmap",repos='http://cran.us.r-project.org'); library("pheatmap")};


#empty line
GSE59364_DC_all.csv <- fread("/Users/fac2003/MPSProjects/git/metar/data/GSE59364_DC_all.csv", colClasses=c("character", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric"))
cat("STATEMENT_EXECUTED/7676436067297087329/\n");


tryCatch({

 # Replace row names with gene identifiers
 # TODO: make a copy of the input table, rather than using it by reference.
  countsTable <- copy(GSE59364_DC_all.csv)
  rownames_for_CountsTable <- GSE59364_DC_all.csv$"gene" 
# remove all columns not marked with the "counts" group.
  countsTable <- countsTable[,"gene":=NULL]
  countsTable <- countsTable[,"mRNA len":=NULL]
  countsTable <- countsTable[,"genomic span":=NULL]
  countsTable <- countsTable[,"DC_normal":=NULL]
  countsTable <- countsTable[,"DC_treated":=NULL]

sampleNames <- c("DC0904", "DC0907", "DCLPS0910", "DCLPS0913", "A_DC", "A_DC_LPS", "B_DC", "B_DC_LPS", "C_DC", "C_DC_LPS", "C2DC", "C2DCLPS", "C3DC", "C3DCLPS")

  setcolorder(countsTable, sampleNames)   
  countsTable <- as.matrix(countsTable)

  sampleNames <- colnames(countsTable)
  LPS_Treatment <- c( "LPS_no", "LPS_no", "LPS_yes", "LPS_yes", "LPS_no", "LPS_yes", "LPS_no", "LPS_yes", "LPS_no", "LPS_yes", "LPS_no", "LPS_yes", "LPS_no", "LPS_yes" )

  data <- DGEList(counts=countsTable, genes=rownames_for_CountsTable)
  data <- calcNormFactors(data)
 design <- model.matrix(~ 0 + LPS_Treatment) 
  voom <- voom(data,design)



tryCatch({
fit <- lmFit(voom, design) 
}
)
fit2 <-contrasts.fit(fit, contrasts=makeContrasts( LPS_TreatmentLPS_no-LPS_TreatmentLPS_yes, levels=design))
fit3 <- eBayes(fit2) 


# TODO: change the below line to use constrasts from the limmaVoom statement:
Results <- data.table(topTable(fit3,coef=1, number=nrow(countsTable)))
cat("STATEMENT_EXECUTED/7676436067297087336/\n")
write.table(Results,"/Users/fac2003/R_RESULTS/model/table_Results_0.tsv", row.names=FALSE, sep="\t") 
}
, warning = function(w) {
cat(paste("Node STATEMENT_EXECUTED/7676436067297087336/ generated the following warning: ",w,"\n"));
}
, error = function(e) {
cat(paste("Node STATEMENT_EXECUTED/7676436067297087336/ generated the following error: ",e,"\n"));
stop();
}
, finally = {
cat("STATEMENT_EXECUTED/7676436067297087336/\n");
}
)

tryCatch({

subset <- Results[Results$"adj.P.Val" <= 0.001]
if (nrow(subset)==0) {
  cat("Warning: Subset removed all rows of table Results. Following statements may fail if they expect results after filtering.\n")
}
write.table(subset,"/Users/fac2003/R_RESULTS/model/table_subset_0.tsv", row.names=FALSE, sep="\t") 

}
, warning = function(w) {
cat(paste("Node STATEMENT_EXECUTED/7676436067297087454/ generated the following warning: ",w,"\n"));
}
, error = function(e) {
cat(paste("Node STATEMENT_EXECUTED/7676436067297087454/ generated the following error: ",e,"\n"));
stop();
}
, finally = {
cat("STATEMENT_EXECUTED/7676436067297087454/\n");
}
)

tryCatch({
setkey(GSE59364_DC_all.csv, "gene")
setkey(subset, "genes")
subset <- rename(subset, c("genes"="gene"))
tableSuffixes=c("", "")
joiningColumns=c("gene")
nextTableToMergeInto=GSE59364_DC_all.csv
nextTableToMergeFrom=subset
mergedsubset <- merge(nextTableToMergeInto, nextTableToMergeFrom, by=joiningColumns, suffixes=tableSuffixes)
nextTableToMergeInto=mergedsubset
joined <- mergedsubset
rm(mergedsubset)

# Add the columns back in the destination:
joined <- joined[,"genes":=joined$"gene"]

# Add the rename back source columns
subset <- rename(subset, c("gene"="genes"))
write.table(joined,"/Users/fac2003/R_RESULTS/model/table_joined_0.tsv", row.names=FALSE, sep="\t") 
}
, warning = function(w) {
cat(paste("Node STATEMENT_EXECUTED/7676436067297093841/ generated the following warning: ",w,"\n"));
}
, error = function(e) {
cat(paste("Node STATEMENT_EXECUTED/7676436067297093841/ generated the following error: ",e,"\n"));
stop();
}
, finally = {
cat("STATEMENT_EXECUTED/7676436067297093841/\n");
}
)
plot_UQVETJSCUB=function(t)
{

tryCatch({
LegendFrame=data.frame(c("LPS=no","LPS=no","LPS=no","LPS=yes","LPS=yes","LPS=yes","LPS=yes","LPS=no","LPS=yes","LPS=no","LPS=yes","LPS=yes","LPS=no","LPS=no"), c("B_DC","A_DC","C_DC","C3DCLPS","C_DC_LPS","A_DC_LPS","B_DC_LPS","C3DC","C2DCLPS","C2DC","DCLPS0910","DCLPS0913","DC0904","DC0907"))

colnames(LegendFrame)=c("Group","SampleId")
# reorder by group name:
LegendFrameSorted=LegendFrame[order(LegendFrame$Group,LegendFrame$SampleId),]
rownames(LegendFrameSorted)=NULL
sampleNames=c("B_DC","A_DC","C_DC","C3DC","C2DC","DC0904","DC0907","C3DCLPS","C_DC_LPS","A_DC_LPS","B_DC_LPS","C2DCLPS","DCLPS0910","DCLPS0913")
MX<-data.matrix(subset(joined,  select=sampleNames))
MX2<-MX
#MX2=MX2[,order(LegendFrame$Group,LegendFrame$SampleId)]
cluster=TRUE
if(dim(MX)[1]==1){MX2=t(MX2); cluster=FALSE}
annotations=data.frame(
  LPS_Treatment=factor(c("LPS_no", "LPS_no", "LPS_no", "LPS_no", "LPS_no", "LPS_no", "LPS_no", "LPS_yes", "LPS_yes", "LPS_yes", "LPS_yes", "LPS_yes", "LPS_yes", "LPS_yes"))  ,
         row.names=c(sampleNames)
)


#rownames(annotation)=c("B_DC", "A_DC", "C_DC", "C3DCLPS", "C_DC_LPS", "A_DC_LPS", "B_DC_LPS", "C3DC", "C2DCLPS", "C2DC", "DCLPS0910", "DCLPS0913", "DC0904", "DC0907")
rownames(MX2) = apply(subset(joined,select=c("gene")),1, function(x) x)
as.data.frame(LegendFrameSorted[,-2]) -> legend
row.names(legend)=LegendFrameSorted$SampleId
# re-label Annotation to "Group"
colnames(legend) <- "Group"
#Replace infinite values with NAs:
is.na(MX2) <- sapply(MX2, is.infinite)

# Exclude NAs from table, they cause this cryptic error message: Error in do_one(nmeth) : NA/NaN/Inf in foreign function call 
MX2<-MX2[complete.cases(MX2),]

# Plot the heatmap:
pheatmap(MX2,
         cluster_rows=TRUE,cluster_cols = FALSE,
         border_color="NA", 
         #filename = "/Users/fac2003/R_RESULTS/model/plot_UQVETJSCUB_5.png",
         color = colorRampPalette(c("red","green"))(100), 
         clustering_distance_rows="manhattan",
         clustering_distance_cols="manhattan",
         clustering_method="complete",members = NULL,
         kmeans_k = NA,breaks = NA, fontsize=6,
         show_colnames=T,
         annotation=annotations,
         cellwidth = 8, cellheight = 6, fontsize_row=6, scale = "row",
         Legend=TRUE
)
}
, warning = function(w) {
cat(paste("Node STATEMENT_EXECUTED/7676436067297094548/ generated the following warning: ",w,"\n"));
}
, error = function(e) {
cat(paste("Node STATEMENT_EXECUTED/7676436067297094548/ generated the following error: ",e,"\n"));
stop();
}
, finally = {
cat("STATEMENT_EXECUTED/7676436067297094548/\n");
}
)
}
png(file="/Users/fac2003/R_RESULTS/model/plot_UQVETJSCUB_5.png", width=400, height=500)
plot_UQVETJSCUB(joined)
ignore <- dev.off()
cat("STATEMENT_EXECUTED/7676436067297094548/\n");

# Layout plots in a grid:
plot_PSLLDQBXQR = function(ignore) 
{
#par(mfrow=c(1,1)) 
layout(matrix(c(1:1), byrow=TRUE, 1, 1), widths=c(400.0), heights=c(500.0))
 plot_UQVETJSCUB(joined)
}

png(file="/Users/fac2003/R_RESULTS/model/plot_PSLLDQBXQR_1.png", width=400.0, height=500.0)
plot_PSLLDQBXQR(null)
ignore <- dev.off()
cat("STATEMENT_EXECUTED/8025628038194132729/\n");

plot_NYPEQAMLRQ=function(t)
{
columns=c("A_DC","A_DC_LPS")
bDiscovery<-subset(joined, select=columns);
#cor(bDiscovery, use="complete.obs")

mDiscovery=lm(bDiscovery$"A_DC_LPS" ~ bDiscovery$"A_DC")
summary(mDiscovery)

#scatterplot(x = bDiscovery$"A_DC",y=bDiscovery$"A_DC_LPS",smoother = FALSE,
 #           legend.title="Gender",
# (no group)
          #  legend.coords="bottomright", boxplots=FALSE,
          #  xlab="", ylab="")


plot(main="", cex.main=2,
     x = bDiscovery$"A_DC",
     y=bDiscovery$"A_DC_LPS",
     xlab="", 
     ylab="", cex.lab=1.75)


abline(mDiscovery)
pValue<-summary.lm(mDiscovery)$coefficients[2,4]

mtext(adj=0,c(expression(r^2~adj.)))
mtext(adj=0.2,round(summary.lm(mDiscovery)$adj.r.squared,digits=3))
mtext(adj=0.8,paste("P-value:"))
mtext(adj=1.0,round(pValue,digits=3))

}


tryCatch({
png(file="/Users/fac2003/R_RESULTS/model/plot_NYPEQAMLRQ_6.png", width=500, height=500)
plot_NYPEQAMLRQ(joined)
ignore <- dev.off()
}
, warning = function(w) {
cat(paste("Node STATEMENT_EXECUTED/7676436067297112359/ generated the following warning: ",w,"\n"));
}
, error = function(e) {
cat(paste("Node STATEMENT_EXECUTED/7676436067297112359/ generated the following error: ",e,"\n"));
stop();
}
, finally = {
cat("STATEMENT_EXECUTED/7676436067297112359/\n");
}
)

tryCatch({
pdf("/Users/fac2003/R_RESULTS/model/heatmap.pdf", width=8, height=10, onefile=FALSE )
plot_UQVETJSCUB(joined)
ignore <- dev.off()
}
, warning = function(w) {
cat(paste("Node STATEMENT_EXECUTED/7676436067297101494/ generated the following warning: ",w,"\n"));
}
, error = function(e) {
cat(paste("Node STATEMENT_EXECUTED/7676436067297101494/ generated the following error: ",e,"\n"));
stop();
}
, finally = {
cat("STATEMENT_EXECUTED/7676436067297101494/\n");
}
)
#empty line

queryBiomart_7676436067297113396<- function(){

#retrieve the dataset to used associated to a database
output<-c();
thisDataset<- "mmusculus_gene_ensembl";
thisMart<-useMart("ENSEMBL_MART_ENSEMBL",dataset=thisDataset,host="www.ensembl.org");


attributes<-c("ensembl_gene_id","description");filtersVector=c();valuesList=c();




filtersVector<-c(filtersVector, "chromosome_name");valuesList<-c(valuesList,list(fromList="11"));
output<-getBM(attributes=attributes,mart=thisMart,filters=filtersVector,values=valuesList);

colnames(output)<-c("Ensembl_Gene_ID_from_feature","Description_from_feature")
return(data.table(output,key=colnames(output)));



#write.table(output,"/Users/fac2003/R_RESULTS/table_resultFromBioMart_0.tsv",row.names=FALSE,sep="\t");
}

tryCatch({

queryBiomart_7676436067297113396()->resultFromBioMart;
write.table(resultFromBioMart,"/Users/fac2003/R_RESULTS/model/table_resultFromBioMart_0.tsv", row.names=FALSE, sep="\t") 

}
, warning = function(w) {
cat(paste("Node STATEMENT_EXECUTED/7676436067297113396/ generated the following warning: ",w,"\n"));
}
, error = function(e) {
cat(paste("Node STATEMENT_EXECUTED/7676436067297113396/ generated the following error: ",e,"\n"));
stop();
}
, finally = {
cat("STATEMENT_EXECUTED/7676436067297113396/\n");
}
)




