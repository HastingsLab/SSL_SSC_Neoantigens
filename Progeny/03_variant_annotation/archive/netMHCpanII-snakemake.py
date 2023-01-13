# Setting up filenames here:
from os.path import join
#configfile: "full_hla_types.json"

sample = ["DNA_483-SC-01-B6_9-3-21_133_060_S138_L002"]

peptide_path = "/scratch/eknodel/SCC_samples/cell_lines/Progeny/peptides/"

rule all:
    input:
        expand("/scratch/eknodel/SCC_samples/cell_lines/Progeny/netMHCpan/{sample}_15_netmhcII.xsl", sample=sample) # Calculate dissociation constant


rule prepare_input: 
    input: 
        peptides_29 = os.path.join(peptide_path + "{sample}_vep.29.peptide"),
    output:
        peptides_29 = os.path.join(peptide_path + "{sample}.29.peptide_formatted"),
    shell:
        """
        cat {input.peptides_29} | sed '/>WT/,+1 d' > {output.peptides_29};
        """

rule netMHC:
    input:
        peptides_29 = os.path.join(peptide_path + "{sample}.29.peptide_formatted"),
    output:
        netMHC_15 = os.path.join("/scratch/eknodel/SCC_samples/cell_lines/Progeny/netMHCpan/{sample}_15_netmhcII.xsl"),
    params:
        hla = "H-2-IAd,H-2-IEd"
    shell:
        """
        ~/bin/netMHCIIpan-4.1/netMHCIIpan -a {params.hla} -f {input.peptides_29} -BA -s -xls -length 15  -xlsfile {output.netMHC_15};
        """
