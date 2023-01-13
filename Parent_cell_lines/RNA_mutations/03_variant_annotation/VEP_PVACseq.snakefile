# Setting up filesnames here:
from os.path import join
import os

sample = ["244-B7"]

# Directory Pathways
intermediate_path = "/scratch/eknodel/SCC_samples/cell_lines/RNA_unfiltered_mutations/"
peptide_path = "/scratch/eknodel/SCC_samples/cell_lines/RNA_unfiltered_mutations/peptides/"

rule all:
    input:
        expand(intermediate_path + "{sample}_RNA_unfiltered_vep.vcf", sample=sample, intermediate_path=intermediate_path),
        expand(peptide_path + "{sample}_vep_unfiltered.17.peptide", sample=sample, peptide_path=peptide_path),
        #expand(peptide_path + "{sample}_vep_unfiltered.29.peptide", sample=sample, peptide_path=peptide_path)

rule gunzip: 
    input: 
        gatk1 = "/scratch/eknodel/SCC_samples/cell_lines/RNAseq/gatk_mutect2/244-1-chu-02-B7-6-11-21_226_351_S24_L003.somatic.vcf.gz",
        gatk2 = "/scratch/eknodel/SCC_samples/cell_lines/RNAseq/gatk_mutect2/244-1-chu-02-B7-6-15-21_214_363_S25_L003.somatic.vcf.gz",
        gatk3 = "/scratch/eknodel/SCC_samples/cell_lines/RNAseq/gatk_mutect2/244-1-chu-02-B7-6-22-21_202_375_S26_L003.somatic.vcf.gz",
        gatk4 = "/scratch/eknodel/SCC_samples/cell_lines/RNAseq/gatk_mutect2/244-1-chu-02-B7-6-3-21_262_315_S21_L003.somatic.vcf.gz",
        gatk5 = "/scratch/eknodel/SCC_samples/cell_lines/RNAseq/gatk_mutect2/244-1-chu-02-B7-6-6-21_250_327_S22_L003.somatic.vcf.gz",
        gatk6 = "/scratch/eknodel/SCC_samples/cell_lines/RNAseq/gatk_mutect2/244-1-chu-02-B7-6-9-21_238_339_S23_L003.somatic.vcf.gz"
    output:
        gatk1 = "/scratch/eknodel/SCC_samples/cell_lines/RNAseq/gatk_mutect2/244-1-chu-02-B7-6-11-21_226_351_S24_L003.somatic.vcf",
        gatk2 = "/scratch/eknodel/SCC_samples/cell_lines/RNAseq/gatk_mutect2/244-1-chu-02-B7-6-15-21_214_363_S25_L003.somatic.vcf",
        gatk3 = "/scratch/eknodel/SCC_samples/cell_lines/RNAseq/gatk_mutect2/244-1-chu-02-B7-6-22-21_202_375_S26_L003.somatic.vcf",
        gatk4 = "/scratch/eknodel/SCC_samples/cell_lines/RNAseq/gatk_mutect2/244-1-chu-02-B7-6-3-21_262_315_S21_L003.somatic.vcf",
        gatk5 = "/scratch/eknodel/SCC_samples/cell_lines/RNAseq/gatk_mutect2/244-1-chu-02-B7-6-6-21_250_327_S22_L003.somatic.vcf",
        gatk6 = "/scratch/eknodel/SCC_samples/cell_lines/RNAseq/gatk_mutect2/244-1-chu-02-B7-6-9-21_238_339_S23_L003.somatic.vcf"
    shell: 
        """
        gunzip {input.gatk1};
        gunzip {input.gatk2};
        gunzip {input.gatk3};
        gunzip {input.gatk4};
        gunzip {input.gatk5};
        gunzip {input.gatk6};
        """

