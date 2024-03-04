import os

sample = ["185_1_SC_01_F11_364_213_S1_L003", "244_1_Chu_06_D12_316_261_S5_L003", "185_1_SC_01_F11_364_213_S1_L003", "244_1_Chu_06_F5_328_249_S4_L003",
"185_1_SC_09_G9_304_273_S6_L003", "244_1_Chu_06_F5_328_249_S4_L003", "185_1_SC_09_G9_304_273_S6_L003", "188_2_SC_05_F11_340_237_S3_L003",
"188_2_SC_05_F11_340_237_S3_L003", "244_1_Chu_02_B7_352_225_S2_L003", "244_1_Chu_02_B7_352_225_S2_L003", "244_1_Chu_06_D12_316_261_S5_L003"]

ref_dir = "/scratch/eknodel/SCC_samples/reference/"
ref_basename = "GRCm38_68"
bam_dir = "/scratch/eknodel/SCC_samples/cell_lines/processed_bams/"

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
        fq_1 = "/scratch/eknodel/SCC_samples/cell_lines/trimmed_fastqs/{sample}_trimmed_read1.fastq.gz",
        fq_2 = "/scratch/eknodel/SCC_samples/cell_lines/trimmed_fastqs/{sample}_trimmed_read2.fastq.gz",
        fai = os.path.join(ref_dir, ref_basename + ".fa.fai"),
        ref = os.path.join(ref_dir, ref_basename + ".fa")
    output:
        os.path.join("/scratch/eknodel/SCC_samples/cell_lines/processed_bams/{sample}." + ref_basename + ".sorted.bam")
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
