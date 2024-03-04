# Setting up filenames here:
from os.path import join
#configfile: "full_hla_types.json"

sample = ["185_1_SC_01_F11_364_213_S1_L003", "185_1_SC_09_G9_304_273_S6_L003", 
"188_2_SC_05_F11_340_237_S3_L003","244_1_Chu_02_B7_352_225_S2_L003", 
"244_1_Chu_06_D12_316_261_S5_L003", "244_1_Chu_06_F5_328_249_S4_L003"]

peptide_path = "/scratch/eknodel/SCC_samples/cell_lines/peptides/"

rule all:
    input:
        expand("/scratch/eknodel/SCC_samples/cell_lines/netMHCpan/{sample}_15_netmhcII.xsl", sample=sample) # Calculate dissociation constant


rule prepare_input: 
    input: 
        peptides_29 = os.path.join(peptide_path + "{sample}_vep.29.peptide"),
        peptides_31 = os.path.join(peptide_path + "{sample}_vep.31.peptide"),
        peptides_33 = os.path.join(peptide_path + "{sample}_vep.33.peptide"),
        peptides_35 = os.path.join(peptide_path + "{sample}_vep.35.peptide"),
        peptides_37 = os.path.join(peptide_path + "{sample}_vep.37.peptide"),
        peptides_39 = os.path.join(peptide_path + "{sample}_vep.39.peptide")
    output:
        peptides_29 = os.path.join(peptide_path + "{sample}.29.peptide_formatted"),
        peptides_31 = os.path.join(peptide_path + "{sample}.31.peptide_formatted"),
        peptides_33 = os.path.join(peptide_path + "{sample}.33.peptide_formatted"),
        peptides_35 = os.path.join(peptide_path + "{sample}.35.peptide_formatted"),
        peptides_37 = os.path.join(peptide_path + "{sample}.37.peptide_formatted"),
        peptides_39 = os.path.join(peptide_path + "{sample}.39.peptide_formatted")
    shell:
        """
        cat {input.peptides_29} | sed '/>WT/,+1 d' > {output.peptides_29};
        cat {input.peptides_31} | sed '/>WT/,+1 d' > {output.peptides_31};
        cat {input.peptides_33} | sed '/>WT/,+1 d' > {output.peptides_33};
        cat {input.peptides_35} | sed '/>WT/,+1 d' > {output.peptides_35};
        cat {input.peptides_37} | sed '/>WT/,+1 d' > {output.peptides_37};
        cat {input.peptides_39} | sed '/>WT/,+1 d' > {output.peptides_39}
        """

rule netMHC:
    input:
        peptides_29 = os.path.join(peptide_path + "{sample}.29.peptide_formatted"),
        peptides_31 = os.path.join(peptide_path + "{sample}.31.peptide_formatted"),
        peptides_33 = os.path.join(peptide_path + "{sample}.33.peptide_formatted"),
        peptides_35 = os.path.join(peptide_path + "{sample}.35.peptide_formatted"),
        peptides_37 = os.path.join(peptide_path + "{sample}.37.peptide_formatted"),
        peptides_39 = os.path.join(peptide_path + "{sample}.39.peptide_formatted")
    output:
        netMHC_15 = os.path.join("/scratch/eknodel/SCC_samples/cell_lines/netMHCpan/{sample}_15_netmhcII.xsl"),
        netMHC_16 = os.path.join("/scratch/eknodel/SCC_samples/cell_lines/netMHCpan/{sample}_16_netmhcII.xsl"),
        netMHC_17 = os.path.join("/scratch/eknodel/SCC_samples/cell_lines/netMHCpan/{sample}_17_netmhcII.xsl"),
        netMHC_18 = os.path.join("/scratch/eknodel/SCC_samples/cell_lines/netMHCpan/{sample}_18_netmhcII.xsl"),
        netMHC_19 = os.path.join("/scratch/eknodel/SCC_samples/cell_lines/netMHCpan/{sample}_19_netmhcII.xsl"),
    params:
        hla = "H-2-IAd,H-2-IEd"
    shell:
        """
        ~/bin/netMHCIIpan-4.1/netMHCIIpan -a {params.hla} -f {input.peptides_29} -BA -s -xls -length 15  -xlsfile {output.netMHC_15};
        ~/bin/netMHCIIpan-4.1/netMHCIIpan -a {params.hla} -f {input.peptides_31} -BA -s -xls -length 16  -xlsfile {output.netMHC_16};
        ~/bin/netMHCIIpan-4.1/netMHCIIpan -a {params.hla} -f {input.peptides_33} -BA -s -xls -length 17  -xlsfile {output.netMHC_17};
        ~/bin/netMHCIIpan-4.1/netMHCIIpan -a {params.hla} -f {input.peptides_35} -BA -s -xls -length 18  -xlsfile {output.netMHC_18};
        ~/bin/netMHCIIpan-4.1/netMHCIIpan -a {params.hla} -f {input.peptides_37} -BA -s -xls -length 19  -xlsfile {output.netMHC_19};
        """
