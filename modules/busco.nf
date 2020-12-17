nextflow.enable.dsl=2

process busco {
    tag "${id}"

    publishDir "${params.outdir}/busco" , mode: 'copy'

    input:
    tuple val(id), path(sequences)
    path (lineage)
    path (busco_db)

    output:
    path "${id}"

    script:
    if( params.lineage == 'auto' ) {
        param_auto_lineage = '--auto-lineage'
        param_lineage_dataset = ''
    }
    else if ( params.lineage == 'auto-prok' ) {
        param_auto_lineage = '--auto-lineage-prok'
        param_lineage_dataset = ''
    }
    else if ( params.lineage == 'auto-euk' ) {
        param_auto_lineage = '--auto-lineage-euk'
        param_lineage_dataset = ''
    }
    else {
        param_auto_lineage = ''
        param_lineage_dataset = "-l ${params.lineage}"
    }

    if( params.busco_db == 'none' ) {
        param_offline = ''
        param_download_path = ''
    }
    else {
        param_offline = '--offline'
        param_download_path = "--download_path ${params.busco_db}"
    }

    """
    busco \
        -i ${sequences} \
        -o ${id} \
        -m ${params.mode} \
        ${param_lineage_dataset} \
        ${param_auto_lineage} \
        ${param_offline} \
        ${param_download_path} \
        --cpu ${task.cpus}
    """
}
