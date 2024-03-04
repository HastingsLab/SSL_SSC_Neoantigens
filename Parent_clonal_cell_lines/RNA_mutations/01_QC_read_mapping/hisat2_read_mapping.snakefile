#! importing join
from os.path import join

# aligning files with HISAT2, sorting and indexing BAM files with Samtools.

# Tools
HISAT2 = "hisat2"
SAMTOOLS = "samtools"

# Directories
FQ_DIR = "/scratch/eknodel/SCC_samples/cell_lines/RNAseq/trimmed_fastqs/" # path to directory with trimmed FASTQ files
SAM_AL_DIR = "/scratch/eknodel/SCC_samples/cell_lines/RNAseq/sam/" # path to directory for SAM alignment files
BAM_AL_DIR = "/scratch/eknodel/SCC_samples/cell_lines/RNAseq/bam/" # path to directory for BAM alignment files
SORTED_BAM_AL_DIR = "/scratch/eknodel/SCC_samples/cell_lines/RNAseq/sorted_bam/" # path to directory for sorted BAM alignment files

# Samples
SAMPLES = ["185-1-5c-01-F11-6-26-21-1_216_361_S9_L003", "188-2-5c-05-F11-6-22-21_274_303_S20_L003", "244-1-chu-06-D12-7-9-21-1_284_293_S35_L003",
           "185-1-5c-01-F11-6-26-21-2_204_373_S10_L003", "188-2-5c-05-F11-6-3-21_239_338_S15_L003",    "244-1-chu-06-D12-7-9-21-2_272_305_S36_L003",
           "185-1-5c-01-F11-6-26-21-3_287_290_S11_L003", "188-2-5c-05-F11-6-6-21_227_350_S16_L003",    "244-chu-06-F5-6-26-21_285_292_S27_L003",
           "185-1-5c-01-F11-6-26-21-4_275_302_S12_L003", "188-2-5c-05-F11-6-9-21_215_362_S17_L003",    "244-chu-06-F5-7-2-21-1_273_304_S28_L003",
           "185-1-5c-01-F11-6-26-21-5_263_314_S13_L003", "244-1-chu-02-B7-6-11-21_226_351_S24_L003",   "244-chu-06-F5-7-2-21-2_261_316_S29_L003",
           "185-1-5c-01-F11-6-26-21-6_251_326_S14_L003", "244-1-chu-02-B7-6-15-21_214_363_S25_L003",   "244-chu-06-F5-7-2-21-3_249_328_S30_L003",
           "185-15c-09-G9-6-11-21_252_325_S6_L003",      "244-1-chu-02-B7-6-22-21_202_375_S26_L003",   "244-chu-06-F5-7-9-21-1_237_340_S31_L003",
           "185-15c-09-G9-6-15-21_240_337_S7_L003",      "244-1-chu-02-B7-6-3-21_262_315_S21_L003",    "244-chu-06-F5-7-9-21-2_225_352_S32_L003",
           "185-15c-09-G9-6-22-21_228_349_S8_L003",      "244-1-chu-02-B7-6-6-21_250_327_S22_L003",
           "185-15c-09-G9-6-3-21_288_289_S3_L003",       "244-1-chu-02-B7-6-9-21_238_339_S23_L003",
           "185-15c-09-G9-6-6-21_276_301_S4_L003",       "244-1-chu-06-D12-6-22-21_213_364_S33_L003",
           "185-15c-09-G9-6-9-21_264_313_S5_L003",       "244-1-chu-06-D12-6-26-21_201_376_S34_L003",
           "188-2-5c-05-F11-6-11-21_203_374_S18_L003",   "244-1-chu-06-D12-7-12-21-1_260_317_S37_L003",
           "188-2-5c-05-F11-6-15-21_286_291_S19_L003",   "244-1-chu-06-D12-7-12-21-2_248_329_S38_L003"]

rule all:
	input:
		# Defining the files that snakemake will attempt to produce as an output.
		# If there is no rule defined to produce the file, or if the file already
		# exists, snakemake will throw "Nothing to be done"
		expand(SAM_AL_DIR + "{sample}_RNA_HISAT2_genome_aligned.sam", SAM_AL_DIR=SAM_AL_DIR, sample=SAMPLES),
		expand(BAM_AL_DIR + "{sample}_RNA_HISAT2_genome_aligned.bam", BAM_AL_DIR=BAM_AL_DIR, sample=SAMPLES),
		expand(SORTED_BAM_AL_DIR + "{sample}_RNA_HISAT2_genome_aligned_sortedbycoord.bam", SORTED_BAM_AL_DIR=SORTED_BAM_AL_DIR, sample=SAMPLES),
		expand(SORTED_BAM_AL_DIR + "{sample}_RNA_HISAT2_genome_aligned_sortedbycoord.bam.bai", SORTED_BAM_AL_DIR=SORTED_BAM_AL_DIR, sample=SAMPLES),


rule hisat2_xx_align_reads:
	input:
		R1 = os.path.join(FQ_DIR, "{sample}_trimmed_read1.fastq.gz"),
		R2 = os.path.join(FQ_DIR, "{sample}_trimmed_read2.fastq.gz")
	output:
		SAM = os.path.join(SAM_AL_DIR, "{sample}_RNA_HISAT2_genome_aligned.sam"),
	params:
	    index = "/data/CEM/shared/public_data/references/ensemble_GRCm38.68/GRCm38_68",
		threads = 8
	run:
		shell("hisat2 -q --phred33 -p {params.threads} -x {params.index} -s no -1 {input.R1} -2 {input.R2} -S {output.SAM}")

rule xx_xy_sam_to_bam:
	input:
		SAM = os.path.join(SAM_AL_DIR, "{sample}_RNA_HISAT2_genome_aligned.sam"),
	output:
		BAM = os.path.join(BAM_AL_DIR, "{sample}_RNA_HISAT2_genome_aligned.bam"),
	params:
	message: "Converting SAM to BAM, only outputting mapped reads."
	run:
		shell("samtools view -b -F 4 {input.SAM} > {output.BAM}")


rule xx_xy_sort_bam:
	input:
		BAM = os.path.join(BAM_AL_DIR, "{sample}_RNA_HISAT2_genome_aligned.bam"),
	output:
		SORTED_BAM = os.path.join(SORTED_BAM_AL_DIR, "{sample}_RNA_HISAT2_genome_aligned_sortedbycoord.bam"),
	params:
	message: "Sorting BAM file."
	run:
		shell("samtools sort -O bam -o {output.SORTED_BAM} {input.BAM}")

rule xx_xy_index_bam:
	input:
		BAM = os.path.join(SORTED_BAM_AL_DIR, "{sample}_RNA_HISAT2_genome_aligned_sortedbycoord.bam"),
	output: 
		os.path.join(SORTED_BAM_AL_DIR, "{sample}_RNA_HISAT2_genome_aligned_sortedbycoord.bam.bai"),
	message: "Indexing sorted BAM file."
	params:
	run:
		for x in input:
			shell("samtools index {x}")
