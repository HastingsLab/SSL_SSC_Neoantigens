import os

#sample = ["185-1-5c-01-F11-6-26-21-1_216_361_S9_L003", "188-2-5c-05-F11-6-11-21_203_374_S18_L003", "244-1-chu-06-D12-6-22-21_213_364_S33_L003",
#"185-1-5c-01-F11-6-26-21-2_204_373_S10_L003", "188-2-5c-05-F11-6-15-21_286_291_S19_L003", "244-1-chu-06-D12-6-26-21_201_376_S34_L003",
#"185-1-5c-01-F11-6-26-21-3_287_290_S11_L003", "188-2-5c-05-F11-6-22-21_274_303_S20_L003", "244-1-chu-06-D12-7-12-21-1_260_317_S37_L003",
#"185-1-5c-01-F11-6-26-21-4_275_302_S12_L003", "188-2-5c-05-F11-6-3-21_239_338_S15_L003", "244-1-chu-06-D12-7-12-21-2_248_329_S38_L003",
#"185-1-5c-01-F11-6-26-21-5_263_314_S13_L003", "188-2-5c-05-F11-6-6-21_227_350_S16_L003", "244-1-chu-06-D12-7-9-21-1_284_293_S35_L003",
#"185-1-5c-01-F11-6-26-21-6_251_326_S14_L003", "188-2-5c-05-F11-6-9-21_215_362_S17_L003", "244-1-chu-06-D12-7-9-21-2_272_305_S36_L003",
#"185-15c-09-G9-6-11-21_252_325_S6_L003", "244-1-chu-02-B7-6-11-21_226_351_S24_L003", "244-chu-06-F5-6-26-21_285_292_S27_L003",
#"185-15c-09-G9-6-15-21_240_337_S7_L003", "244-1-chu-02-B7-6-15-21_214_363_S25_L003", "244-chu-06-F5-7-2-21-1_273_304_S28_L003",
#"185-15c-09-G9-6-22-21_228_349_S8_L003", "244-1-chu-02-B7-6-22-21_202_375_S26_L003", "244-chu-06-F5-7-2-21-2_261_316_S29_L003",
#"185-15c-09-G9-6-3-21_288_289_S3_L003", "244-1-chu-02-B7-6-3-21_262_315_S21_L003", "244-chu-06-F5-7-2-21-3_249_328_S30_L003",
#"185-15c-09-G9-6-6-21_276_301_S4_L003", "244-1-chu-02-B7-6-6-21_250_327_S22_L003", "244-chu-06-F5-7-9-21-1_237_340_S31_L003",
#"185-15c-09-G9-6-9-21_264_313_S5_L003", "244-1-chu-02-B7-6-9-21_238_339_S23_L003", "244-chu-06-F5-7-9-21-2_225_352_S32_L003"]

sample = ["483_sc_01_B6-1_366_211_S58_L003", "483_sc_01_B6-2_354_223_S59_L003"]

adapter_path = "/home/eknodel/Cancer_Genomics/00_misc/adapter_sequence.fa"
perl5lib_path = "/packages/6x/vcftools/0.1.12b/lib/per15/site_perl/"
fastqc = "/scratch/eknodel/SCC_samples/cell_lines/RNAseq/raw_fastqc_results/"
trimmed_fastqc = "/scratch/eknodel/SCC_samples/cell_lines/RNAseq/trimmed_fastqc_results/"

rule all:
    input:
        "/scratch/eknodel/SCC_samples/cell_lines/progeny/RNAseq/raw_multiqc_results/multiqc_report.html",
#        "/scratch/eknodel/SCC_samples/cell_lines/RNAseq/trimmed_multiqc_results/multiqc_report.html",


rule fastqc_analysis:
    input:
        fq_1 = "/data/CEM/shared/public_data/mouse_SCC_cell_lines/Progeny/RNAseq/{sample}_R1_001.fastq.gz",
        fq_2 = "/data/CEM/shared/public_data/mouse_SCC_cell_lines/Progeny/RNAseq/{sample}_R2_001.fastq.gz"
    output:
        "/scratch/eknodel/SCC_samples/cell_lines/progeny/RNAseq/raw_fastqc_results/{sample}_R1_001_fastqc.html",
        "/scratch/eknodel/SCC_samples/cell_lines/progeny/RNAseq/raw_fastqc_results/{sample}_R2_001_fastqc.html"
    params:
        perl5lib = perl5lib_path
    shell:
        """
        PERL5LIB={params.perl5lib} fastqc -o /scratch/eknodel/SCC_samples/cell_lines/progeny/RNAseq/raw_fastqc_results {input.fq_1};
        PERL5LIB={params.perl5lib} fastqc -o /scratch/eknodel/SCC_samples/cell_lines/progeny/RNAseq/raw_fastqc_results {input.fq_2}
        """

