# Setting up filenames here:
from os.path import join
#configfile: "full_hla_types.json"

sample = ["DNA_483-SC-01-B6_9-3-21_133_060_S138_L002"]

peptide_path = "/scratch/eknodel/SCC_samples/cell_lines/Progeny/peptides/"

rule all:
    input:
        expand("/scratch/eknodel/SCC_samples/cell_lines/Progeny/netMHCpan/{sample}_9_netmhc.xsl", sample=sample), # Calculate dissociation constant

rule prepare_input: 
    input: 
        peptides_17 = os.path.join(peptide_path + "{sample}_vep.17.peptide"),
    output: 
        peptides_17 = os.path.join(peptide_path + "{sample}.17.peptide_formatted"),
    shell:
        """
        cat {input.peptides_17} | sed '/>WT/,+1 d' > {output.peptides_17};
        """

rule netMHC:
    input:
        peptides_17 = os.path.join(peptide_path + "{sample}.17.peptide_formatted"),
    output:
        netMHC_9  = os.path.join("/scratch/eknodel/SCC_samples/cell_lines/Progeny/netMHCpan/{sample}_9_netmhc.xsl"),
    params:
        hla = "H-2-Dd,H-2-Kd,H-2-Ld"
    shell:
        """
        netMHCpan -a {params.hla} -f {input.peptides_17} -BA -s -xls -l 9  -xlsfile {output.netMHC_9};
        """

