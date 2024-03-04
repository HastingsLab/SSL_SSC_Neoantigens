import os

sample = ["185_1_SC_01_F11_364_213_S1_L003", "244_1_Chu_06_D12_316_261_S5_L003", "185_1_SC_01_F11_364_213_S1_L003", "244_1_Chu_06_F5_328_249_S4_L003",
"185_1_SC_09_G9_304_273_S6_L003", "244_1_Chu_06_F5_328_249_S4_L003", "185_1_SC_09_G9_304_273_S6_L003", "188_2_SC_05_F11_340_237_S3_L003",
"188_2_SC_05_F11_340_237_S3_L003", "244_1_Chu_02_B7_352_225_S2_L003", "244_1_Chu_02_B7_352_225_S2_L003", "244_1_Chu_06_D12_316_261_S5_L003"]

adapter_path = "/home/eknodel/Cancer_Genomics/00_misc/adapter_sequence.fa"
perl5lib_path = "/packages/6x/vcftools/0.1.12b/lib/per15/site_perl/"
fastqc = "/scratch/eknodel/SCC_samples/cell_lines/raw_fastqc_results/"
trimmed_fastqc = "/scratch/eknodel/SCC_samples/cell_lines/trimmed_fastqc_results/"

rule all:
    input:
        "/scratch/eknodel/SCC_samples/cell_lines/raw_multiqc_results/multiqc_report.html",
        "/scratch/eknodel/SCC_samples/cell_lines/trimmed_multiqc_results/multiqc_report.html",


rule fastqc_analysis:
    input:
        fq_1 = "{sample}_R1_001.fastq.gz",
        fq_2 = "{sample}_R2_001.fastq.gz"
    output:
        "/scratch/eknodel/SCC_samples/cell_lines/raw_fastqc_results/{sample}_R1_001_fastqc.html",
        "/scratch/eknodel/SCC_samples/cell_lines/raw_fastqc_results/{sample}_R2_001_fastqc.html"
    params:
        perl5lib = perl5lib_path
    shell:
        """
        PERL5LIB={params.perl5lib} fastqc -o /scratch/eknodel/SCC_samples/cell_lines/raw_fastqc_results {input.fq_1};
        PERL5LIB={params.perl5lib} fastqc -o /scratch/eknodel/SCC_samples/cell_lines/raw_fastqc_results {input.fq_2}
        """

rule multiqc_analysis:
    input:
        expand(
            "/scratch/eknodel/SCC_samples/cell_lines/raw_fastqc_results/{sample}_{read}_001_fastqc.html", sample=sample,
            read=["R1", "R2"])
    output:
        "/scratch/eknodel/SCC_samples/cell_lines/raw_multiqc_results/multiqc_report.html"
    shell:
        "export LC_ALL=en_US.UTF-8 && export LANG=en_US.UTF-8 && "
        "multiqc --interactive -f "
        "-o /scratch/eknodel/SCC_samples/cell_lines/raw_multiqc_results /scratch/eknodel/SCC_samples/cell_lines/raw_fastqc_results"

rule trim_adapters_paired_bbduk:
    input:
        fq_1 = "{sample}_R1_001.fastq.gz",
        fq_2 = "{sample}_R2_001.fastq.gz"
    output:
        out_fq_1 = "/scratch/eknodel/SCC_samples/cell_lines/trimmed_fastqs/{sample}_trimmed_read1.fastq.gz",
        out_fq_2 = "/scratch/eknodel/SCC_samples/cell_lines/trimmed_fastqs/{sample}_trimmed_read2.fastq.gz"
    params:
        adapter = adapter_path
    threads:
        2
    shell:
        "bbduk.sh -Xmx3g in1={input.fq_1} in2={input.fq_2} out1={output.out_fq_1} out2={output.out_fq_2} ref={params.adapter} qtrim=rl trimq=30 minlen=75 maq=20"

rule trimmed_fastqc_analysis:
    input:
        fq_1 = "/scratch/eknodel/SCC_samples/cell_lines/trimmed_fastqs/{sample}_trimmed_read1.fastq.gz",
        fq_2 = "/scratch/eknodel/SCC_samples/cell_lines/trimmed_fastqs/{sample}_trimmed_read2.fastq.gz"
    output:
        fq1_fastqc = "/scratch/eknodel/SCC_samples/cell_lines/trimmed_fastqc_results/{sample}_trimmed_read1_fastqc.html",
        fq2_fastqc = "/scratch/eknodel/SCC_samples/cell_lines/trimmed_fastqc_results/{sample}_trimmed_read2_fastqc.html"
    params: 
        perl5lib = perl5lib_path
    shell:
        """
        PERL5LIB={params.perl5lib} fastqc -o /scratch/eknodel/SCC_samples/cell_lines/trimmed_fastqc_results {input.fq_1};
        PERL5LIB={params.perl5lib} fastqc -o /scratch/eknodel/SCC_samples/cell_lines/trimmed_fastqc_results {input.fq_2}
        """

rule trimmed_multiqc_analysis:
    input:
        expand(
            "/scratch/eknodel/SCC_samples/cell_lines/trimmed_fastqc_results/{sample}_trimmed_{read}_fastqc.html",
            sample=sample,read=["read1", "read2"])
    output:
        "/scratch/eknodel/SCC_samples/cell_lines/trimmed_multiqc_results/multiqc_report.html"
    shell:
        "export LC_ALL=en_US.UTF-8 && export LANG=en_US.UTF-8 && "
        "multiqc --interactive -f "
        "-o /scratch/eknodel/SCC_samples/cell_lines/trimmed_multiqc_results /scratch/eknodel/SCC_samples/cell_lines/trimmed_fastqc_results"