# Setting up filesnames here:

from os.path import join
import os

sample = ["gDNA_185_25_2E1_5C_365_212_S56_L004",  "gDNA_188_25_2E2_5C_157_036_S57_L004",  "gDNA_244_25_2E1_chu_329_248_S59_L004"]
#sample = ["gDNA_185_25_2E1_5C_365_212_S56_L004"]
normal = ["gDNA_normal_tissue_377_200_S55_L004"]

# Reference genome
ref_dir = "/data/CEM/shared/public_data/references/ensemble_GRCm38.68/"
ref_basename = "GRCm38_68"

# Directory Pathways
bam_dir = "/scratch/eknodel/SCC_samples/Parent_tumors/processed_bams/"

rule all:
    input:
        "targets_C.preprocessed.interval_list",
        #expand(os.path.join(bam_dir, "{subject}." + ref_basename + ".sorted.mkdup.bam.bai"), subject=sample),
        #os.path.join(bam_dir, "gDNA_normal_tissue_377_200_S55_L004." + ref_basename + ".sorted.mkdup.bam.bai"),
        expand("cnv_files/{subject}_tumor.counts.hdf5", subject=sample),
        expand("cnv_files/{normal}_normal.counts.hdf5", normal=normal),
        expand("cnv_files/{subject}_tumor.standardizedCR.tsv", subject=sample),
        expand("cnv_files/{normal}_normal.standardizedCR.tsv", normal=normal),
        expand("cnv_plots/{subject}_tumor.denoised.png", subject=sample),
        expand("cnv_plots/{normal}_normal.denoised.png", normal=normal),
        #expand("cnv_files/{subject}_tumor.allelicCounts.tsv", subject=sample),
        #expand("cnv_files/{normal}_normal.allelicCounts.tsv", normal=normal),
        #expand("cnv_files/{subject}.hets.tsv", subject=sample),
        #expand("cnv_plots/{subject}.png", subject=sample)
    
rule process_intervals:
    input:
        ref = os.path.join(ref_dir, ref_basename + ".fa")
    output:
        intervals = "targets_C.preprocessed.interval_list"
    shell:
        """
        /home/eknodel/gatk-4.1.7.0/gatk PreprocessIntervals \
        -L /data/CEM/shared/public_data/references/ensemble_GRCm38.68/GRCm38_68.interval_list \
        -R {input.ref} \
        --bin-length 0 \
        --padding 250 \
        --interval-merging-rule OVERLAPPING_ONLY \
        -O {output.intervals}
        """
        #--interval-merging-rule OVERLAPPING_ONLY \

rule mark_duplicates: 
    input:
        bam = os.path.join(bam_dir, "{subject}." + ref_basename + ".sorted.bam")
    output: 
        bam = os.path.join(bam_dir, "{subject}." + ref_basename + ".sorted.mkduo.bam"),
        metrics = os.path.join("processed_bams/{subject}_tumor.picard_mkdup_metrics.txt")
    shell:
        "picard -Xmx14g MarkDuplicates I={input.bam} O={output.bam} M={output.metrics}"

rule mark_duplicates_normal:
    input:
        bam = os.path.join(bam_dir, "{normal}." + ref_basename + ".sorted.bam")
    output:
        bam = os.path.join(bam_dir, "{normal}." + ref_basename + ".sorted.mkdup.bam"),
        metrics = os.path.join("processed_bams/{normal}_normal.picard_mkdup_metrics.txt")
    shell:
        "picard -Xmx14g MarkDuplicates I={input.bam} O={output.bam} M={output.metrics}"

rule index_mkdup:
    input:
        os.path.join(bam_dir, "{subject}." + ref_basename + ".sorted.mkdup.bam")
    output:
        os.path.join(bam_dir, "{subject}." + ref_basename + ".sorted.mkdup.bam.bai")
    shell:
        "samtools index {input}"

