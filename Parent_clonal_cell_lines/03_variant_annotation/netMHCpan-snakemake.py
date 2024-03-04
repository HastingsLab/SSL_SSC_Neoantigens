# Setting up filenames here:
from os.path import join
#configfile: "full_hla_types.json"

sample = ["244_1_Chu_02_B7_352_225_S2_L003", "185_1_SC_01_F11_364_213_S1_L003", "188_2_SC_05_F11_340_237_S3_L003", "185_1_SC_09_G9_304_273_S6_L003", "244_1_Chu_06_D12_316_261_S5_L003", "244_1_Chu_06_F5_328_249_S4_L003"]

peptide_path = "/scratch/eknodel/SCC_samples/Parent_cell_lines/peptides/"

rule all:
    input:
        expand("/scratch/eknodel/SCC_samples/Parent_cell_lines/netMHCpan/{sample}_gatk_netmhc.xsl", sample=sample), # Calculate dissociation constant

rule prepare_input: 
    input: 
        peptides_gatk = os.path.join(peptide_path + "{sample}_gatk_vep_filtered.peptides"),
    output: 
        peptides_gatk = os.path.join(peptide_path + "{sample}_gatk_vep_filtered.peptide_formatted"),
    shell:
        """
        cat {input.peptides_gatk} | awk '{{print $1"."$5, $6}}' | sed 's/>MT/>/' | sed 's/ /\\n/g' > {output.peptides_gatk};
        """

rule netMHC:
    input:
        peptides_gatk = os.path.join(peptide_path + "{sample}_gatk_vep_filtered.peptide_formatted"),
    output:
        netMHC_gatk = os.path.join("/scratch/eknodel/SCC_samples/Parent_cell_lines/netMHCpan/{sample}_gatk_netmhc.xsl"),
    params:
        hla = "H-2-Dd,H-2-Kd,H-2-Ld"
    shell:
        """
        netMHCpan -a {params.hla} -f {input.peptides_gatk} -BA -s -xls -l 9  -xlsfile {output.netMHC_gatk};
        """

