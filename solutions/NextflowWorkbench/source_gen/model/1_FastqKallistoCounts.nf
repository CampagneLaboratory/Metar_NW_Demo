#!/usr/bin/env nextflow
_sampleIds = ['SRR1514132', 'SRR1514133', 'SRR1514134', 'SRR1514135', 'SRR1514136', 'SRR1514137', 'SRR1514138', 'SRR1514139', 'SRR1514140', 'SRR1514141'].channel()
(_IDsToDownload,_IDsToCombine) = _sampleIds.separate(2) { a -> [a,a] }
process Sample_Download_1000_Reads {
container 'inutano/sra-toolkit:latest'

input:
val id from _IDsToDownload

output:
set file('*_1.fastq.gz'), file('*_2.fastq.gz') into _reads

shell:

    '''

fastq-dump -X 1000 --split-files !{id}
gzip !{id}_*.fastq

    '''
}
(_A,_B) = _reads.separate(2) { a -> [a,a] }
process Sample_QC {
container 'genomicpariscentre/fastqc:latest'

input:
set file(read1), file(read2) from _A

output:
file '*.zip' into _zip

shell:

    '''
fastqc !{read1} !{read2}
ls -ltr 


    '''
}
process Sample_KallistoCountsWithTuples {
container 'artifacts/kallisto-homo-sapiens:1.0.0'

input:
set file(read1), file(read2) from _B

output:
file 'counts-*.tsv' into _result

shell:
'''
source $HOME/.bashrc \
&& RESOURCE_OWNER=nyosh \
&& ATTRIBUTES=  \
&& echo "Checking/installing resource BASH_LIBRARY:1.0" \
&& ATTRIBUTES+="" \
&& echo "Checking/installing resource FETCH_URL:1.2" \
&& ATTRIBUTES+="" \
&& echo "Checking/installing resource KALLISTO:0.42.3" \
&& ATTRIBUTES+="" \
&& echo "Checking/installing resource ENSEMBL_TRANSCRIPTS:1.0" \
&& echo "  with attribute ENSEMBL_TRANSCRIPTS.TOPLEVEL.organism=HOMO_SAPIENS" \
&& echo "  with attribute ENSEMBL_TRANSCRIPTS.TOPLEVEL.reference-build=GRCH38" \
&& echo "  with attribute ENSEMBL_TRANSCRIPTS.TOPLEVEL.ensembl-version-number=82" \
&& ATTRIBUTES+="--attribute-value ENSEMBL_TRANSCRIPTS.TOPLEVEL.organism=Homo_sapiens --attribute-value ENSEMBL_TRANSCRIPTS.TOPLEVEL.reference-build=GRCH38 --attribute-value ENSEMBL_TRANSCRIPTS.TOPLEVEL.ensembl-version-number=82 " \
&& echo "Checking/installing resource KALLISTO_INDEX:0.42.3" \
&& echo "  with attribute KALLISTO_INDEX.INDEX.organism=HOMO_SAPIENS" \
&& echo "  with attribute KALLISTO_INDEX.INDEX.reference-build=GRCH38" \
&& echo "  with attribute KALLISTO_INDEX.INDEX.ensembl-version-number=82" \
&& ATTRIBUTES+="--attribute-value KALLISTO_INDEX.INDEX.organism=Homo_sapiens --attribute-value KALLISTO_INDEX.INDEX.reference-build=GRCH38 --attribute-value KALLISTO_INDEX.INDEX.ensembl-version-number=82 " \
&& plugins-submit-job --plugins-dir $PLUGINS_ROOT_LOCATION --job-tag YSJBLPY --job-area $JOB_AREA --fileset-area $FILESET_AREA --owner $RESOURCE_OWNER --env-script $PLUGINS_ROOT_LOCATION/artifacts-config/env.sh $ATTRIBUTES --repository  $REPOSITORY_DIR --resource BASH_LIBRARY:1.0 --resource FETCH_URL:1.2 --resource KALLISTO:0.42.3 --resource ENSEMBL_TRANSCRIPTS:1.0 --resource KALLISTO_INDEX:0.42.3  > /dev/null 2>&1 \
&& export JOB_DIR=$JOB_AREA/$RESOURCE_OWNER/Y/YSJBLPY > /dev/null 2>&1 \
&& source $JOB_AREA/$RESOURCE_OWNER/Y/YSJBLPY/auto-options.sh > /dev/null 2>&1 \
&& source $JOB_AREA/$RESOURCE_OWNER/Y/YSJBLPY/exports-all.sh > /dev/null 2>&1 \
&& export ENSEMBL_TRANSCRIPTS_TOPLEVEL_ORGANISM_VALUE=HOMO_SAPIENS \
&& export ENSEMBL_TRANSCRIPTS_TOPLEVEL_REFERENCE_BUILD_VALUE=GRCH38 \
&& export ENSEMBL_TRANSCRIPTS_TOPLEVEL_ENSEMBL_VERSION_NUMBER_VALUE=82 \
&& export KALLISTO_INDEX_INDEX_ORGANISM_VALUE=HOMO_SAPIENS \
&& export KALLISTO_INDEX_INDEX_REFERENCE_BUILD_VALUE=GRCH38 \
&& export KALLISTO_INDEX_INDEX_ENSEMBL_VERSION_NUMBER_VALUE=82 \
&& echo 
echo "Processing: " !{read1}
TRANSCRIPT_INDEX=$(eval echo \\${RESOURCES_ARTIFACTS_KALLISTO_INDEX_INDEX_${KALLISTO_INDEX_INDEX_ORGANISM_VALUE}_${KALLISTO_INDEX_INDEX_REFERENCE_BUILD_VALUE}_${KALLISTO_INDEX_INDEX_ENSEMBL_VERSION_NUMBER_VALUE}})/transcripts_index
echo ${TRANSCRIPT_INDEX}
basename=`basename !{read1}`
echo "Basename= ${basename}"

mkdir output
$(eval echo \\${RESOURCES_ARTIFACTS_KALLISTO_BINARIES})/bin/kallisto quant --index=${TRANSCRIPT_INDEX} !{read1} !{read2} --output-dir=./output 
#touch output/abundance.tsv
ls -ltrR .
cp output/abundance.tsv counts-${basename}.tsv
exit 0
'''
}
process Sample_CombineCounts {
container 'fac2003/rocker-metar:latest'

input:
file tsvs from _result.toList()
val ids from _IDsToCombine.toList()

output:
file 'counts.tsv' into _combined

shell:
"""
cat << EOF > script6468360660610072140.R
# SCRIPT adapted from http://andrewtmckenzie.com/2015/05/12/how-to-run-kallisto-on-ncbi-sra-rna-seq-data-for-differential-expression-using-the-mac-terminal/ 
if (!require("BiocInstaller")) {
  # Install bioconductor packages:
  source("http://bioconductor.org/biocLite.R", local=TRUE)
  biocLite(ask=FALSE, c("limma")) 
}
if (!require("limma")) {install.packages("limma",repos='http://cran.us.r-project.org'); library("limma")}

# arguments contain the paths to tsv files 
args =  commandArgs(trailingOnly = TRUE)
sample_filenames<-args
sample_list_ids <- args
for(i in 1:length(sample_filenames)){
# extract identifiers from the filenames:
  sample_list_ids[i]<-gsub(sample_list_ids[i], pattern="counts-", replacement="");
  sample_list_ids[i]<-gsub(sample_list_ids[i], pattern=".tsv", replacement="");
}

for(i in 1:length(sample_list_ids)){
    cat("loading: "); cat(sample_filenames[i])
    tmp = read.table(file = sample_filenames[i], header = TRUE) 
    assign(sample_list_ids[i], tmp)
}
 
sample_list = mget(sample_list_ids)
 
#give the list unique names 
sample_list_uni = Map(function(x, i) setNames(x, ifelse(names(x) %in% "target_id",
      names(x), sprintf('%s.%d', names(x), i))), sample_list, seq_along(sample_list))
 
full_kalli = Reduce(function(...) merge(..., by = "target_id", all=T), sample_list_uni)
 
counts = full_kalli[, grep("est_counts", names(full_kalli))]
# set identifiers as column names on the combined table:
names(counts) <- sample_list_ids;
# transfer gene ids. Note the quotes around target_id are needed to prevent nextflow replacement.
row.names(counts) <- full_kalli\$"target_id";
# write the table
write.table(x=counts, file="counts.tsv", quote=FALSE, sep='\t', col.names = NA)


EOF
Rscript script6468360660610072140.R ${tsvs}
"""
}
workflow.onComplete {
println "Workflow execution summary"
println "---------------------------"
println "Workflow completed at: $workflow.complete"
println "Duration: ${workflow.duration}"
println "Execution status: ${ workflow.success ? 'OK' : 'failed' }"
if (!  workflow.success) {
println "Error message: $workflow.errorMessage"
}
println "Files generated by the execution are available in $workflow.workDir"
println "---------------------------"
}
