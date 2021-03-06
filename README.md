# Variant Calling Workflow in Swift #
## Problem statement ##

Our goal is to create a reasonably flexible variant calling workflow in swift with the following features:

1. Able to run on multiple clusters, so we could support work with different collaborators, such as
  1. mForge - OGE - Mayo
  2. Blue Waters - Cray aprun + PBS Torque - to enable us to run large scale projects and bring lots of $$$
  3. biocluster - Slurm - to serve HPCBio clients
  4. standalone servers - ? no scheduler ? - individual H3A labs
2. enable user to specify which software alternatives to use for each step of the workflow, such as
  1. BWA-MEM vs novoalign for alignment
  2. samtools vs sambamba for SAM/BAM conversion
  3. novosort vs Picard vs samblaster for marking of duplicates
  4. UnifiedGenotyper vs HaplotypeCaller for variant calling
3. enable user to choose workflow configuration, such as
  1. align only or
  2. realign only or
  3. variant calling only or
  4. align + realign + variant calling together or
  5. align + realign only or
  6. realign + variant calling only
4. enable user to choose the kind of data analysis:
  1. input data are multiplexed vs 1 sample/lane
  2. analyze samples individually or joint calling (? obsolete ? ); or do GenotypeGVCF in the end

The current Bash-based workflow has all of the above, except for the ability to run on different clusters.
Also, it is difficult to maintain, such that introducing new features is very laborious.
Documentation is equally difficult. Those are the factors that drove us to explore Swift as a replacement for Bash glue.
## Usage ##
In order to run our workflow
