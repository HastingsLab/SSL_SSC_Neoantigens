import os

sample = ["DNA_483-SC-01-B6_9-3-21_133_060_S138_L002"]

ref_dir = "/data/CEM/shared/public_data/references/ensemble_GRCm38.68/"
ref_basename = "GRCm38_68"
bam_dir = "/scratch/eknodel/SCC_samples/cell_lines/Progeny/processed_bams/"

rule all:
    input:
        expand(os.path.join(bam_dir, "{sample}." + ref_basename + ".sorted.bam"), sample=sample)


rule map:
    input:
        fq_1 = "/scratch/eknodel/SCC_samples/cell_lines/Progeny/trimmed_fastqs/{sample}_trimmed_read1.fastq.gz",
        fq_2 = "/scratch/eknodel/SCC_samples/cell_lines/Progeny/trimmed_fastqs/{sample}_trimmed_read2.fastq.gz",
        fai = os.path.join(ref_dir, ref_basename + ".fa.fai"),
        ref = os.path.join(ref_dir, ref_basename + ".fa")
    output:
        os.path.join("/scratch/eknodel/SCC_samples/cell_lines/Progeny/processed_bams/{sample}." + ref_basename + ".sorted.bam")
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
