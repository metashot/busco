# busco

metashot/busco is a pipeline for assessing the quality of prokaryotic
and eukaryotic genomes using BUSCO.

*Note*: This workflow is not intended for classify "finished" genomes.
The "finished" category is reserved for genomes that can be assembled with
extensive manual review and editing.

- [MetaShot Home](https://metashot.github.io/)

## Main features

- Input: prokaryotic genomes in FASTA format;
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
| `min_completeness` | 50 | discard sequences with less than 50% completeness |
| `max_contamination` | `"data/*.fa"` | discard sequences with more than 10% contamination |

### Resource limits

| Parameter | Default | Description |
| --------- | ------- | ----------- |
| `max_cpus` | 8 | maximum number of CPUs for each process |
| `max_memory` | 32.GB | maximum memory for each process |
| `max_time` | 48.h | maximum time for each process |

See also [System
requirements](https://metashot.github.io/#system-requirements).

## Output
The files and directories listed below will be created in the `results`
directory after the pipeline has finished.

### Main outputs
TODO

