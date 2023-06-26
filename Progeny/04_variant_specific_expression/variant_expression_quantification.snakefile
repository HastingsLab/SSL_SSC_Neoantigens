#! importing join
from os.path import join

# aligning files with HISAT2, sorting and indexing BAM files with Samtools.

# Tools


# Directories
EXPRESSION_DIR = "/scratch/eknodel/SCC_samples/Progeny/RNAseq/variant_specific_expression/"
vep_path = "/scratch/eknodel/SCC_samples/Progeny/VEP/"
SORTED_BAM_AL_DIR = "/scratch/eknodel/SCC_samples/Progeny/RNAseq/sorted_bam/" # path to directory for sorted BAM alignment files

# Samples
RNA = ["483_sc_01_B6-1_366_211_S58_L003", "483_sc_01_B6-2_354_223_S59_L003"]

rule all:
	input:
		expand(EXPRESSION_DIR + "{RNA}_gatk_filtered_expression.tsv", EXPRESSION_DIR=EXPRESSION_DIR, RNA=RNA),
        expand(EXPRESSION_DIR + "{RNA}_strelka_unique_rescues.out", EXPRESSION_DIR=EXPRESSION_DIR, RNA=RNA),
        expand(vep_path + "strelka_unique_rescues.vcf.idx", vep_path=vep_path),
        expand(EXPRESSION_DIR + "{RNA}_gatk_filtered_expression.out", EXPRESSION_DIR=EXPRESSION_DIR, RNA=RNA)

rule remove_duplicates:
    input:    
        gatk_filtered = os.path.join(vep_path, "DNA_483-SC-01-B6_9-3-21_133_060_S138_L002_gatk_vep_filtered.vcf"),
        gatk_unfiltered = os.path.join(vep_path, "DNA_483-SC-01-B6_9-3-21_133_060_S138_L002_gatk_vep_unfiltered.vcf"),
        strelka_filtered = os.path.join(vep_path, "DNA_483-SC-01-B6_9-3-21_133_060_S138_L002_strelka_vep_filtered.vcf"),
        strelka_unfiltered = os.path.join(vep_path, "DNA_483-SC-01-B6_9-3-21_133_060_S138_L002_strelka_vep_unfiltered.vcf"),
        ref = "/data/CEM/shared/public_data/references/ensemble_GRCm38.68/GRCm38_68.fa"
    output:
        gatk_filtered = os.path.join(vep_path, "DNA_483-SC-01-B6_9-3-21_133_060_S138_L002_gatk_vep_filtered_biall.vcf"),
        gatk_unfiltered = os.path.join(vep_path, "DNA_483-SC-01-B6_9-3-21_133_060_S138_L002_gatk_vep_unfiltered_biall.vcf"),
        strelka_filtered = os.path.join(vep_path, "DNA_483-SC-01-B6_9-3-21_133_060_S138_L002_strelka_vep_filtered_biall.vcf"),
        strelka_unfiltered = os.path.join(vep_path, "DNA_483-SC-01-B6_9-3-21_133_060_S138_L002_strelka_vep_unfiltered_biall.vcf")
    params: 
        gatk = "/home/eknodel/gatk-4.1.7.0/gatk"
    shell:
        """
        {params.gatk} SelectVariants --V {input.gatk_filtered} --restrict-alleles-to BIALLELIC -O {output.gatk_filtered};
        {params.gatk} SelectVariants --V {input.gatk_unfiltered} --restrict-alleles-to BIALLELIC -O {output.gatk_unfiltered};
        {params.gatk} SelectVariants --V {input.strelka_filtered} --restrict-alleles-to BIALLELIC -O {output.strelka_filtered};
        {params.gatk} SelectVariants --V {input.strelka_unfiltered} --restrict-alleles-to BIALLELIC -O {output.strelka_unfiltered};
        """

rule index_vcf:
    input: 
        gatk_filtered = os.path.join(vep_path, "DNA_483-SC-01-B6_9-3-21_133_060_S138_L002_gatk_vep_filtered_biall.vcf"),
        gatk_unfiltered = os.path.join(vep_path, "DNA_483-SC-01-B6_9-3-21_133_060_S138_L002_gatk_vep_unfiltered_biall.vcf"),
        strelka_rescues = os.path.join(vep_path, "strelka_unique_rescues.vcf")
    output:
        gatk_filtered = os.path.join(vep_path, "DNA_483-SC-01-B6_9-3-21_133_060_S138_L002_gatk_vep_filtered_biall.vcf.idx"),
        gatk_unfiltered = os.path.join(vep_path, "DNA_483-SC-01-B6_9-3-21_133_060_S138_L002_gatk_vep_unfiltered_biall.vcf.idx"),
        strelka_rescues = os.path.join(vep_path, "strelka_unique_rescues.vcf.idx")        
    params: 
        gatk = "/home/eknodel/gatk-4.1.7.0/gatk"
    shell:
        """
        {params.gatk} IndexFeatureFile -I {input.gatk_filtered};
        {params.gatk} IndexFeatureFile -I {input.gatk_unfiltered};
        {params.gatk} IndexFeatureFile -I {input.strelka_rescues};
        """

