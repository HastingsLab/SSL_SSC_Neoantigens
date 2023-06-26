# Setting up filenames here:
from os.path import join
#configfile: "full_hla_types.json"

sample = ["DNA_483-SC-01-B6_9-3-21_133_060_S138_L002"]

peptide_path = "/scratch/eknodel/SCC_samples/Progeny/peptides/"

rule all:
    input:
        expand(os.path.join(peptide_path + "{sample}_gatk_vep_filtered.peptide_formatted"), sample=sample, peptide_path=peptide_path),
        expand(os.path.join(peptide_path + "{sample}_gatk_vep_filtered.WT_peptide_formatted"), sample=sample, peptide_path=peptide_path),
        #expand("/scratch/eknodel/SCC_samples/Progeny/netMHCpan/{sample}_WT_gatk_netmhc.xsl", sample=sample),
        expand("/scratch/eknodel/SCC_samples/Progeny/netMHCpan/{sample}_gatk_netmhc.xsl", sample=sample) # Calculate dissociation constant
        #expand("/scratch/eknodel/SCC_samples/Progeny/netMHCpan/{sample}_gatk_netmhcII.xsl", sample=sample)

rule prepare_input: 
    input: 
        peptides_gatk = os.path.join(peptide_path + "{sample}_gatk_vep_filtered.peptides"),
        peptides_gatk_29 = os.path.join(peptide_path, "{sample}_gatk_vep_filtered_29.peptides"),
        peptides_strelka = os.path.join(peptide_path + "{sample}_strelka_vep_filtered.peptides")
    output: 
        peptides_gatk = os.path.join(peptide_path + "{sample}_gatk_vep_filtered.peptide_formatted"),
        peptides_gatk_29 = os.path.join(peptide_path + "{sample}_gatk_vep_filtered_29.peptide_formatted"),
        peptides_strelka = os.path.join(peptide_path + "{sample}_strelka_vep_filtered.peptide_formatted")
    shell:
        """
        cat {input.peptides_gatk} | awk '{{print $1"."$7, $8}}' | sed 's/>MT/>/' | sed 's/ /\\n/g' > {output.peptides_gatk};
        cat {input.peptides_gatk_29} | awk '{{print $1"."$7, $8}}' | sed 's/>MT/>/' | sed 's/ /\\n/g' > {output.peptides_gatk_29};
        cat {input.peptides_strelka} | awk '{{print $1"."$7, $8}}' | sed 's/>MT/>/' | sed 's/ /\\n/g' > {output.peptides_strelka}
        """

rule prepare_input_WT:
    input:
        peptides_gatk = os.path.join(peptide_path + "{sample}_gatk_vep_filtered_WT.peptides"),
        peptides_gatk_29 = os.path.join(peptide_path, "{sample}_gatk_vep_filtered_29_WT.peptides"),
        peptides_strelka = os.path.join(peptide_path + "{sample}_strelka_vep_filtered_WT.peptides")
    output:
        peptides_gatk = os.path.join(peptide_path + "{sample}_gatk_vep_filtered.WT_peptide_formatted"),
        peptides_gatk_29 = os.path.join(peptide_path + "{sample}_gatk_vep_filtered_29.WT_peptide_formatted"),
        peptides_strelka = os.path.join(peptide_path + "{sample}_strelka_vep_filtered.WT_peptide_formatted")
    shell:
        """
        cat {input.peptides_gatk} | awk '{{print $1"."$7, $8}}' | sed 's/>WT/>/' | sed 's/ /\\n/g' > {output.peptides_gatk};
        cat {input.peptides_gatk_29} | awk '{{print $1"."$7, $8}}' | sed 's/>WT/>/' | sed 's/ /\\n/g' > {output.peptides_gatk_29};
        cat {input.peptides_strelka} | awk '{{print $1"."$7, $8}}' | sed 's/>WT/>/' | sed 's/ /\\n/g' > {output.peptides_strelka}
        """

rule netMHC:
    input:
        peptides_gatk = os.path.join(peptide_path + "{sample}_gatk_vep_filtered.peptide_formatted"),
        peptides_strelka = os.path.join(peptide_path + "{sample}_strelka_vep_filtered.peptide_formatted")
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

rule netMHC_WT:
    input:
        peptides_gatk = os.path.join(peptide_path + "{sample}_gatk_vep_filtered.WT_peptide_formatted"),
        peptides_strelka = os.path.join(peptide_path + "{sample}_strelka_vep_filtered.WT_peptide_formatted")
    output:
        netMHC_gatk = os.path.join("/scratch/eknodel/SCC_samples/Progeny/netMHCpan/{sample}_WT_gatk_netmhc.xsl"),
        netMHC_strelka = os.path.join("/scratch/eknodel/SCC_samples/Progeny/netMHCpan/{sample}_WT_strelka_netmhc.xsl")
    params:
        hla = "H-2-Dd,H-2-Kd,H-2-Ld"
    shell:
        """
        netMHCpan -a {params.hla} -f {input.peptides_gatk} -BA -s -xls -l 9  -xlsfile {output.netMHC_gatk};
        netMHCpan -a {params.hla} -f {input.peptides_strelka} -BA -s -xls -l 9  -xlsfile {output.netMHC_strelka};
        """

rule netMHCII:
    input:
        peptides_gatk = os.path.join(peptide_path + "{sample}_gatk_vep_filtered_29.peptide_formatted")
    output:
        netMHC_gatk = os.path.join("/scratch/eknodel/SCC_samples/Progeny/netMHCpan/{sample}_gatk_netmhcII.xsl")
    params:
        hla = "H-2-IAd,H-2-IEd"
    shell:
        """
        ~/bin/netMHCIIpan-4.1/netMHCIIpan -a {params.hla} -f {input.peptides_gatk} -BA -s -xls -length 15  -xlsfile {output.netMHC_gatk};
        """

