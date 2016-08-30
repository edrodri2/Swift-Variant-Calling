type file;

#################### Pipeline functions definition

# Alignment functions: BWA
app (file output) bwa (string read1, string read2, string INDEX, string bwamemparams, int PBSCORES,  string rgheader){
	"bwa" "mem" bwamemparams "-t" PBSCORES "-R" rgheader INDEX read1 read2 stdout=filename(output);
}

# SAMTOOLS
app (file output) samtools(file inputFile, int thr){
	"samtools" "view" "-@" thr "-bSu" filename(inputFile) stdout=filename(output);
}

#app (file output) novosort(string tempDir, int threads, file input){
#	 novosort "--index" "--tmpdir" tempDir "--threads" threads input stdout=filename(output);
#}

#app (file output) samblaster(string samblasterdir, string inputFilename){
#	samblasterdir "-M" inputFilename stdout=output;
#}

#app (file output) samtools_view(string samtoolsdir, file inputFilename, int thr, string u){
#	samtoolsdir "view" "-@" thr "-bS" u inputFilename @stdout=output;
#}

#app (file output) samtools_flagstat(string samtoolsdir, string inputFilename){
#	samtoolsdir "flagstat" inputFilename stdout=output;
#}

#app () samtools_index(string samtoolsdir, string inputFilename) {
#	samtoolsdir "index" inputFilename
#}


# Reading the runfile parameters:
(string[string] data) getConfigVariables(string lines[])
{
        foreach line in lines
        {
								if(strstr(line, "=") != -1)
								{
	                string keyValuePair[] = strsplit(line, "=");
	                string name = keyValuePair[0];
	                string value = keyValuePair[1];
	                data[name] = value;
								}
        }
}

string parametersFilename = arg("params", "runfile");
file configFile<SingleFileMapper; file=parametersFilename>;

string configFileLines[] = readData(filename(configFile));
string[string] vars = getConfigVariables(configFileLines);

file sampleInfoFile<SingleFileMapper; file = vars["SAMPLEINFORMATION"]>;
string sampleLines[] = readData(sampleInfoFile);

foreach sample in sampleLines{

	string sampleInfo[] = strsplit(sample, " ");
	string sampleName = sampleInfo[0];
	string read1 = sampleInfo[1];
	string read2 = sampleInfo[2];

	string rgheader = sprintf("@RG\tID:%s\tLB:%s\tPL:%s\tPU:%s\tSM:%s\tCN:%s\t", sampleName, vars["SAMPLELB"], vars["SAMPLEPL"], sampleName, sampleName, vars["SAMPLECN"]);

	file alignedsam<SingleFileMapper; file=strcat(vars["TMPDIR"],"/align/", sampleName, ".nodups.sam")>;
	alignedsam = bwa(read1, read2, vars["BWAINDEX"], vars["BWAMEMPARAMS"], toInt(vars["PBSCORES"]), rgheader);

	file alignedbam<SingleFileMapper; file=strcat(vars["OUTPUTDIR"],"/align/", sampleName, ".nodups.bam")>;
	alignedbam = samtools(alignedsam, toInt(vars["PBSCORES"]));

	#file sortedbam<SingleFileMapper; file=strcat(vars["OUTPUTDIR"],"/align/", sampleName, ".nodups.sorted.bam")>;
	#sortedbam = novosort(vars["TMPDIR"], toInt(vars["PBSCORES"], alignedbam)";
}