rule index_mkdup_normal:
    input: 
        os.path.join(bam_dir, "gDNA_normal_tissue_377_200_S55_L004." + ref_basename + ".sorted.mkdup.bam")
    output:
        os.path.join(bam_dir, "gDNA_normal_tissue_377_200_S55_L004." + ref_basename + ".sorted.mkdup.bam.bai")
    shell: 
        "samtools index {input}"

rule collect_fragment_counts:
    input: 
        bam = os.path.join(bam_dir, "{subject}." + ref_basename + ".sorted.mkdup.bam"), 
        intervals = "targets_C.preprocessed.interval_list",
        ref = os.path.join(ref_dir, ref_basename + ".fa")
    output:
        out = "cnv_files/{subject}_tumor.counts.hdf5"
    shell:
        """
        /home/eknodel/gatk-4.1.7.0/gatk CollectReadCounts \
        -I {input.bam} \
        -L {input.intervals} \
        --interval-merging-rule OVERLAPPING_ONLY \
        -O {output.out}
        """

rule collect_fragment_counts_normal: 
    input: 
        bam = os.path.join(bam_dir, "{normal}." + ref_basename + ".sorted.mkdup.bam"),
        intervals = "targets_C.preprocessed.interval_list",
        ref = os.path.join(ref_dir, ref_basename + ".fa")
    output: 
        out = "cnv_files/{normal}_normal.counts.hdf5"
    shell:
        """
        /home/eknodel/gatk-4.1.7.0/gatk CollectReadCounts \
        -I {input.bam} \
        -L {input.intervals} \
        --interval-merging-rule OVERLAPPING_ONLY \
        -O {output.out}
        """

rule panel_of_normals: 
    input: 
        "cnv_files/gDNA_normal_tissue_377_200_S55_L004_normal.counts.hdf5"
    output: 
        "cnv_files/pon.hdf5"
    shell: 
        """
        /home/eknodel/gatk-4.1.7.0/gatk CreateReadCountPanelOfNormals \
        -I {input} \
        -O {output} \
        """

rule standardize_tumor:
    input: 
        tumor = "cnv_files/{subject}_tumor.counts.hdf5",
        pon = "cnv_files/pon.hdf5"
    output:
        standardized = "cnv_files/{subject}_tumor.standardizedCR.tsv", 
        denoised = "cnv_files/{subject}_tumor.denoisedCR.tsv"
    shell:
        """
        /home/eknodel/gatk-4.1.7.0/gatk --java-options "-Xmx12g" DenoiseReadCounts \
        -I {input.tumor} \
        --count-panel-of-normals {input.pon} \
        --standardized-copy-ratios {output.standardized} \
        --denoised-copy-ratios {output.denoised}
        """

rule standardize_normal:
    input:
        normal = "cnv_files/{normal}_normal.counts.hdf5",
        pon = "cnv_files/pon.hdf5"
    output:
        standardized = "cnv_files/{normal}_normal.standardizedCR.tsv",
        denoised = "cnv_files/{normal}_normal.denoisedCR.tsv"
    shell:
        """
        /home/eknodel/gatk-4.1.7.0/gatk --java-options "-Xmx12g" DenoiseReadCounts \
        -I {input.normal} \
        --count-panel-of-normals {input.pon} \
        --standardized-copy-ratios {output.standardized} \
        --denoised-copy-ratios {output.denoised}
        """

rule plot_tumor:
    input:
        standardized = "cnv_files/{subject}_tumor.standardizedCR.tsv",
        denoised = "cnv_files/{subject}_tumor.denoisedCR.tsv"
    output:
        "cnv_plots/{subject}_tumor.denoised.png"
    params:
        dict = "/data/CEM/shared/public_data/references/ensemble_GRCm38.68/GRCm38_68.dict",
        prefix = "{subject}_tumor"
    shell:
        """
        /home/eknodel/gatk-4.1.7.0/gatk PlotDenoisedCopyRatios \
        --standardized-copy-ratios {input.standardized} \
        --denoised-copy-ratios {input.denoised} \
        --sequence-dictionary {params.dict} \
        --minimum-contig-length 1000000 \
        --output cnv_plots \
        --output-prefix {params.prefix}
        """

