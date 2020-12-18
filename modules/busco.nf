nextflow.enable.dsl=2

process busco {
    tag "${id}"

    publishDir "${params.outdir}/busco" , mode: 'copy'

    input:
    tuple val(id), path(sequences)
    path (lineage)
    path busco_db, stageAs: 'busco_downloads'

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
    }
    else {
        param_offline = '--offline'
    }

    """
    set +e
    BUSCO_EXIT=0
    trap 'BUSCO_EXIT=\$?' ERR
    busco \
        -i ${sequences} \
        -o ${id} \
        -m ${params.mode} \
        ${param_lineage_dataset} \
        ${param_auto_lineage} \
        ${param_offline} \
        --cpu ${task.cpus}


    AUGUSTUS_ERR_STR="SystemExit: Augustus did not recognize any genes"
    PLACEMENTS_ERR_STR="SystemExit: Placements failed"
    BUSCO_LOG=${id}/logs/busco.log
    if [ "\$BUSCO_EXIT" -eq 1 ] && [ -f \$BUSCO_LOG ]; then
        grep -Fq "\${AUGUSTUS_ERR_STR}" \$BUSCO_LOG
        AUGUSTUS_ERR=\$?
        grep -Fq "\${PLACEMENTS_ERR_STR}" \$BUSCO_LOG
        PLACEMENTS_ERR=\$?
        if [ "\$AUGUSTUS_ERR" -eq 0 ] || [ "\$PLACEMENTS_ERR" -eq 0 ]; then
            exit 0
        else
            exit 1
        fi
    else
        exit \$BUSCO_EXIT  
    fi
    """
}
