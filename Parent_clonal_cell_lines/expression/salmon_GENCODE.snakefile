#! importing join
from os.path import join

# Workflow for quasi-quantification of RNAseq read counts with Salmon in non-alignment-based mode.
# Samples
sample = ["185-1-5c-01-F11-6-26-21-1_216_361_S9_L003", "188-2-5c-05-F11-6-11-21_203_374_S18_L003", "244-1-chu-06-D12-6-22-21_213_364_S33_L003",
"185-1-5c-01-F11-6-26-21-2_204_373_S10_L003", "188-2-5c-05-F11-6-15-21_286_291_S19_L003", "244-1-chu-06-D12-6-26-21_201_376_S34_L003",
"185-1-5c-01-F11-6-26-21-3_287_290_S11_L003", "188-2-5c-05-F11-6-22-21_274_303_S20_L003", "244-1-chu-06-D12-7-12-21-1_260_317_S37_L003",
"185-1-5c-01-F11-6-26-21-4_275_302_S12_L003", "188-2-5c-05-F11-6-3-21_239_338_S15_L003", "244-1-chu-06-D12-7-12-21-2_248_329_S38_L003",
"185-1-5c-01-F11-6-26-21-5_263_314_S13_L003", "188-2-5c-05-F11-6-6-21_227_350_S16_L003", "244-1-chu-06-D12-7-9-21-1_284_293_S35_L003",
"185-1-5c-01-F11-6-26-21-6_251_326_S14_L003", "188-2-5c-05-F11-6-9-21_215_362_S17_L003", "244-1-chu-06-D12-7-9-21-2_272_305_S36_L003",
"185-15c-09-G9-6-11-21_252_325_S6_L003", "244-1-chu-02-B7-6-11-21_226_351_S24_L003", "244-chu-06-F5-6-26-21_285_292_S27_L003",
"185-15c-09-G9-6-15-21_240_337_S7_L003", "244-1-chu-02-B7-6-15-21_214_363_S25_L003", "244-chu-06-F5-7-2-21-1_273_304_S28_L003",
"185-15c-09-G9-6-22-21_228_349_S8_L003", "244-1-chu-02-B7-6-22-21_202_375_S26_L003", "244-chu-06-F5-7-2-21-2_261_316_S29_L003",
"185-15c-09-G9-6-3-21_288_289_S3_L003", "244-1-chu-02-B7-6-3-21_262_315_S21_L003", "244-chu-06-F5-7-2-21-3_249_328_S30_L003",
"185-15c-09-G9-6-6-21_276_301_S4_L003", "244-1-chu-02-B7-6-6-21_250_327_S22_L003", "244-chu-06-F5-7-9-21-1_237_340_S31_L003",
"185-15c-09-G9-6-9-21_264_313_S5_L003", "244-1-chu-02-B7-6-9-21_238_339_S23_L003", "244-chu-06-F5-7-9-21-2_225_352_S32_L003",
"483_sc_01_B6-1_366_211_S58_L003", "483_sc_01_B6-2_354_223_S59_L003"]

# Tools
SALMON = "salmon"

SALMON_INDEX = "/data/CEM/shared/public_data/references/GENCODE_Mus_musculus/gencode_transcript_index/"

# Directories
FQ_DIR = "/scratch/eknodel/SCC_samples/cell_lines/RNAseq/" # path to directory with trimmed FASTQ files
SALMON_DIR = "/scratch/eknodel/SCC_samples/cell_lines/RNAseq/salmon/" # path to directory for Salmon output files

rule all:
    input:
        expand(SALMON_DIR + "{sample}_salmon_quant/", SALMON_DIR=SALMON_DIR, sample=sample),

rule salmon_quant_paired:
    input:
        R1 = os.path.join(FQ_DIR, "{sample}_R1_001.fastq.gz"),
        R2 = os.path.join(FQ_DIR, "{sample}_R2_001.fastq.gz")
    output:
        OUTPUT = directory(os.path.join(SALMON_DIR, "{sample}_salmon_quant/"))
    params:
        SALMON = SALMON,
        SALMON_INDEX = SALMON_INDEX,
        LIBTYPE = "A", # LIBTYPE A for automatic detection of library type
        threads = 8
    message: "Quantifying {wildcards.sample} transcripts with Salmon."
    run:
        shell("{params.SALMON} quant -i {params.SALMON_INDEX} -l {params.LIBTYPE} -1 {input.R1} -2 {input.R2} --validateMappings -o {output.OUTPUT}")

