import os


samples = ["gDNA_185_25_2E1_5C_365_212_S56_L004", "gDNA_188_25_2E2_5C_157_036_S57_L004", "gDNA_244_25_2E1_chu_329_248_S59_L004","gDNA_normal_tissue_377_200_S55_L004"]

rule all:
    input:
        expand(os.path.join("/scratch/eknodel/SCC_samples/Parent_tumors/processed_bams/{subject}_footprint.out"), subject = samples)

rule footprint:
    input:
        bam = os.path.join("/scratch/eknodel/SCC_samples/Parent_tumors/processed_bams/{sample}.GRCm38_68.sorted.bam")
    output:
        footprint = os.path.join("/scratch/eknodel/SCC_samples/Parent_tumors/processed_bams/{sample}_footprint.out"),
    shell:
        """
        bedtools genomecov -ibam {input.bam} -max 2 > {output.footprint};
        """
