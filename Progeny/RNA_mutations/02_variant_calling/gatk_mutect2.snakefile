import os

# Samples
sample = ["483_sc_01_B6-1_366_211_S58_L003", "483_sc_01_B6-2_354_223_S59_L003"]

ref_dir = "/data/CEM/shared/public_data/references/ensemble_GRCm38.68/"
ref_basename = "GRCm38_68"
bam_dir = "/scratch/eknodel/SCC_samples/cell_lines/Progeny/RNAseq/sorted_bam/"
gatk_dir = "/scratch/eknodel/SCC_samples/cell_lines/Progeny/RNAseq/gatk_mutect2/"

rule all:
    input:
        expand(os.path.join(gatk_dir, "{subject}.somatic.vcf.gz"), subject=sample),
        expand(os.path.join(gatk_dir, "{subject}.somatic.filtered.vcf.gz"), subject=sample),
        expand(os.path.join(gatk_dir, "{subject}.somatic.filtered.pass.vcf.gz"), subject=sample)

rule add_readgroup:
    input:
        tumor_bam =  os.path.join(bam_dir, "{subject}" + "_RNA_HISAT2_genome_aligned_sortedbycoord.bam")
    output:
        tumor_bam =  os.path.join(bam_dir, "{subject}" + "_RNA_HISAT2_genome_aligned_sortedbycoord_RG.bam")
    shell:
        """
        picard AddOrReplaceReadGroups I={input.tumor_bam} O={output.tumor_bam} RGID=1 RGLB=lib2 RGPL=illumina RGPU=unit1 RGSM=1
        """

rule index:
    input:
        tumor_bam =  os.path.join(bam_dir, "{subject}" + "_RNA_HISAT2_genome_aligned_sortedbycoord_RG.bam")
    output:
        tumor_bam =  os.path.join(bam_dir, "{subject}" + "_RNA_HISAT2_genome_aligned_sortedbycoord_RG.bam.bai")
    shell:
        """
        picard BuildBamIndex INPUT={input.tumor_bam}
        """

rule SplitNCigarReads:
    input:
        tumor_bam =  os.path.join(bam_dir, "{subject}" + "_RNA_HISAT2_genome_aligned_sortedbycoord_RG.bam"),
        ref = os.path.join(ref_dir, ref_basename + ".fa")
    output:
        tumor_bam =  os.path.join(bam_dir, "{subject}" + "_RNA_HISAT2_genome_aligned_sortedbycoord_RG-splitreads.bam")
    params:
        gatk = "/home/eknodel/gatk-4.1.7.0/gatk"
    shell:
        """
        {params.gatk} SplitNCigarReads -R {input.ref} -I {input.tumor_bam} -O {output.tumor_bam}
        """

rule tumor_only:
    input:
        ref = os.path.join(ref_dir, ref_basename + ".fa"),
        tumor_bam =  os.path.join(bam_dir, "{subject}" + "_RNA_HISAT2_genome_aligned_sortedbycoord_RG-splitreads.bam")
    output:
        os.path.join(gatk_dir, "{subject}.somatic.vcf.gz")
    params:
        gatk = "/home/eknodel/gatk-4.1.7.0/gatk",
    shell:
        """
        {params.gatk} Mutect2 --java-options "-Xmx10G"  -R {input.ref} -I {input.tumor_bam} -O {output} --tmp-dir /data/CEM/shared/public_data/mouse_SCC_cell_lines
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
