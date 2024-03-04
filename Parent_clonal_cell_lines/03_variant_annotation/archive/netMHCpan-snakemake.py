# Setting up filenames here:
from os.path import join
#configfile: "full_hla_types.json"

sample = ["185_1_SC_01_F11_364_213_S1_L003", "244_1_Chu_06_D12_316_261_S5_L003", "185_1_SC_01_F11_364_213_S1_L003", "244_1_Chu_06_F5_328_249_S4_L003",
"185_1_SC_09_G9_304_273_S6_L003", "244_1_Chu_06_F5_328_249_S4_L003", "185_1_SC_09_G9_304_273_S6_L003", "188_2_SC_05_F11_340_237_S3_L003",
"188_2_SC_05_F11_340_237_S3_L003", "244_1_Chu_02_B7_352_225_S2_L003", "244_1_Chu_02_B7_352_225_S2_L003", "244_1_Chu_06_D12_316_261_S5_L003"]

peptide_path = "/scratch/eknodel/SCC_samples/cell_lines/peptides/"

rule all:
    input:
        expand("/scratch/eknodel/SCC_samples/cell_lines/netMHCpan/{sample}_9_netmhc.xsl", sample=sample), # Calculate dissociation constant
        expand("/scratch/eknodel/SCC_samples/cell_lines/netMHCpan/{sample}_10_netmhc.xsl", sample=sample),
        expand("/scratch/eknodel/SCC_samples/cell_lines/netMHCpan/{sample}_11_netmhc.xsl", sample=sample),
        expand("/scratch/eknodel/SCC_samples/cell_lines/netMHCpan/{sample}_8_netmhc.xsl", sample=sample),
        expand("/scratch/eknodel/SCC_samples/cell_lines/netMHCstabpan/{sample}_9_netmhcstab.xsl", sample=sample) # Calculate binding stability

rule prepare_input: 
    input: 
        peptides_15 = os.path.join(peptide_path + "{sample}_vep.15.peptide"),
        peptides_17 = os.path.join(peptide_path + "{sample}_vep.17.peptide"),
        peptides_19 = os.path.join(peptide_path + "{sample}_vep.19.peptide"),
        peptides_21 = os.path.join(peptide_path + "{sample}_vep.21.peptide")
    output: 
        peptides_15 = os.path.join(peptide_path + "{sample}.15.peptide_formatted"),
        peptides_17 = os.path.join(peptide_path + "{sample}.17.peptide_formatted"),
        peptides_19 = os.path.join(peptide_path + "{sample}.19.peptide_formatted"),
        peptides_21 = os.path.join(peptide_path + "{sample}.21.peptide_formatted")
    shell:
        """
        cat {input.peptides_15} | sed '/>WT/,+1 d' > {output.peptides_15};
        cat {input.peptides_17} | sed '/>WT/,+1 d' > {output.peptides_17};
        cat {input.peptides_19} | sed '/>WT/,+1 d' > {output.peptides_19};
        cat {input.peptides_21} | sed '/>WT/,+1 d' > {output.peptides_21}
        """

rule netMHC:
    input:
        peptides_15 = os.path.join(peptide_path + "{sample}.15.peptide_formatted"),
        peptides_17 = os.path.join(peptide_path + "{sample}.17.peptide_formatted"),
        peptides_19 = os.path.join(peptide_path + "{sample}.19.peptide_formatted"),
        peptides_21 = os.path.join(peptide_path + "{sample}.21.peptide_formatted")
    output:
        netMHC_8  = os.path.join("/scratch/eknodel/SCC_samples/cell_lines/netMHCpan/{sample}_8_netmhc.xsl"),
        netMHC_9  = os.path.join("/scratch/eknodel/SCC_samples/cell_lines/netMHCpan/{sample}_9_netmhc.xsl"),
        netMHC_10 = os.path.join("/scratch/eknodel/SCC_samples/cell_lines/netMHCpan/{sample}_10_netmhc.xsl"),
        netMHC_11 = os.path.join("/scratch/eknodel/SCC_samples/cell_lines/netMHCpan/{sample}_11_netmhc.xsl"),
    params:
        hla = "H-2-Dd,H-2-Kd,H-2-Ld"
    shell:
        """
        netMHCpan -a {params.hla} -f {input.peptides_15} -BA -s -xls -l 8  -xlsfile {output.netMHC_8};
        netMHCpan -a {params.hla} -f {input.peptides_17} -BA -s -xls -l 9  -xlsfile {output.netMHC_9};
        netMHCpan -a {params.hla} -f {input.peptides_19} -BA -s -xls -l 10 -xlsfile {output.netMHC_10};
        netMHCpan -a {params.hla} -f {input.peptides_21} -BA -s -xls -l 11 -xlsfile {output.netMHC_11};
        """