rule generate_input:
    input:
        gatk1 = "/scratch/eknodel/SCC_samples/cell_lines/RNAseq/gatk_mutect2/244-1-chu-02-B7-6-11-21_226_351_S24_L003.somatic.vcf",
        gatk2 = "/scratch/eknodel/SCC_samples/cell_lines/RNAseq/gatk_mutect2/244-1-chu-02-B7-6-15-21_214_363_S25_L003.somatic.vcf",
        gatk3 = "/scratch/eknodel/SCC_samples/cell_lines/RNAseq/gatk_mutect2/244-1-chu-02-B7-6-22-21_202_375_S26_L003.somatic.vcf",
        gatk4 = "/scratch/eknodel/SCC_samples/cell_lines/RNAseq/gatk_mutect2/244-1-chu-02-B7-6-3-21_262_315_S21_L003.somatic.vcf",
        gatk5 = "/scratch/eknodel/SCC_samples/cell_lines/RNAseq/gatk_mutect2/244-1-chu-02-B7-6-6-21_250_327_S22_L003.somatic.vcf",
        gatk6 = "/scratch/eknodel/SCC_samples/cell_lines/RNAseq/gatk_mutect2/244-1-chu-02-B7-6-9-21_238_339_S23_L003.somatic.vcf"
    output:
        vep = os.path.join(intermediate_path, "{sample}_RNA_merged_unfiltered.vcf")
    shell:
        """
        python prepare_input_for_vep_unfiltered.py --vcf_filenames \
        {input.gatk1},{input.gatk2},{input.gatk3},{input.gatk4},{input.gatk5},{input.gatk6} \
        --vep_format_fn {output.vep}
        """

rule sort:
    input:
        os.path.join(intermediate_path, "{sample}_RNA_merged_unfiltered.vcf")
    output:
        os.path.join(intermediate_path, "{sample}_RNA_merged_unfiltered_sorted.vcf")
    shell:
        """
        sort -V {input} > {output}
        """

rule run_vep:
    input:
        os.path.join(intermediate_path, "{sample}_RNA_merged_unfiltered_sorted.vcf")
    output:
        os.path.join(intermediate_path, "{sample}_RNA_unfiltered_vep.vcf")
    shell:
        """
        vep -i {input} --format vcf --species mus_musculus --cache --cache_version 100 --offline --vcf -o {output} --force_overwrite  --symbol --plugin Wildtype --terms SO --plugin Downstream 
        """ 


rule generate_fasta:
    input:
        os.path.join(intermediate_path, "{sample}_RNA_unfiltered_vep.vcf")
    output:
        len_15 = os.path.join(peptide_path, "{sample}_vep_unfiltered.15.peptide"),
        len_17 = os.path.join(peptide_path, "{sample}_vep_unfiltered.17.peptide"),
        len_19 = os.path.join(peptide_path, "{sample}_vep_unfiltered.19.peptide"),
        len_21 = os.path.join(peptide_path, "{sample}_vep_unfiltered.21.peptide")
    params: 
        sample = "{sample}"
    shell:
        """
        pvacseq generate_protein_fasta {input} 15 {output.len_15};
        pvacseq generate_protein_fasta {input} 17 {output.len_17};
        pvacseq generate_protein_fasta {input} 19 {output.len_19};
        pvacseq generate_protein_fasta {input} 21 {output.len_21};
        """


rule generate_fasta_MHCII:
    input:
        os.path.join(intermediate_path, "{sample}_RNA_unfiltered_vep.vcf")
    output:
        len_29 = os.path.join(peptide_path, "{sample}_vep_unfiltered.29.peptide"),
        len_31 = os.path.join(peptide_path, "{sample}_vep_unfiltered.31.peptide"),
        len_33 = os.path.join(peptide_path, "{sample}_vep_unfiltered.33.peptide"),
        len_35 = os.path.join(peptide_path, "{sample}_vep_unfiltered.35.peptide"),
        len_37 = os.path.join(peptide_path, "{sample}_vep_unfiltered.37.peptide"),
        len_39 = os.path.join(peptide_path, "{sample}_vep_unfiltered.39.peptide")
    params:
        sample = "{sample}"
    shell:
        """
        pvacseq generate_protein_fasta {input} 29 {output.len_29};
        pvacseq generate_protein_fasta {input} 31 {output.len_31};
        pvacseq generate_protein_fasta {input} 33 {output.len_33};
        pvacseq generate_protein_fasta {input} 35 {output.len_35};
        pvacseq generate_protein_fasta {input} 37 {output.len_37};
        pvacseq generate_protein_fasta {input} 39 {output.len_39};
        """
