#! importing join
from os.path import join

# aligning files with HISAT2, sorting and indexing BAM files with Samtools.

# Tools


# Directories
EXPRESSION_DIR = "/scratch/eknodel/SCC_samples/Parent_cell_lines/RNAseq/variant_specific_expression/"
vep_path = "/scratch/eknodel/SCC_samples/Parent_cell_lines/VEP/"
SORTED_BAM_AL_DIR = "/scratch/eknodel/SCC_samples/Parent_cell_lines/RNAseq/sorted_bam/" # path to directory for sorted BAM alignment files

# Samples
RNA = ["244-1-chu-02-B7-6-11-21_226_351_S24_L003", "244-1-chu-02-B7-6-15-21_214_363_S25_L003", "244-1-chu-02-B7-6-22-21_202_375_S26_L003", "244-1-chu-02-B7-6-3-21_262_315_S21_L003", "244-1-chu-02-B7-6-6-21_250_327_S22_L003", "244-1-chu-02-B7-6-9-21_238_339_S23_L003"]

rule all:
	input:
		expand(EXPRESSION_DIR + "{RNA}_gatk_filtered_expression.tsv", EXPRESSION_DIR=EXPRESSION_DIR, RNA=RNA),
        expand(EXPRESSION_DIR + "{RNA}_gatk_filtered_expression.out", EXPRESSION_DIR=EXPRESSION_DIR, RNA=RNA)

rule remove_duplicates:
    input:    
        gatk_filtered = os.path.join(vep_path, "244_1_Chu_02_B7_352_225_S2_L003_gatk_vep_filtered.vcf"),
        gatk_unfiltered = os.path.join(vep_path, "244_1_Chu_02_B7_352_225_S2_L003_gatk_vep_unfiltered.vcf"),
        strelka_filtered = os.path.join(vep_path, "244_1_Chu_02_B7_352_225_S2_L003_strelka_vep_filtered.vcf"),
        strelka_unfiltered = os.path.join(vep_path, "244_1_Chu_02_B7_352_225_S2_L003_strelka_vep_unfiltered.vcf"),
        ref = "/data/CEM/shared/public_data/references/ensemble_GRCm38.68/GRCm38_68.fa"
    output:
        gatk_filtered = os.path.join(vep_path, "244_1_Chu_02_B7_352_225_S2_L003_gatk_vep_filtered_SNP.vcf"),
        gatk_unfiltered = os.path.join(vep_path, "244_1_Chu_02_B7_352_225_S2_L003_gatk_vep_unfiltered_SNP.vcf"),
        strelka_filtered = os.path.join(vep_path, "244_1_Chu_02_B7_352_225_S2_L003_strelka_vep_filtered_SNP.vcf"),
        strelka_unfiltered = os.path.join(vep_path, "244_1_Chu_02_B7_352_225_S2_L003_strelka_vep_unfiltered_SNP.vcf")
    params: 
        gatk = "/home/eknodel/gatk-4.1.7.0/gatk"
    shell:
        """
        {params.gatk} SelectVariants -V {input.gatk_filtered} --select-type-to-include SNP -O {output.gatk_filtered};
        {params.gatk} SelectVariants -V {input.gatk_unfiltered} --select-type-to-include SNP -O {output.gatk_unfiltered};
        {params.gatk} SelectVariants -V {input.strelka_filtered} --select-type-to-include SNP -O {output.strelka_filtered};
        {params.gatk} SelectVariants -V {input.strelka_unfiltered} --select-type-to-include SNP -O {output.strelka_unfiltered};
        """

rule index_vcf:
    input: 
        gatk_filtered = os.path.join(vep_path, "244_1_Chu_02_B7_352_225_S2_L003_gatk_vep_filtered_SNP.vcf"),
        gatk_unfiltered = os.path.join(vep_path, "244_1_Chu_02_B7_352_225_S2_L003_gatk_vep_unfiltered_SNP.vcf"),
        strelka_filtered = os.path.join(vep_path, "244_1_Chu_02_B7_352_225_S2_L003_strelka_vep_filtered_SNP.vcf"),
        strelka_unfiltered = os.path.join(vep_path, "244_1_Chu_02_B7_352_225_S2_L003_strelka_vep_unfiltered_SNP.vcf")
    output:
        gatk_filtered = os.path.join(vep_path, "244_1_Chu_02_B7_352_225_S2_L003_gatk_vep_filtered_SNP.vcf.idx"),
        gatk_unfiltered = os.path.join(vep_path, "244_1_Chu_02_B7_352_225_S2_L003_gatk_vep_unfiltered_SNP.vcf.idx"),
        strelka_filtered = os.path.join(vep_path, "244_1_Chu_02_B7_352_225_S2_L003_strelka_vep_filtered_SNP.vcf.idx"),
        strelka_unfiltered = os.path.join(vep_path, "244_1_Chu_02_B7_352_225_S2_L003_strelka_vep_unfiltered_SNP.vcf.idx")        
    params: 
        gatk = "/home/eknodel/gatk-4.1.7.0/gatk"
    shell:
        """
        {params.gatk} IndexFeatureFile -I {input.gatk_filtered};
        {params.gatk} IndexFeatureFile -I {input.gatk_unfiltered};
        {params.gatk} IndexFeatureFile -I {input.strelka_filtered};
        {params.gatk} IndexFeatureFile -I {input.strelka_unfiltered};
        """

