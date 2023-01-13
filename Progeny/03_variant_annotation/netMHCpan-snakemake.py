# Setting up filenames here:
from os.path import join
#configfile: "full_hla_types.json"

sample = ["DNA_483-SC-01-B6_9-3-21_133_060_S138_L002"]

peptide_path = "/scratch/eknodel/SCC_samples/Progeny/peptides/"

rule all:
    input:
        expand("/scratch/eknodel/SCC_samples/Progeny/netMHCpan/{sample}_gatk_netmhc.xsl", sample=sample), # Calculate dissociation constant

rule prepare_input: 
    input: 
        peptides_gatk = os.path.join(peptide_path + "{sample}_gatk_vep_unfiltered.peptides"),
        peptides_strelka = os.path.join(peptide_path + "{sample}_strelka_vep_unfiltered.peptides")
    output: 
        peptides_gatk = os.path.join(peptide_path + "{sample}_gatk_vep_unfiltered.peptide_formatted"),
        peptides_strelka = os.path.join(peptide_path + "{sample}_strelka_vep_unfiltered.peptide_formatted")
    shell:
        """
        cat {input.peptides_gatk} | awk '{{print $1"."$7, $8}}' > {output.peptides_gatk};
        cat {input.peptides_strelka} | awk '{{print $1"."$7, $8}}' > {output.peptides_strelka}
        """

rule netMHC:
    input:
        peptides_gatk = os.path.join(peptide_path + "{sample}_gatk_vep_unfiltered.peptide_formatted"),
        peptides_strelka = os.path.join(peptide_path + "{sample}_strelka_vep_unfiltered.peptide_formatted")
    output:
        netMHC_gatk = os.path.join("/scratch/eknodel/SCC_samples/Progeny/netMHCpan/{sample}_gatk_netmhc.xsl"),
        netMHC_strelka = os.path.join("/scratch/eknodel/SCC_samples/Progeny/netMHCpan/{sample}_strelka_netmhc.xsl")
    params:
        hla = "H-2-Dd,H-2-Kd,H-2-Ld"
    shell:
        """
        netMHCpan -a {params.hla} -f {input.peptides_gatk} -BA -s -xls -l 9  -xlsfile {output.netMHC_gatk};
        netMHCpan -a {params.hla} -f {input.peptides_strelka} -BA -s -xls -l 9  -xlsfile {output.netMHC_strelka};
        """

