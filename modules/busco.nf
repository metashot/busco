nextflow.enable.dsl=2

process busco {
    tag "${id}"

    publishDir "${params.outdir}/busco" , mode: 'copy'

    input:
    tuple val(id), path(genome)
    path (lineage)
    path busco_db, stageAs: 'busco_downloads'

    output:
    path "${id}"
    path "${id}/short_summary.specific.*.${id}.txt", optional: true, emit: summary_specific

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
    BUSCO_LOG=${id}/logs/busco.log
    
    NO_ERR_S1='SystemExit: Augustus did not recognize any genes'
    NO_ERR_S2='SystemExit: Placements failed'

    set +e
    busco \
        -i ${genome} \
        -o ${id} \
        -m genome \
        ${param_lineage_dataset} \
        ${param_auto_lineage} \
        ${param_offline} \
        --cpu ${task.cpus}
    BUSCO_EXIT=\$?
      
    if [ "\$BUSCO_EXIT" -eq 1 ] && [ -f \$BUSCO_LOG ]; then    
        grep -q "\${NO_ERR_S1}|\${NO_ERR_S2}" \$BUSCO_LOG
        if [ "\$?" -eq 0 ]; then
            exit 0
        fi
    fi

    exit \$BUSCO_EXIT
    """
}