rule gatk_asereadcounter:
    input: 
        BAM = os.path.join(SORTED_BAM_AL_DIR, "{RNA}_RNA_HISAT2_genome_aligned_sortedbycoord_mkdup_RG.bam"),
        gatk_filtered = os.path.join(vep_path, "244_1_Chu_02_B7_352_225_S2_L003_gatk_vep_filtered_SNP.vcf"),
        gatk_unfiltered = os.path.join(vep_path, "244_1_Chu_02_B7_352_225_S2_L003_gatk_vep_unfiltered_SNP.vcf"),
        strelka_filtered = os.path.join(vep_path, "244_1_Chu_02_B7_352_225_S2_L003_strelka_vep_filtered_SNP.vcf"),
        strelka_unfiltered = os.path.join(vep_path, "244_1_Chu_02_B7_352_225_S2_L003_strelka_vep_unfiltered_SNP.vcf"),
        gatk_filtered_idx = os.path.join(vep_path, "244_1_Chu_02_B7_352_225_S2_L003_gatk_vep_filtered_SNP.vcf.idx"),
        gatk_unfiltered_idx = os.path.join(vep_path, "244_1_Chu_02_B7_352_225_S2_L003_gatk_vep_unfiltered_SNP.vcf.idx"),
        strelka_filtered_idx = os.path.join(vep_path, "244_1_Chu_02_B7_352_225_S2_L003_strelka_vep_filtered_SNP.vcf.idx"),
        strelka_unfiltered_idx = os.path.join(vep_path, "244_1_Chu_02_B7_352_225_S2_L003_strelka_vep_unfiltered_SNP.vcf.idx")
    output:
        gatk_filtered = os.path.join(EXPRESSION_DIR, "{RNA}_gatk_filtered_expression.tsv"),
        gatk_unfiltered = os.path.join(EXPRESSION_DIR, "{RNA}_gatk_unfiltered_expression.tsv"),
        strelka_filtered = os.path.join(EXPRESSION_DIR, "{RNA}_strelka_filtered_expression.tsv"),
        strelka_unfiltered = os.path.join(EXPRESSION_DIR, "{RNA}_strelka_unfiltered_expression.tsv"),
    params:
        gatk = "/home/eknodel/gatk-4.1.7.0/gatk",
        ref = "/data/CEM/shared/public_data/references/ensemble_GRCm38.68/GRCm38_68.fa"
    shell: 
        """
        {params.gatk} ASEReadCounter --output {output.gatk_filtered} --input {input.BAM} --R {params.ref} --variant {input.gatk_filtered};  
        {params.gatk} ASEReadCounter --output {output.gatk_unfiltered} --input {input.BAM} --R {params.ref} --variant {input.gatk_unfiltered};
        {params.gatk} ASEReadCounter --output {output.strelka_filtered} --input {input.BAM} --R {params.ref} --variant {input.strelka_filtered};
        {params.gatk} ASEReadCounter --output {output.strelka_unfiltered} --input {input.BAM} --R {params.ref} --variant {input.strelka_unfiltered};
        """

rule format_output: 
    input: 
        gatk_filtered = os.path.join(EXPRESSION_DIR, "{RNA}_gatk_filtered_expression.tsv"),
        gatk_unfiltered = os.path.join(EXPRESSION_DIR, "{RNA}_gatk_unfiltered_expression.tsv"),
        strelka_filtered = os.path.join(EXPRESSION_DIR, "{RNA}_strelka_filtered_expression.tsv"),
        strelka_unfiltered = os.path.join(EXPRESSION_DIR, "{RNA}_strelka_unfiltered_expression.tsv")
    output: 
        gatk_filtered = os.path.join(EXPRESSION_DIR, "{RNA}_gatk_filtered_expression.out"),
        gatk_unfiltered = os.path.join(EXPRESSION_DIR, "{RNA}_gatk_unfiltered_expression.out"),
        strelka_filtered = os.path.join(EXPRESSION_DIR, "{RNA}_strelka_filtered_expression.out"),
        strelka_unfiltered = os.path.join(EXPRESSION_DIR, "{RNA}_strelka_unfiltered_expression.out")
    shell: 
        """
        cat {input.gatk_filtered} | awk '{{print $1":"$2-1":"$4":"$5, $6, $7, $8, $12}}' > {output.gatk_filtered};
        cat {input.gatk_unfiltered} | awk '{{print $1":"$2-1":"$4":"$5, $6, $7, $8, $12}}' > {output.gatk_unfiltered};
        cat {input.strelka_filtered} | awk '{{print $1":"$2-1":"$4":"$5, $6, $7, $8, $12}}' > {output.strelka_filtered};
        cat {input.strelka_unfiltered} | awk '{{print $1":"$2-1":"$4":"$5, $6, $7, $8, $12}}' > {output.strelka_unfiltered}
        """
