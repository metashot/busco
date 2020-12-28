#!/usr/bin/env nextflow

nextflow.enable.dsl=2

include { busco } from './modules/busco'

workflow {

    genomes_ch = Channel
        .fromPath( params.genomes )
        .map { file -> tuple(file.baseName, file) }

    lineage = file(params.lineage, type: 'file')
    busco_db = file(params.busco_db, type: 'dir')

    busco(genomes_ch, lineage, busco_db)
    statswrapper(genomes_ch.collect())
    genome_info(busco.out.summary.collect(), statswrapper.out.stats)
    genome_filter(genome_info.out.table,
                  genomes_ch.map { row -> row[1] }.collect())

}
