import os

sample = ["244_1_Chu_02_B7_352_225_S2_L003"]
normal = ["gDNA_normal_tissue_377_200_S55_L004"]

ref_dir = "/data/CEM/shared/public_data/references/ensemble_GRCm38.68/"
ref_basename = "GRCm38_68"
bam_dir = "/scratch/eknodel/SCC_samples/Parent_cell_lines/processed_bams/"
gatk_dir = "/scratch/eknodel/SCC_samples/Parent_cell_lines/gatk_mutect2/"

rule all:
    input:
        expand(os.path.join(gatk_dir, "{subject}.somatic.vcf.gz"), subject=sample),
        expand(os.path.join(gatk_dir, "{subject}.somatic.filtered.vcf.gz"), subject=sample),
        expand(os.path.join(gatk_dir, "{subject}.somatic.filtered.pass.vcf.gz"), subject=sample)

rule tumor_with_matched_normal:
    input:
        ref = os.path.join(ref_dir, ref_basename + ".fa"),
        normal_bam = os.path.join(bam_dir,  "gDNA_normal_tissue_377_200_S55_L004." + ref_basename + ".sorted.bam"),
        tumor_bam =  os.path.join(bam_dir, "{subject}." + ref_basename + ".sorted.bam")
    output:
        os.path.join(gatk_dir, "{subject}.somatic.vcf.gz")
    params:
        gatk = "/home/eknodel/gatk-4.1.7.0/gatk",
        sm = "gDNA_normal_tissue_377_200_S55_L004"
    shell:
        """
        {params.gatk} Mutect2 -R {input.ref} -I {input.tumor_bam} -I {input.normal_bam} -normal {params.sm} -O {output}
        """

rule filter:
    input:
        ref = os.path.join(ref_dir, ref_basename + ".fa"),
        unfiltered = os.path.join(gatk_dir, "{subject}.somatic.vcf.gz")
    output:
        filtered = os.path.join(gatk_dir, "{subject}.somatic.filtered.vcf.gz")
    params:
        gatk ="/home/eknodel/gatk-4.1.7.0/gatk"
    shell:
        """
        {params.gatk} FilterMutectCalls -R {input.ref} -V {input.unfiltered} -O {output.filtered}
        """

rule select_pass_variants:
    input:
        ref = os.path.join(ref_dir, ref_basename + ".fa"),
        vcf = os.path.join(gatk_dir, "{subject}.somatic.filtered.vcf.gz")
    output:
        os.path.join(gatk_dir, "{subject}.somatic.filtered.pass.vcf.gz")
    params:
        gatk = "/home/eknodel/gatk-4.1.7.0/gatk"
    shell:
        """
        {params.gatk} SelectVariants -R {input.ref} -V {input.vcf} --exclude-filtered -O {output}
        """
