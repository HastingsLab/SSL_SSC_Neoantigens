import os

sample = ["gDNA_185_25_2E1_5C_365_212_S56_L004", "gDNA_190_25_2E2_5C_341_236_S58_L004",
"gDNA_188_25_2E2_5C_157_036_S57_L004","gDNA_244_25_2E1_chu_329_248_S59_L004"]

normal = ["gDNA_normal_tissue_377_200_S55_L004"]

ref_dir = "/scratch/eknodel/SCC_samples/reference/"
ref_basename = "GRCm38_68"
bam_dir = "/scratch/eknodel/SCC_samples/processed_bams/"
varscan_path = "/scratch/eknodel/SCC_samples/varscan_cnv/"

rule all:
    input:
#        expand("/scratch/eknodel/SCC_samples/pileups/{sample}.pileup", sample=sample),
#        expand(os.path.join(bam_dir, "{sample}." + ref_basename + ".sorted.bam.bai"), sample=sample),
       expand(os.path.join(varscan_path, "{sample}.copynumber.called"), sample=sample)

rule bam_pileup: #for both normal and tumor
    input:
        ref = os.path.join(ref_dir, ref_basename + ".fa"),
        bam_tumor = os.path.join(bam_dir, "{sample}." + ref_basename + ".sorted.bam"),
        bam_normal = os.path.join(bam_dir, "gDNA_normal_tissue_377_200_S55_L004." + ref_basename + ".sorted.bam")
    output:
        pileup = "/scratch/eknodel/SCC_samples/pileups/{sample}.pileup"
    threads: 4
    shell:
        """
        samtools mpileup -f {input.ref} {input.bam_normal} {input.bam_tumor} > {output.pileup}
        """

rule bam_index: 
    input: 
        bam = os.path.join(bam_dir, "{sample}." + ref_basename + ".sorted.bam")
    output:
        bai = os.path.join(bam_dir, "{sample}." + ref_basename + ".sorted.bam.bai")
    threads: 4
    shell:
        """
        samtools index {input.bam}
        """

rule varscan_cnv: 
    input: 
        pileup = "/scratch/eknodel/SCC_samples/pileups/{sample}.pileup"
    output: 
        output = os.path.join(varscan_path, "{sample}.copynumber")        
    params:
        varscan = "/home/eknodel/external_scripts/VarScan.v2.3.9.jar",
        sample = "{sample}"
    shell: 
        """
        java -jar {params.varscan} copynumber {input.pileup} {params.sample} --mpileup 1
        """

rule gc_adjustment:
    input: 
        cn = os.path.join(varscan_path, "{sample}.copynumber")
    output: 
        cn = os.path.join(varscan_path, "{sample}.copynumber.called")
    params: 
        varscan = "/home/eknodel/external_scripts/VarScan.v2.3.9.jar" 
    shell:
        """
        java -jar {params.varscan} copyCaller {input.cn} --output-file {output.cn}
        """
