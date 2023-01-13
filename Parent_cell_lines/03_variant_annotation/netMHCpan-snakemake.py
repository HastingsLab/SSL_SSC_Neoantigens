# Setting up filenames here:
from os.path import join
#configfile: "full_hla_types.json"

sample = ["244_1_Chu_02_B7_352_225_S2_L003"]

peptide_path = "/scratch/eknodel/SCC_samples/Parent_cell_lines/peptides/"

rule all:
    input:
        expand("/scratch/eknodel/SCC_samples/Parent_cell_lines/netMHCpan/{sample}_gatk_netmhc.xsl", sample=sample), # Calculate dissociation constant

rule prepare_input: 
    input: 
        peptides_gatk = os.path.join(peptide_path + "{sample}_gatk_vep_filtered.peptides"),
        peptides_strelka = os.path.join(peptide_path + "{sample}_strelka_vep_filtered.peptides")
    output: 
        peptides_gatk = os.path.join(peptide_path + "{sample}_gatk_vep_filtered.peptide_formatted"),
        peptides_strelka = os.path.join(peptide_path + "{sample}_strelka_vep_filtered.peptide_formatted")
    shell:
        """
        cat {input.peptides_gatk} | awk '{{print $1"."$7, $8}}' | sed 's/>MT/>/' | sed 's/ /\\n/g' > {output.peptides_gatk};
        cat {input.peptides_strelka} | awk '{{print $1"."$7, $8}}' | sed 's/>MT/>/' | sed 's/ /\\n/g' > {output.peptides_strelka}
        """

rule netMHC:
    input:
        peptides_gatk = os.path.join(peptide_path + "{sample}_gatk_vep_filtered.peptide_formatted"),
        peptides_strelka = os.path.join(peptide_path + "{sample}_strelka_vep_filtered.peptide_formatted")
    output:
        netMHC_gatk = os.path.join("/scratch/eknodel/SCC_samples/Parent_cell_lines/netMHCpan/{sample}_gatk_netmhc.xsl"),
        netMHC_strelka = os.path.join("/scratch/eknodel/SCC_samples/Parent_cell_lines/netMHCpan/{sample}_strelka_netmhc.xsl")
    params:
        hla = "H-2-Dd,H-2-Kd,H-2-Ld"
    shell:
        """
        netMHCpan -a {params.hla} -f {input.peptides_gatk} -BA -s -xls -l 9  -xlsfile {output.netMHC_gatk};
        netMHCpan -a {params.hla} -f {input.peptides_strelka} -BA -s -xls -l 9  -xlsfile {output.netMHC_strelka};
        """

