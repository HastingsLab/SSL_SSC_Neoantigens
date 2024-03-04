import os

samples = ["gDNA_185_25_2E1_5C_365_212_S56_L004", "gDNA_188_25_2E2_5C_157_036_S57_L004", "gDNA_190_25_2E2_5C_341_236_S58_L004",
"gDNA_244_25_2E1_chu_329_248_S59_L004", "gDNA_normal_tissue_377_200_S55_L004"]

ref_dir = "/scratch/eknodel/SCC_samples/reference/"
ref_basename = "GRCm38_68"
bam_dir = "/scratch/eknodel/SCC_samples/Parent_tumors/processed_bams/"

rule all:
    input:
        os.path.join(ref_dir, ref_basename + ".fa.fai"),
        os.path.join(ref_dir, ref_basename + ".dict"),
        os.path.join(ref_dir, ref_basename + ".fa.amb"),
        expand(os.path.join(bam_dir, "{sample}." + ref_basename + ".sorted.bam"), sample=sample)

rule prep_refs:
    input:
        os.path.join(ref_dir, ref_basename + ".fa")
    output:
        fai = os.path.join(ref_dir, ref_basename + ".fa.fai"),
        dict = os.path.join(ref_dir, ref_basename + ".dict"),
        amb = os.path.join(ref_dir, ref_basename + ".fa.amb")
    shell:
        """
        samtools faidx {input};
        samtools dict -o {output.dict} {input};
        bwa index {input}
        """

rule map:
    input:
        fq_1 = "/scratch/eknodel/SCC_samples/Parent_tumors/trimmed_fastqs/{sample}_trimmed_read1.fastq.gz",
        fq_2 = "/scratch/eknodel/SCC_samples/Parent_tumors/trimmed_fastqs/{sample}_trimmed_read2.fastq.gz",
        fai = os.path.join(ref_dir, ref_basename + ".fa.fai"),
        ref = os.path.join(ref_dir, ref_basename + ".fa")
    output:
        os.path.join("/scratch/eknodel/SCC_samples/Parent_tumors/processed_bams/{sample}." + ref_basename + ".sorted.bam")
    params:
        id = "{sample}",
        sm = "{sample}",
        lb = "{sample}",
        pu = "{sample}",
        pl = "Illumina"
    threads:
        4
    shell:
        "bwa mem -t {threads} -R "
        "'@RG\\tID:{params.id}\\tSM:{params.sm}\\tLB:{params.lb}\\tPU:{params.pu}\\tPL:{params.pl}' "
        "{input.ref} {input.fq_1} {input.fq_2}"
        " | samtools fixmate -O bam - - | samtools sort "
        "-O bam -o {output}"

# TODO: index bam
