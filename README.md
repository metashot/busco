# prok-quality

metashot/prok-quality is a pipeline for assessing the quality of prokaryotic
genomes including the prediction of rRNA and tRNA genes (in according to the
[MISAG and the MIMAG standards](https://doi.org/10.1038/nbt.3893).

*Note*: This workflow is not intended for classify "finished" SAGs or MAGs.
The "finished" category is reserved for genomes that can be assembled with
extensive manual review and editing.

- [MetaShot Home](https://metashot.github.io/)

## Main features

- Input: prokaryotic genomes in FASTA format;
- Completeness, contamination and strain heterogeneity estimates with
  [CheckM](https://ecogenomics.github.io/CheckM/);
- 5S, 23S and 16S prediction with [Barrnap](https://github.com/tseemann/barrnap);
- Transfer RNA (tRNA) prediction with [tRNAscan-SE](http://lowelab.ucsc.edu/tRNAscan-SE/);
- Filter genomes by their completeness and contamination values;
- An extended summary of genome quality (including the rRNA and tRNA genes
  found) is reported;
- Dereplication using [drep](https://github.com/MrOlm/drep).

## Quick start

1. Install Docker (or Singulariry) and Nextflow (see
   [Dependencies](https://metashot.github.io/#dependencies));
1. Start running the analysis:
   
  ```bash
  nextflow run metashot/prok-quality \
    --genomes '*.fa' \
    --outdir results
  ```

## Parameters
See the file [`nextflow.config`](nextflow.config) for the complete list of
parameters.

## Output
The files and directories listed below will be created in the `results`
directory after the pipeline has finished.

### Main outputs
- `genome_info.tsv`: summary of genomes quality (including completeness,
  contamination, N50, rRNA genes found, number of tRNA and tRNA types). This
  file contains:
  - Genome: genome filename
  - Completeness, Contamination, ..., # predicted genes: summary of genome
    quality (see
    https://github.com/Ecogenomics/CheckM/wiki/Genome-Quality-Commands#qa);
  - 5S rRNA, 23S rRNA, 16S rRNA**: Yes if the rRNA gene was found;
  - \# tRNA, \# tRNA types: the number of tRNA and the number of the tRNA
       types found, respectively.
- `filtered`: genomes filtered by the `--min_completeness` and
  `--max_contamination` options; 
- `derep_info.tsv`: dereplication summary (if `--skip_dereplication=false`).
  This file contains:
  - Genome: genome filename
  - Cluster: the cluster ID (from 0 to N-1)
  - Representative: is this genome the cluster representative?
- `filtered_repr`: representative genomes (if `--skip_dereplication=false`).

### Secondary outputs
- `checkm`: contains the original checkm's qc file;
- `barrnap`: GFF and FASTA files containing the predicted rRNA sequences for
  bacteria (`.bac`) and archea (`.arc`) models;
- `trnascan_se`: TSV and FASTA files containing the predicted tRNA sequences for
  bacteria (`.bac`) and archea (`.arc`) models;
- `drep`: original data tables, figures and log of drep.

## Documetation

### MIMAG/MISAG standards
Following MIMAG/MISAG standards, you can classify a prokaryotic genome as
**high-quality draft** when:
- its completeness is >90% and the contamination is <5%;
- 23S, 16S, and 5S rRNA genes can be predicted;
- at least 18 tRNA types can be predicted.

A genome can be classified as **medium-quality draft** when its completeness is
\>=50% and the contamination is <10%.

### Dereplication
For each cluster, the genome with the higher score is selected as
representative. The score is computed using the following formula:

  ```
  score = completeness - 5 x contamination + 0.5 x log(N50)
  ```
By default the dereplication is performed with the species-level ANI threshold
(0.95, parameter `--ani_thr`).

## System requirements
Please refer to [System
requirements](https://metashot.github.io/#system-requirements) for the complete
list of system requirements options.

### Memory
CheckM requires approximately 40 GB of memory. However, if you have only 16 GB
RAM, a reduced genome tree (`--reduced_tree` option) can also be used (see
https://github.com/Ecogenomics/CheckM/wiki/Installation#system-requirements).

### Disk
For each GB of input data the workflow requires approximately 0.5/1 GB for the
final output and 2 GB for the working directory.