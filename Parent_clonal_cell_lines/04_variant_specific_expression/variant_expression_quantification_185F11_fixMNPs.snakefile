#! importing join
from os.path import join

# aligning files with HISAT2, sorting and indexing BAM files with Samtools.

# Tools


# Directories
EXPRESSION_DIR = "/scratch/eknodel/SCC_samples/Parent_cell_lines/RNAseq/variant_specific_expression/"
vep_path = "/scratch/eknodel/SCC_samples/Parent_cell_lines/VEP/"
SORTED_BAM_AL_DIR = "/scratch/eknodel/SCC_samples/Parent_cell_lines/RNAseq/sorted_bam/" # path to directory for sorted BAM alignment files

# Samples
RNA = ["185-1-5c-01-F11-6-26-21-1_216_361_S9_L003",
"185-1-5c-01-F11-6-26-21-2_204_373_S10_L003",
"185-1-5c-01-F11-6-26-21-3_287_290_S11_L003",
"185-1-5c-01-F11-6-26-21-4_275_302_S12_L003",
"185-1-5c-01-F11-6-26-21-5_263_314_S13_L003",
"185-1-5c-01-F11-6-26-21-6_251_326_S14_L003"]

rule all:
	input:
		expand(EXPRESSION_DIR + "{RNA}_mnp_split_gatk_filtered_expression.tsv", EXPRESSION_DIR=EXPRESSION_DIR, RNA=RNA),
        expand(EXPRESSION_DIR + "{RNA}_mnp_split_gatk_filtered_expression.out", EXPRESSION_DIR=EXPRESSION_DIR, RNA=RNA)

rule remove_duplicates:
    input:    
        gatk_filtered = os.path.join(vep_path, "185_1_SC_01_F11_364_213_S1_L003_mnp_split_gatk_vep_filtered.vcf"),
        ref = "/data/CEM/shared/public_data/references/ensemble_GRCm38.68/GRCm38_68.fa"
    output:
        gatk_filtered = os.path.join(vep_path, "185_1_SC_01_F11_364_213_S1_L003_mnp_split_gatk_vep_filtered_SNP.vcf"),
    params: 
        gatk = "/home/eknodel/gatk-4.1.7.0/gatk"
    shell:
        """
        {params.gatk} SelectVariants -V {input.gatk_filtered} --select-type-to-include SNP -O {output.gatk_filtered};
        """

rule index_vcf:
    input: 
        gatk_filtered = os.path.join(vep_path, "185_1_SC_01_F11_364_213_S1_L003_mnp_split_gatk_vep_filtered_SNP.vcf"),
    output:
        gatk_filtered = os.path.join(vep_path, "185_1_SC_01_F11_364_213_S1_L003_mnp_split_gatk_vep_filtered_SNP.vcf.idx"),
    params: 
        gatk = "/home/eknodel/gatk-4.1.7.0/gatk"
    shell:
        """
        {params.gatk} IndexFeatureFile -I {input.gatk_filtered};
        """

rule gatk_asereadcounter:
    input: 
        BAM = os.path.join(SORTED_BAM_AL_DIR, "{RNA}_RNA_HISAT2_genome_aligned_sortedbycoord_mkdup_RG.bam"),
        gatk_filtered = os.path.join(vep_path, "185_1_SC_01_F11_364_213_S1_L003_mnp_split_gatk_vep_filtered_SNP.vcf"),
        gatk_filtered_idx = os.path.join(vep_path, "185_1_SC_01_F11_364_213_S1_L003_mnp_split_gatk_vep_filtered_SNP.vcf.idx"),
    output:
        gatk_filtered = os.path.join(EXPRESSION_DIR, "{RNA}_mnp_split_gatk_filtered_expression.tsv"),
    params:
        gatk = "/home/eknodel/gatk-4.1.7.0/gatk",
        ref = "/data/CEM/shared/public_data/references/ensemble_GRCm38.68/GRCm38_68.fa"
    shell: 
        """
        {params.gatk} ASEReadCounter --output {output.gatk_filtered} --input {input.BAM} --R {params.ref} --variant {input.gatk_filtered};  
        """

rule format_output: 
    input: 
        gatk_filtered = os.path.join(EXPRESSION_DIR, "{RNA}_mnp_split_gatk_filtered_expression.tsv"),
    output: 
        gatk_filtered = os.path.join(EXPRESSION_DIR, "{RNA}_mnp_split_gatk_filtered_expression.out"),
    shell: 
        """
        cat {input.gatk_filtered} | awk '{{print $1":"$2-1":"$4":"$5, $6, $7, $8, $12}}' > {output.gatk_filtered};
        """
