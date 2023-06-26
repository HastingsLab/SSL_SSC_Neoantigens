# Setting up filenames here:
from os.path import join
#configfile: "full_hla_types.json"

sample = ["DNA_483-SC-01-B6_9-3-21_133_060_S138_L002"]

peptide_path = "/scratch/eknodel/SCC_samples/Progeny/peptides/"

rule all:
    input:
        expand("/scratch/eknodel/SCC_samples/Progeny/netMHCpan/{sample}_WT_gatk_netmhc4.0.xsl", sample=sample),
        expand("/scratch/eknodel/SCC_samples/Progeny/netMHCpan/{sample}_gatk_netmhc4.0.xsl", sample=sample), # Calculate dissociation constant
        expand("/scratch/eknodel/SCC_samples/Progeny/netMHCpan/{sample}_gatk_netCTLpan.xsl", sample=sample),
        expand("/scratch/eknodel/SCC_samples/Progeny/netMHCpan/{sample}_gatk_netmhc_stab.xsl", sample=sample)

rule netMHC:
    input:
        peptides_gatk = os.path.join(peptide_path + "{sample}_gatk_vep_filtered.peptide_formatted"),
        peptides_strelka = os.path.join(peptide_path + "{sample}_strelka_vep_filtered.peptide_formatted")
    output:
        netMHC_gatk = os.path.join("/scratch/eknodel/SCC_samples/Progeny/netMHCpan/{sample}_gatk_netmhc4.0.xsl"),
        netMHC_strelka = os.path.join("/scratch/eknodel/SCC_samples/Progeny/netMHCpan/{sample}_strelka_netmhc4.0.xsl")
    params:
        hla = "H-2-Dd,H-2-Kd,H-2-Ld"
    shell:
        """
        ~/bin/netMHCpan-4.0/netMHCpan -a {params.hla} -f {input.peptides_gatk} -BA -s -xls -l 9  -xlsfile {output.netMHC_gatk};
        ~/bin/netMHCpan-4.0/netMHCpan -a {params.hla} -f {input.peptides_strelka} -BA -s -xls -l 9  -xlsfile {output.netMHC_strelka};
        """

rule netMHC_WT:
    input:
        peptides_gatk = os.path.join(peptide_path + "{sample}_gatk_vep_filtered.WT_peptide_formatted")
    output:
        netMHC_gatk = os.path.join("/scratch/eknodel/SCC_samples/Progeny/netMHCpan/{sample}_WT_gatk_netmhc4.0.xsl")
    params:
        hla = "H-2-Dd,H-2-Kd,H-2-Ld"
    shell:
        """
        ~/bin/netMHCpan-4.0/netMHCpan -a {params.hla} -f {input.peptides_gatk} -BA -s -xls -l 9  -xlsfile {output.netMHC_gatk};
        """

rule netMHCstab:
    input:
        peptides_gatk = os.path.join(peptide_path + "{sample}_gatk_vep_filtered.peptide_formatted")
    output:
        netMHCstab_gatk = os.path.join("/scratch/eknodel/SCC_samples/Progeny/netMHCpan/{sample}_gatk_netmhc_stab.xsl")
    params:
        hla = "H-2-Dd,H-2-Kd,H-2-Ld"
    shell:
        """
        netMHCstabpan -a {params.hla} -f {input.peptides_gatk} -s -xls -l 9  -xlsfile {output.netMHCstab_gatk};
        """

rule netCTLpan:
    input:
        peptides_gatk = os.path.join(peptide_path + "{sample}_gatk_vep_filtered.peptide_formatted")
    output:
        netCTLpan_gatk = os.path.join("/scratch/eknodel/SCC_samples/Progeny/netMHCpan/{sample}_gatk_netCTLpan.xsl")
    params:
        hla = "H-2-Dd" # Using just the TAP and Cleavage scores, so doing just one allele to save time
    shell:
        """
        netCTLpan -a {params.hla} -f {input.peptides_gatk} -s -xls -l 9  -xlsfile {output.netCTLpan_gatk};
        """