rule gatk_asereadcounter:
    input: 
        BAM = os.path.join(SORTED_BAM_AL_DIR, "{RNA}_RNA_HISAT2_genome_aligned_sortedbycoord_mkdup_RG.bam"),
        gatk_filtered = os.path.join(vep_path, "DNA_483-SC-01-B6_9-3-21_133_060_S138_L002_gatk_vep_filtered_biall.vcf"),
        gatk_unfiltered = os.path.join(vep_path, "DNA_483-SC-01-B6_9-3-21_133_060_S138_L002_gatk_vep_unfiltered_biall.vcf"),
        gatk_filtered_idx = os.path.join(vep_path, "DNA_483-SC-01-B6_9-3-21_133_060_S138_L002_gatk_vep_filtered_biall.vcf.idx"),
        gatk_unfiltered_idx = os.path.join(vep_path, "DNA_483-SC-01-B6_9-3-21_133_060_S138_L002_gatk_vep_unfiltered_biall.vcf.idx"),
    output:
        gatk_filtered = os.path.join(EXPRESSION_DIR, "{RNA}_gatk_filtered_expression.tsv"),
        gatk_unfiltered = os.path.join(EXPRESSION_DIR, "{RNA}_gatk_unfiltered_expression.tsv"),
    params:
        gatk = "/home/eknodel/gatk-4.1.7.0/gatk",
        ref = "/data/CEM/shared/public_data/references/ensemble_GRCm38.68/GRCm38_68.fa"
    shell: 
        """
        {params.gatk} ASEReadCounter --output {output.gatk_filtered} --input {input.BAM} --R {params.ref} --variant {input.gatk_filtered};  
        {params.gatk} ASEReadCounter --output {output.gatk_unfiltered} --input {input.BAM} --R {params.ref} --variant {input.gatk_unfiltered};
        """

rule gatk_asereadcounter_strelka:
    input:
        BAM = os.path.join(SORTED_BAM_AL_DIR, "{RNA}_RNA_HISAT2_genome_aligned_sortedbycoord_mkdup_RG.bam"),
        strelka_rescues = os.path.join(vep_path, "strelka_unique_rescues.vcf"),
        strelka_rescues_idx = os.path.join(vep_path, "strelka_unique_rescues.vcf.idx")
    output:
        strelka_rescues = os.path.join(EXPRESSION_DIR, "{RNA}_strelka_unique_rescues.tsv")
    params:
        gatk = "/home/eknodel/gatk-4.1.7.0/gatk",
        ref = "/data/CEM/shared/public_data/references/ensemble_GRCm38.68/GRCm38_68.fa"
    shell:
        """
        {params.gatk} ASEReadCounter --output {output.strelka_rescues} --input {input.BAM} --R {params.ref} --variant {input.strelka_rescues} --disable-tool-default-read-filters;
        """

rule format_output:
    input:
        gatk_filtered = os.path.join(EXPRESSION_DIR, "{RNA}_gatk_filtered_expression.tsv"),
        gatk_unfiltered = os.path.join(EXPRESSION_DIR, "{RNA}_gatk_unfiltered_expression.tsv")
    output:
        gatk_filtered = os.path.join(EXPRESSION_DIR, "{RNA}_gatk_filtered_expression.out"),
        gatk_unfiltered = os.path.join(EXPRESSION_DIR, "{RNA}_gatk_unfiltered_expression.out")
    shell:
        """
        cat {input.gatk_filtered} | awk '{{print $1":"$2-1":"$4":"$5, $6, $7, $8, $12}}' > {output.gatk_filtered};
        cat {input.gatk_unfiltered} | awk '{{print $1":"$2-1":"$4":"$5, $6, $7, $8, $12}}' > {output.gatk_unfiltered};
        """

rule format_output_strelka:
    input:
        strelka_rescues = os.path.join(EXPRESSION_DIR, "{RNA}_strelka_unique_rescues.tsv")
    output:
        strelka_rescues = os.path.join(EXPRESSION_DIR, "{RNA}_strelka_unique_rescues.out")
    shell:
        """
        cat {input.strelka_rescues} | awk '{{print $1":"$2-1":"$4":"$5, $6, $7, $8, $12}}' > {output.strelka_rescues};
        """