rule multiqc_analysis:
    input:
        expand(
            "/scratch/eknodel/SCC_samples/cell_lines/progeny/RNAseq/raw_fastqc_results/{sample}_{read}_001_fastqc.html", sample=sample,
            read=["R1", "R2"])
    output:
        "/scratch/eknodel/SCC_samples/cell_lines/progeny/RNAseq/raw_multiqc_results/multiqc_report.html"
    shell:
        "export LC_ALL=en_US.UTF-8 && export LANG=en_US.UTF-8 && "
        "multiqc --interactive -f "
        "-o /scratch/eknodel/SCC_samples/cell_lines/progeny/RNAseq/raw_multiqc_results /scratch/eknodel/SCC_samples/cell_lines/progeny/RNAseq/raw_fastqc_results"

#rule trim_adapters_paired_bbduk:
#    input:
#        fq_1 = "/scratch/eknodel/SCC_samples/cell_lines/RNAseq/{sample}_R1_001.fastq.gz",
#        fq_2 = "/scratch/eknodel/SCC_samples/cell_lines/RNAseq/{sample}_R2_001.fastq.gz"
#    output:
#        out_fq_1 = "/scratch/eknodel/SCC_samples/cell_lines/RNAseq/trimmed_fastqs/{sample}_trimmed_read1.fastq.gz",
#        out_fq_2 = "/scratch/eknodel/SCC_samples/cell_lines/RNAseq/trimmed_fastqs/{sample}_trimmed_read2.fastq.gz"
#    params:
#        adapter = adapter_path
#    threads:
#        2
#    shell:
#        "bbduk.sh -Xmx3g in1={input.fq_1} in2={input.fq_2} out1={output.out_fq_1} out2={output.out_fq_2} ref={params.adapter} qtrim=rl trimq=30 minlen=75 maq=20"

#rule trimmed_fastqc_analysis:
#    input:
#        fq_1 = "/scratch/eknodel/SCC_samples/cell_lines/RNAseq/trimmed_fastqs/{sample}_trimmed_read1.fastq.gz",
#        fq_2 = "/scratch/eknodel/SCC_samples/cell_lines/RNAseq/trimmed_fastqs/{sample}_trimmed_read2.fastq.gz"
#    output:
#        fq1_fastqc = "/scratch/eknodel/SCC_samples/cell_lines/RNAseq/trimmed_fastqc_results/{sample}_trimmed_read1_fastqc.html",
#        fq2_fastqc = "/scratch/eknodel/SCC_samples/cell_lines/RNAseq/trimmed_fastqc_results/{sample}_trimmed_read2_fastqc.html"
#    params: 
#        perl5lib = perl5lib_path
#    shell:
#        """
#        PERL5LIB={params.perl5lib} fastqc -o /scratch/eknodel/SCC_samples/cell_lines/RNAseq/trimmed_fastqc_results {input.fq_1};
#        PERL5LIB={params.perl5lib} fastqc -o /scratch/eknodel/SCC_samples/cell_lines/RNAseq/trimmed_fastqc_results {input.fq_2}
#        """

#rule trimmed_multiqc_analysis:
#    input:
#        expand(
#            "/scratch/eknodel/SCC_samples/cell_lines/RNAseq/trimmed_fastqc_results/{sample}_trimmed_{read}_fastqc.html",
#            sample=sample,read=["read1", "read2"])
#    output:
#        "/scratch/eknodel/SCC_samples/cell_lines/RNAseq/trimmed_multiqc_results/multiqc_report.html"
#    shell:
#        "export LC_ALL=en_US.UTF-8 && export LANG=en_US.UTF-8 && "
#        "multiqc --interactive -f "
#        "-o /scratch/eknodel/SCC_samples/cell_lines/RNAseq/trimmed_multiqc_results /scratch/eknodel/SCC_samples/cell_lines/RNAseq/trimmed_fastqc_results"
