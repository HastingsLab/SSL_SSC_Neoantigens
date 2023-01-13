# Setting up filesnames here:
from os.path import join
import os

sample = ["gDNA_185_25_2E1_5C_365_212_S56_L004",  "gDNA_188_25_2E2_5C_157_036_S57_L004",  "gDNA_244_25_2E1_chu_329_248_S59_L004"]

# Directory Pathways
gatk_path = "/scratch/eknodel/SCC_samples/gatk_mutect2/"
intermediate_path = "/scratch/eknodel/SCC_samples/variants/"
peptide_path = "/scratch/eknodel/SCC_samples/peptides/"
strelka_dir = "/scratch/eknodel/SCC_samples/strelka/"

rule all:
    input:
        expand(intermediate_path + "{sample}_merged.vcf", sample=sample, intermediate_path=intermediate_path),
        expand(intermediate_path + "{sample}_vep.vcf", sample=sample, intermediate_path=intermediate_path),
        expand(peptide_path + "{sample}_vep.17.peptide", sample=sample, peptide_path=peptide_path),
        expand(peptide_path + "{sample}.17.peptide_formatted2", sample=sample, peptide_path=peptide_path)

rule generate_input:
    input:
        gatk = os.path.join(gatk_path, "{sample}.somatic.filtered.pass.vcf"),
        strelka = os.path.join(strelka_dir, "{sample}/results/variants/somatic.snvs.pass.vcf"),
        strelka_indels = os.path.join(strelka_dir, "{sample}/results/variants/somatic.indels.pass.vcf")
    output:
        vep = os.path.join(intermediate_path, "{sample}_merged.vcf")
    shell:
        """
        python prepare_input_for_vep_gatk_and_strelka.py --vcf_filenames \
        {input.gatk},{input.strelka},{input.strelka_indels} \
        --vep_format_fn {output.vep}
        """

rule run_vep:
    input:
        os.path.join(intermediate_path, "{sample}_merged.vcf")
    output:
        os.path.join(intermediate_path, "{sample}_vep.vcf")
    shell:
        """
        vep -i {input} --format vcf --species mus_musculus --cache --cache_version 100 --offline --vcf -o {output} --force_overwrite  --symbol --plugin Wildtype --terms SO --plugin Downstream 
        """ 

rule generate_fasta:
    input:
        os.path.join(intermediate_path, "{sample}_vep.vcf")
    output:
        len_17 = os.path.join(peptide_path, "{sample}_vep.17.peptide"),
    params: 
        sample = "{sample}"
    shell:
        """
        pvacseq generate_protein_fasta {input} 17 {output.len_17};
        """

rule prepare_comparison_files:
    input:
        peptides_17 = os.path.join(peptide_path + "{sample}_vep.17.peptide"),
    output:
        peptides_17 = os.path.join(peptide_path + "{sample}.17.peptide_formatted2"),
    shell:
        """
        paste -s -d' \n' {input.peptides_17} | sed '/>WT/d' > {output.peptides_17};
        """
