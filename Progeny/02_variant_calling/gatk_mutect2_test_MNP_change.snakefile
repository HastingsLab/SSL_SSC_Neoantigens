import os

sample = ["DNA_483-SC-01-B6_9-3-21_133_060_S138_L002"]
normal = ["gDNA_normal_tissue_377_200_S55_L004"]

ref_dir = "/data/CEM/shared/public_data/references/ensemble_GRCm38.68/"
ref_basename = "GRCm38_68"
bam_dir = "/scratch/eknodel/SCC_samples/Progeny/processed_bams/"
gatk_dir = "/scratch/eknodel/SCC_samples/Progeny/gatk_mutect2/"

rule all:
    input:
        expand(os.path.join(gatk_dir, "{subject}_mnp_split.somatic.vcf.gz"), subject=sample),
        expand(os.path.join(gatk_dir, "{subject}_mnp_split.somatic.filtered.vcf.gz"), subject=sample),
        expand(os.path.join(gatk_dir, "{subject}_mnp_split.somatic.filtered.pass.vcf.gz"), subject=sample)

rule tumor_with_matched_normal:
    input:
        ref = os.path.join(ref_dir, ref_basename + ".fa"),
        normal_bam = os.path.join(bam_dir,  "gDNA_normal_tissue_377_200_S55_L004." + ref_basename + ".sorted.bam"),
        tumor_bam =  os.path.join(bam_dir, "{subject}." + ref_basename + ".sorted.bam")
    output:
        os.path.join(gatk_dir, "{subject}_mnp_split.somatic.vcf.gz")
    params:
        gatk = "/home/eknodel/gatk-4.1.7.0/gatk",
        sm = "gDNA_normal_tissue_377_200_S55_L004"
    shell:
        """
        {params.gatk} Mutect2 -R {input.ref} -I {input.tumor_bam} -I {input.normal_bam} -normal {params.sm} -O {output} --max-mnp-distance 0
        """

rule filter:
    input:
        ref = os.path.join(ref_dir, ref_basename + ".fa"),
        unfiltered = os.path.join(gatk_dir, "{subject}_mnp_split.somatic.vcf.gz")
    output:
        filtered = os.path.join(gatk_dir, "{subject}_mnp_split.somatic.filtered.vcf.gz")
    params:
        gatk ="/home/eknodel/gatk-4.1.7.0/gatk"
    shell:
        """
        {params.gatk} FilterMutectCalls -R {input.ref} -V {input.unfiltered} -O {output.filtered}
        """

rule select_pass_variants:
    input:
        ref = os.path.join(ref_dir, ref_basename + ".fa"),
        vcf = os.path.join(gatk_dir, "{subject}_mnp_split.somatic.filtered.vcf.gz")
    output:
        os.path.join(gatk_dir, "{subject}_mnp_split.somatic.filtered.pass.vcf.gz")
    params:
        gatk = "/home/eknodel/gatk-4.1.7.0/gatk"
    shell:
        """
        {params.gatk} SelectVariants -R {input.ref} -V {input.vcf} --exclude-filtered -O {output}
        """