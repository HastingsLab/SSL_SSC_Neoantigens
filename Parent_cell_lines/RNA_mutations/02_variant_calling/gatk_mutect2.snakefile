import os

sample = ["185-1-5c-01-F11-6-26-21-1_216_361_S9_L003", "188-2-5c-05-F11-6-22-21_274_303_S20_L003", "244-1-chu-06-D12-7-9-21-1_284_293_S35_L003",
           "185-1-5c-01-F11-6-26-21-2_204_373_S10_L003", "188-2-5c-05-F11-6-3-21_239_338_S15_L003",    "244-1-chu-06-D12-7-9-21-2_272_305_S36_L003",
           "185-1-5c-01-F11-6-26-21-3_287_290_S11_L003", "188-2-5c-05-F11-6-6-21_227_350_S16_L003",    "244-chu-06-F5-6-26-21_285_292_S27_L003",
           "185-1-5c-01-F11-6-26-21-4_275_302_S12_L003", "188-2-5c-05-F11-6-9-21_215_362_S17_L003",    "244-chu-06-F5-7-2-21-1_273_304_S28_L003",
           "185-1-5c-01-F11-6-26-21-5_263_314_S13_L003", "244-1-chu-02-B7-6-11-21_226_351_S24_L003",   "244-chu-06-F5-7-2-21-2_261_316_S29_L003",
           "185-1-5c-01-F11-6-26-21-6_251_326_S14_L003", "244-1-chu-02-B7-6-15-21_214_363_S25_L003",   "244-chu-06-F5-7-2-21-3_249_328_S30_L003",
           "185-15c-09-G9-6-11-21_252_325_S6_L003",      "244-1-chu-02-B7-6-22-21_202_375_S26_L003",   "244-chu-06-F5-7-9-21-1_237_340_S31_L003",
           "185-15c-09-G9-6-15-21_240_337_S7_L003",      "244-1-chu-02-B7-6-3-21_262_315_S21_L003",    "244-chu-06-F5-7-9-21-2_225_352_S32_L003",
           "185-15c-09-G9-6-22-21_228_349_S8_L003",      "244-1-chu-02-B7-6-6-21_250_327_S22_L003",
           "185-15c-09-G9-6-3-21_288_289_S3_L003",       "244-1-chu-02-B7-6-9-21_238_339_S23_L003",
           "185-15c-09-G9-6-6-21_276_301_S4_L003",       "244-1-chu-06-D12-6-22-21_213_364_S33_L003",
           "185-15c-09-G9-6-9-21_264_313_S5_L003",       "244-1-chu-06-D12-6-26-21_201_376_S34_L003",
           "188-2-5c-05-F11-6-11-21_203_374_S18_L003",   "244-1-chu-06-D12-7-12-21-1_260_317_S37_L003",
           "188-2-5c-05-F11-6-15-21_286_291_S19_L003",   "244-1-chu-06-D12-7-12-21-2_248_329_S38_L003"]

ref_dir = "/data/CEM/shared/public_data/references/ensemble_GRCm38.68/"
ref_basename = "GRCm38_68"
bam_dir = "/scratch/eknodel/SCC_samples/cell_lines/RNAseq/sorted_bam/"
gatk_dir = "/scratch/eknodel/SCC_samples/cell_lines/RNAseq/gatk_mutect2/"

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
