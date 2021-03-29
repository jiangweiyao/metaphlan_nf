#!/usr/bin/env nextflow


Channel.fromFilePairs( params.in ).into { fastq_files; fastq_files2 }
params.bp_right = 100

println """\
         TRIM BASES FROM THE RIGHT USING SeqTK   NEXTFLOW    PIPELINE   
         ============================================================
         input reads (--in)                  : ${params.in}
         outdir (--out)                      : ${params.out}
         trimbasesright (--bp_right)         : ${params.bp_right}

         """
         .stripIndent()


process seqtk {
    
    //errorStrategy 'ignore'
    publishDir params.out, pattern: "*.fastq", mode: 'copy', overwrite: true

    input:
    set val(name), file(fastq) from fastq_files
 
    output:
    file "*.fastq" into qc_files, qc_files1

    """
    seqtk trimfq -e ${params.bp_right} ${fastq[0]} > ${name}_R1.fastq
    seqtk trimfq -e ${params.bp_right} ${fastq[1]} > ${name}_R2.fastq
    """
}
