#!/usr/bin/env nextflow


Channel.fromFilePairs( params.in ).into { fastq_files; fastq_files2 }
mpa_db = file(params.mpa_db)


println """\
         M E T A P H L A N     NEXTFLOW      PIPELINE   
         =====================================================
         input reads (--in)                  : ${params.in}
         outdir (--out)                      : ${params.out}
         Metaphlan Database (--mpa_db)       : ${params.mpa_db}

         """
         .stripIndent()


process fastqc {
    
    errorStrategy 'ignore'
    publishDir params.out, pattern: "*.html", mode: 'copy', overwrite: true

    input:
    set val(name), file(fastq) from fastq_files
 
    output:
    file "*_fastqc.{zip,html}" into qc_files, qc_files1

    """
    fastqc -q ${fastq}
    """
}

process multiqc {

    errorStrategy 'ignore'
    publishDir params.out, mode: 'copy', overwrite: true

    input:
    file reports from qc_files.collect().ifEmpty([])

    output:
    path "multiqc_report.html" into multiqc_output

    """
    multiqc $reports
    """
}


process mpa_fastq {

    //errorStrategy 'ignore'
    publishDir params.out, mode: 'copy', overwrite: true
    memory '8 GB'
    cpus 4
    input:
    tuple val(name), file(fastq) from fastq_files2

    output:
    file("*.txt") into mpa_fastq_out

    """
    metaphlan ${fastq[0]},${fastq[1]} --input_type fastq -o ${name}.txt --bowtie2out ${name}.bowtie2.bz2 --index mpa_v30_CHOCOPhlAn_201901 --bowtie2db ${mpa_db} -t rel_ab_w_read_stats
    """
}
