/////// Alignment functions:
@dispatch=WORKER
app (file output) bwa_mem (string bwadir, string read1, string read2, string INDEX, string bwamemparams[], int PBSCORES,  string rgheader){
	bwadir "mem" "-M" bwamemparams "-t" PBSCORES "-R" rgheader INDEX read1 read2 @stdout=output;
}

@dispatch=WORKER
app (file output) novoalign (string novoaligndir, string read1, string read2, string INDEX, string novoalignparams[], int PBSCORES, string rgheader) {
	novoaligndir "-c" PBSCORES "-d" INDEX "-f" read1 read2 "-o" "SAM" rgheader @stdout=output; 
}

@dispatch=WORKER
app (file output) samtools_view(string samtoolsdir, file inputFile, int thr, string args[]){
	// Converting sam to bam
	samtoolsdir "view" "-@" thr "-bS" inputFile args @stdout=output;
}

// Counting the number of alignments
@dispatch=WORKER
(int numAlignments) samtools_view2(string samtoolsdir, string inputFile)
	"align" "0.2" [	
	"set <<numAlignments>> [ alignment::samtools_view <<samtoolsdir>> <<inputFile>> ]"
];

@dispatch=WORKER
app (file output) samblaster(string samblasterdir, file inputFile){
	samblasterdir "-M" "-i" inputFile @stdout=output;
}

@dispatch=WORKER
app (file output) novosort (string novosortdir, file inputFile, string tmpdir, int thr, string sortoptions[]){
	// processing a single file (sorting and indexing input)
	novosortdir "--index" "--tmpdir" tmpdir "--threads" thr inputFile "-o" output sortoptions; 
	// novosort has dual function to also mark duplicates
}

@dispatch=WORKER
app (file output) novosort (string novosortdir, string inputFile[], string tmpdir, int thr, string sortoptions[]){
	// processing multi-input files together (merging files)
	novosortdir "--index" "--tmpdir" tmpdir "--threads" thr inputFile "-o" output; 
	// novosort has dual function to also mark duplicates
}
@dispatch=WORKER
app (file outputfile, file metricsfile) picard (string javadir, string picarddir, string tmpdir, file inputFile ){
        javadir "-Xmx8g" "-jar" picarddir "MarkDuplicates" "INPUT=" inputFile "OUTPUT=" outputfile "METRICS_FILE=" metricsfile "TMP_DIR=" tmpdir "ASSUME_SORTED=true" "MAX_RECORDS_IN_RAM=null" "CREATE_INDEX=true" "VALIDATION_STRINGENCY=SILENT";

}

@dispatch=WORKER
app (file output) samtools_flagstat(string samtoolsdir, file inputFile){
	samtoolsdir "flagstat" inputFile @stdout=output;
}

