# Generated with MetaR, http://metaR.campagnelab.org, from script "Script" on Thu Feb 18 10:17:23 EST 2016


libDir<-"/Users/fac2003/.metaRlibs"
 dir.create(file.path(libDir),showWarnings=FALSE,recursive=TRUE)
 .libPaths(c(libDir))
 dir.create(file.path("/Users/fac2003/R_RESULTS/model"),showWarnings=FALSE,recursive=TRUE)
 

 

 if(!(require("limma")|require("edgeR"))){if(!require("BiocInstaller")){source("http://bioconductor.org/biocLite.R",local=TRUE)}
 biocLite(ask=FALSE,c("limma","edgeR"))
 library("limma")
 library("edgeR")}



queryBiomart_7676436067297133378<- function(){

#retrieve the dataset to used associated to a database
output<-c();
thisDataset<- "mmusculus_gene_ensembl";
thisMart<-useMart("ENSEMBL_MART_ENSEMBL",dataset=thisDataset,host="www.ensembl.org");


attributes<-c("percentage_gc_content");filtersVector=c();valuesList=c();




filtersVector<-c(filtersVector, "transcript_appris");valuesList<-c(valuesList,list(fromBoolean=FALSE));
output<-getBM(attributes=attributes,mart=thisMart,filters=filtersVector,values=valuesList);

colnames(output)<-c("percent_GC_content_from_feature")
return(data.table(output,key=colnames(output)));



#write.table(output,"/Users/fac2003/R_RESULTS/table_resultFromBioMart_0.tsv",row.names=FALSE,sep="\t");
}

queryBiomart_7676436067297133378()->resultFromBioMart;
write.table(resultFromBioMart,"/Users/fac2003/R_RESULTS/model/table_resultFromBioMart_0.tsv", row.names=FALSE, sep="\t") 

cat("STATEMENT_EXECUTED/7676436067297133378/\n");




