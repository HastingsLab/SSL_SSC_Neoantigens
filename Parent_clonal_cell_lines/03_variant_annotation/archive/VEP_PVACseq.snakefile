# Setting up filesnames here:
from os.path import join
import os

sample = ["185_1_SC_01_F11_364_213_S1_L003", "244_1_Chu_06_D12_316_261_S5_L003", "185_1_SC_01_F11_364_213_S1_L003", "244_1_Chu_06_F5_328_249_S4_L003",
"185_1_SC_09_G9_304_273_S6_L003", "244_1_Chu_06_F5_328_249_S4_L003", "185_1_SC_09_G9_304_273_S6_L003", "188_2_SC_05_F11_340_237_S3_L003",
"188_2_SC_05_F11_340_237_S3_L003", "244_1_Chu_02_B7_352_225_S2_L003", "244_1_Chu_02_B7_352_225_S2_L003", "244_1_Chu_06_D12_316_261_S5_L003"]
normal = ["gDNA_normal_tissue_377_200_S55_L004"]

ref_dir = "/scratch/eknodel/SCC_samples/reference/"
ref_basename = "GRCm38_68"

# Directory Pathways
gatk_path = "/scratch/eknodel/SCC_samples/cell_lines/gatk_mutect2/"
intermediate_path = "/scratch/eknodel/SCC_samples/cell_lines/variants/"
peptide_path = "/scratch/eknodel/SCC_samples/cell_lines/peptides/"
strelka_dir = "/scratch/eknodel/SCC_samples/cell_lines/strelka/"

rule all:
    input:
        expand(intermediate_path + "{sample}_merged.vcf", sample=sample, intermediate_path=intermediate_path),
        expand(intermediate_path + "{sample}_vep.vcf", sample=sample, intermediate_path=intermediate_path),
        expand(peptide_path + "{sample}_vep.17.peptide", sample=sample, peptide_path=peptide_path),
        expand(peptide_path + "{sample}_vep.29.peptide", sample=sample, peptide_path=peptide_path)

rule gunzip:
    input:
        gatk = os.path.join(gatk_path, "{sample}.somatic.filtered.pass.vcf.gz")
    output:
        gatk = os.path.join(gatk_path, "{sample}.somatic.filtered.pass.vcf")
    shell:
        """
        gunzip {input.gatk}
        """

rule generate_input:
    input:
        gatk = os.path.join(gatk_path, "{sample}.somatic.filtered.pass.vcf"),
        strelka = os.path.join(strelka_dir, "{sample}/results/variants/somatic.snvs.pass.vcf"),
        strelka_indels = os.path.join(strelka_dir, "{sample}/results/variants/somatic.indels.pass.vcf")
    output:
        vep = os.path.join(intermediate_path, "{sample}_merged.vcf")
    shell:
        """
        python prepare_input_for_vep.py --vcf_filenames \
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
        len_15 = os.path.join(peptide_path, "{sample}_vep.15.peptide"),
        len_17 = os.path.join(peptide_path, "{sample}_vep.17.peptide"),
        len_19 = os.path.join(peptide_path, "{sample}_vep.19.peptide"),
        len_21 = os.path.join(peptide_path, "{sample}_vep.21.peptide")
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
        os.path.join(intermediate_path, "{sample}_vep.vcf")
    output:
        len_29 = os.path.join(peptide_path, "{sample}_vep.29.peptide"),
        len_31 = os.path.join(peptide_path, "{sample}_vep.31.peptide"),
        len_33 = os.path.join(peptide_path, "{sample}_vep.33.peptide"),
        len_35 = os.path.join(peptide_path, "{sample}_vep.35.peptide"),
        len_37 = os.path.join(peptide_path, "{sample}_vep.37.peptide"),
        len_39 = os.path.join(peptide_path, "{sample}_vep.39.peptide")
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
