# Setting up filenames here:
from os.path import join
#configfile: "full_hla_types.json"

sample = ["185_F11", "185_G9", "188", "244_B7", "244_D12", "244_F5"]

peptide_path = "/scratch/eknodel/SCC_samples/cell_lines/RNA_overlap_mutations/peptides/"

rule all:
    input:
        expand("/scratch/eknodel/SCC_samples/cell_lines/RNA_overlap_mutations/netMHCpan/{sample}_9_netmhc.xsl", sample=sample), # Calculate dissociation constant
        expand("/scratch/eknodel/SCC_samples/cell_lines/RNA_overlap_mutations/peptides/{sample}.17.peptide_formatted2", sample=sample)

rule prepare_input: 
    input: 
        peptides_17 = os.path.join(peptide_path + "{sample}_vep.17.peptide"),
    output: 
        peptides_17 = os.path.join(peptide_path + "{sample}.17.peptide_formatted"),
    shell:
        """
        cat {input.peptides_17} | sed '/>WT/,+1 d' > {output.peptides_17};
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

rule netMHC:
    input:
        peptides_17 = os.path.join(peptide_path + "{sample}.17.peptide_formatted"),
    output:
        netMHC_9  = os.path.join("/scratch/eknodel/SCC_samples/cell_lines/RNA_overlap_mutations/netMHCpan/{sample}_9_netmhc.xsl"),
    params:
        hla = "H-2-Dd,H-2-Kd,H-2-Ld"
    shell:
        """
        netMHCpan -a {params.hla} -f {input.peptides_17} -BA -s -xls -l 9  -xlsfile {output.netMHC_9};
        """

