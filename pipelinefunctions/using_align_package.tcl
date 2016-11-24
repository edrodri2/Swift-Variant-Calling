#!/usr/bin/env tclsh

lappend auto_path /home/azza/swift-project/Swift-Variant-Calling/pipelinefunctions/Tclfunctions

package require align 0.0

set index /home/azza/swift-project/Workshop_low_pass/ref/human_g1k_v37_chr20.fa
set R1 /home/azza/swift-project/Dataset/HG00108.lowcoverage.chr20.smallregion_1.fastq
set R2 /home/azza/swift-project/Dataset/HG00108.lowcoverage.chr20.smallregion_2.fastq
set rgheader  {@RG\tID:synthetic\tLB:synthetic\tPL:illumina\tPU:synthetic\tSM:synthetic\tCN:synthetic}
set bwadir {/usr/bin/bwa}


eval bwa $bwadir $index $R1 $R2 $rgheader -t 2 -M

#proc samtools_view {thr file args} {
#	exec /usr/local/bin/samtools view -@ $thr -bS $args file >tmp.bam
#}


##### Working with pipes:
#set pipe [open "|/usr/bin/bwa mem $index $R1 $R2 -R $rgheader tmp.sam" RDWR ]

#fconfigure $pipe -blocking 0 -buffering none; #
#fileevent $pipe readable [puts "bwa is done!"]