rule plot_normal:
    input:
        standardized = "cnv_files/{normal}_normal.standardizedCR.tsv",
        denoised = "cnv_files/{normal}_normal.denoisedCR.tsv"
    output:
        "cnv_plots/{normal}_normal.denoised.png"
    params:
        dict = "/data/CEM/shared/public_data/references/ensemble_GRCm38.68/GRCm38_68.dict",
        prefix = "{normal}_normal"
    shell:
        """
        /home/eknodel/gatk-4.1.7.0/gatk PlotDenoisedCopyRatios \
        --standardized-copy-ratios {input.standardized} \
        --denoised-copy-ratios {input.denoised} \
        --sequence-dictionary {params.dict} \
        --minimum-contig-length 1000000 \
        --output cnv_plots \
        --output-prefix {params.prefix}
        """

rule collect_allelic_counts:
    input:
        bam = os.path.join(bam_dir, "{subject}." + ref_basename + ".sorted.bam"),
        ref = os.path.join(ref_dir, ref_basename + ".fa"),
        snps = "/scratch/eknodel/SCC_samples/Parent_tumors/gatk_mutect2/gDNA_185_25_2E1_5C_365_212_S56_L004.somatic.filtered.pass.vcf"
    output:
        "cnv_files/{subject}_tumor.allelicCounts.tsv"
    shell:
        """
        /home/eknodel/gatk-4.1.7.0/gatk --java-options "-Xmx3g" CollectAllelicCounts \
        -L {input.snps} \
        -I {input.bam} \
        -R {input.ref} \
        -O {output}
        """

rule collect_allelic_counts_normal:
    input:
        bam = os.path.join(bam_dir, "{normal}." + ref_basename + ".sorted.bam"),
        ref = os.path.join(ref_dir, ref_basename + ".fa"),
        snps = "/scratch/eknodel/SCC_samples/Parent_tumors/gatk_mutect2/gDNA_185_25_2E1_5C_365_212_S56_L004.somatic.filtered.pass.vcf"
    output:
        "cnv_files/{normal}_normal.allelicCounts.tsv"
    shell:
        """
        /home/eknodel/gatk-4.1.7.0/gatk --java-options "-Xmx3g" CollectAllelicCounts \
        -L {input.snps} \
        -I {input.bam} \
        -R {input.ref} \
        -O {output}
        """


rule model_segments:
    input: 
        tumor = "cnv_files/{subject}_tumor.allelicCounts.tsv",
        normal = "cnv_files/gDNA_normal_tissue_377_200_S55_L004_normal.allelicCounts.tsv",
        denoised = "cnv_files/{subject}_tumor.denoisedCR.tsv"
    output:
        "cnv_files/{subject}.hets.tsv",
        segments = "cnv_files/{subject}.modelFinal.seg"
    params: 
        outdir = "cnv_files",
        prefix = "{subject}"
    shell:
        """
        /home/eknodel/gatk-4.1.7.0/gatk --java-options "-Xmx4g" ModelSegments \
        --allelic-counts {input.tumor} \
        --output {params.outdir} \
        --output-prefix {params.prefix}
        """

rule plot_model_segments:
    input:
        tumor = "cnv_files/{subject}_tumor.allelicCounts.tsv",
        normal = "cnv_files/gDNA_normal_tissue_377_200_S55_L004_normal.allelicCounts.tsv",
        denoised = "cnv_files/{subject}_tumor.denoisedCR.tsv",
        segments = "cnv_files/{subject}.modelFinal.seg"
    output: 
        "cnv_plots/{subject}.png"
    params: 
        dict = "/data/CEM/shared/public_data/references/ensemble_GRCm38.68/GRCm38_68.dict", 
        output_dir = "cnv_plots",
        output_prefix = "{subject}"
    shell:
        """
        /home/eknodel/gatk-4.1.7.0/gatk PlotModeledSegments --segments {input.segments} --denoised-copy-ratios {input.denoised} --allelic-counts {input.tumor} --sequence-dictionary {params.dict} --output {params.output_dir} --output-prefix {params.output_prefix}
        """
