#!/usr/bin/env nextflow

nextflow.enable.dsl=2

include { busco } from './modules/busco'

workflow {

    sequences_ch = Channel
        .fromPath( params.sequences )
        .map { file -> tuple(file.baseName, file) }

    lineage = file(params.lineage, type: 'file')
    busco_db = file(params.busco_db, type: 'dir')

    busco(sequences_ch, lineage, busco_db)
}
