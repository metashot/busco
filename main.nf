#!/usr/bin/env nextflow

nextflow.enable.dsl=2

include { busco } from './modules/busco'
include { statswrapper } from './modules/bbtools'
include { genome_info; genome_filter } from './modules/utils'

workflow {

    genomes_ch = Channel
        .fromPath( params.genomes )
        .map { file -> tuple(file.baseName, file) }

    lineage = file(params.lineage, type: 'file')
    busco_db = file(params.busco_db, type: 'dir')

    genomes_only_ch = genomes_ch
        .map { row -> row[1] }

    busco(genomes_ch, lineage, busco_db)
    statswrapper(genomes_only_ch.collect())
    genome_info(busco.out.summary.collect(), statswrapper.out.stats)
    genome_filter(genome_info.out.table, genomes_only_ch.collect())

}
