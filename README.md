# MetaPhlAn3 Pipeline in Nextflow

### Dependencies:
1. [Nextflow](https://www.nextflow.io/)
2. [Singularity](https://sylabs.io/docs/) - if you are running this on a cluster, please install version 3.6 or later. 

### Usage: 
Test the full pipeline with prepackaged data:
```
nextflow run metaphlan_nf/main.nf 
```

You can change the input parameter (--in) to point to your input paired fastq files, the output parameter (--out) to the output directory, and the reference metaphlan3 database location (--mpa_db). The command above use default parameters and is equivalent to 
```
nextflow run metaphlan_nf/main.nf --in="metaphlan_nf/fastq/**/*{1,2}.fastq.gz" --out="~/mpa-out" --mpa_db="/scicomp/reference/metaphlan3"
```

You can get a log for the run using the following -with-report option.
```
nextflow run metaphlan_nf/main.nf -with-report report.html
```

Use the configuration file to run on the SGE system in SCBS
```
nextflow run metaphlan_nf/main.nf -c metaphlan_nf/cdc_sge.config
```

### Resuming the workflow
If your workflow is interrupted, you can resume it by running the same command with -resume after it to reuse the already successfully executed steps. For example:
```
nextflow run metaphlan_nf/main.nf -resume
```

### Common Input Patterns:
Files will be searched against the glob expression for the input argument (i.e. --in="metaphlan_nf/fastq/**/*{1,2}.fastq.gz")
Common patterns include:
1. --in="<path>/*{1,2}.fastq.gz" for paired SRA files
2. --in="<path>/*{R1_001,R2_001}.fastq.gz" for paired Illumina files

You can find all files in subfolders of a directory using the following expression:
--in="<path>/**/*{R1_001,R2_001}.fastq.gz"

You can determine which files match the glob pattern using the include filepair_finder.nf workflow before you run the workflow on your actual files. You can try running this against the included fastq files using the following command:
```
nextflow run metaphlan_nf/filepair_finder.nf --in='metaphlan_nf/fastq/**/*{1,2}.fastq.gz'
```

### Common problems
This workflow will dynamically download the docker images for the processes and the large reference files at first running. Network interruptions or firewalls can block the download. We recommend running the workflow with the include file the first time you run this workflow to download everything. If a docker image pull is unsuccessful, try resuming the run again to see if the docker image can be downloaded successfully.
