# busco

metashot/busco is a pipeline for assessing the quality of prokaryotic
and eukaryotic genomes using BUSCO.

*Note*: This workflow is not intended for classify "finished" genomes.
The "finished" category is reserved for genomes that can be assembled with
extensive manual review and editing.

- [MetaShot Home](https://metashot.github.io/)

## Main features

- Input: genomes in FASTA format;
- Basic assembly statistics using BBTools;
- Assessing genome completeness and contamination using BUSCO v4.

## Quick start

1. Install Docker (or Singulariry) and Nextflow (see
   [Dependencies](https://metashot.github.io/#dependencies));
1. Start running the analysis:
   
  ```bash
  nextflow run metashot/busco \
    --genomes '*.fa' \
    --outdir results
  ```
## Parameters

Parameters definitions are located in [`nextflow.config`](nextflow.config).

| Parameter | Default | Description |
| --------- | ------- | ----------- |
| `genomes` | `"data/*.fa"` | input genomes in FASTA format |
| `outdir` | `results` | output directory |
| `busco_db` | `none` | BUSCO download folder for offline mode (see https://busco.ezlab.org/busco_userguide.html#offline) |
| `lineage` | `auto` | lineage. It can be `auto`, `auto-prok`, `auto-euk`, a dataset name (e.g `bacteria` or `bacteria_odb10`) or a path (e.g. `/home/user/bacteria_odb10`) |
| `min_completeness` | `50` | discard sequences with less than 50% completeness |
| `max_contamination` | `10` | discard sequences with more than 10% contamination |

### Resource limits

| Parameter | Default | Description |
| --------- | ------- | ----------- |
| `max_cpus` | `8` | maximum number of CPUs for each process |
| `max_memory` | `32.GB` | maximum memory for each process |
| `max_time` | `24.h` | maximum time for each process |

See also [System
requirements](https://metashot.github.io/#system-requirements).

## Output
The files and directories listed below will be created in the `results`
directory after the pipeline has finished.

### Main outputs
- `genome_info.tsv`: summary of genomes quality (including completeness,
  contamination, N50, ...) in tab-separated format.
- `filtered`: genomes filtered by the `--min_completeness` and
  `--max_contamination` options; 

### Secondary outputs
- `busco`: contains the BUSCO short summaries and logs for each input genome;
- `statswrapper`: contains the original statistics file created by the
  BBTools `statswrapper.sh` command.

## Documetation

### Completeness and contamination
Completeness is defined as as 100 minus the fraction of missing BUSCOs and
contamination as the fraction of duplicated BUSCOs:

  ```
  completeness % = 100 x (1 - Missing / Total)

  contamination % = 100 x Duplicated / Complete
  ```

## Reproducibility
See [Reproducibility](https://metashot.github.io/#reproducibility).

## Credits
See [Credits](https://metashot.github.io/#credits).
