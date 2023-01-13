# Setting up filesnames here:
from os.path import join

# Files
#sample = ["185_1_SC_09_G9_304_273_S6_L003"]
sample = ["185_1_SC_01_F11_364_213_S1_L003", "185_1_SC_09_G9_304_273_S6_L003", "188_2_SC_05_F11_340_237_S3_L003", "244_1_Chu_02_B7_352_225_S2_L003", "244_1_Chu_06_D12_316_261_S5_L003", "244_1_Chu_06_F5_328_249_S4_L003"]

# Path to files
bam_path = "/beegfs/eknodel/SCC_samples/cell_lines/processed_bams/"
manta_path = "/beegfs/eknodel/SCC_samples/cell_lines/manta/"
ref_dir = "/beegfs/eknodel/SCC_samples/reference/"

rule all:
    input:
        expand(manta_path + "{sample}/runWorkflow.py", sample=sample),
        expand(manta_path + "{sample}/results/variants/candidateSmallIndels.vcf.gz", sample=sample)

rule config:
    input: 
        tumor = os.path.join(bam_path, "{sample}.GRCm38_68.sorted.bam"),
        normal = os.path.join(bam_path, "gDNA_normal_tissue_377_200_S55_L004.GRCm38_68.sorted.bam")
    output:
        os.path.join(manta_path,"{sample}/runWorkflow.py")
    params:
        ref = os.path.join(ref_dir, "GRCm38_68.fa"),
        manta = "~/bin/manta-1.6.0.centos6_x86_64/bin/configManta.py",
        run_dir = os.path.join(manta_path, "{sample}"),
    shell:
        """
        {params.manta} \
        --tumorBam {input.tumor} \
        --normalBam {input.normal} \
        --referenceFasta {params.ref} \
        --runDir {params.run_dir}
        """

rule run: 
    input: 
        os.path.join(manta_path, "{sample}/runWorkflow.py")
    output:
        os.path.join(manta_path, "{sample}/results/variants/candidateSmallIndels.vcf.gz")
    shell:
        """
        {input} -j 8
        """


