nextflow.enable.dsl=2


process genome_info {      
    publishDir "${params.outdir}" , mode: 'copy' ,
        pattern: 'genome_info.tsv'

    input:
    path(summaries)
    path(stats)
   
    output:
    path 'genome_info.tsv', emit: table 

    script:
    """
    mkdir summaries_dir
    mv $summaries summaries_dir
    genome_info.py \
        summaries_dir \
        $stats \
        genome_info.tsv
    """
}


process genome_filter {
    publishDir "${params.outdir}" , mode: 'copy'

    input:
    path 'genome_info.tsv'
    path(genomes)

    output:
    path 'filtered/*'
    
    script:   
    """
    mkdir genomes_dir
    mv $genomes genomes_dir
    genome_filter.py \
        genome_info.tsv \
        genomes_dir \
        filtered \
        ${params.min_completeness} \
        ${params.max_contamination}
    """
}
