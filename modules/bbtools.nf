nextflow.enable.dsl=2


process statswrapper {      

        publishDir "${params.outdir}/statswrapper" , mode: 'copy'

        input:
        path(genomes)

        output:
        path("stats.tsv"), emit: stats

        script:       
        """
        statswrapper.sh *.fa > stats.tsv
        """
}
