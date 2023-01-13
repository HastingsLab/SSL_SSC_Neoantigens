import os

sample = ["DNA_483-SC-01-B6_9-3-21_133_060_S138_L002"]
normal = ["gDNA_normal_tissue_377_200_S55_L004"]

## Directory Paths ##
bam_dir = "/scratch/eknodel/SCC_samples/Progeny/processed_bams/"
strelka_dir = "/scratch/eknodel/SCC_samples/Progeny/strelka/"
ref_basename = "GRCm38_68"
ref_dir = "/data/CEM/shared/public_data/references/ensemble_GRCm38.68/"

rule all:
    input:
        expand(os.path.join(strelka_dir, "{subject}/runWorkflow.py"), subject=sample),
        expand(os.path.join(strelka_dir, "{subject}/results/variants/somatic.snvs.vcf.gz"), subject=sample),
        expand(os.path.join(strelka_dir, "{subject}/results/variants/somatic.indels.vcf.gz"), subject=sample),
        expand(os.path.join(strelka_dir, "{subject}/results/variants/somatic.snvs.pass.vcf.gz"), subject=sample),
        expand(os.path.join(strelka_dir, "{subject}/results/variants/somatic.indels.pass.vcf.gz"), subject=sample),

rule config:
    input:
        normal_bam = os.path.join(bam_dir, "gDNA_normal_tissue_377_200_S55_L004." + ref_basename + ".sorted.bam"),
        tumor_bam = os.path.join(bam_dir, "{subject}." + ref_basename + ".sorted.bam"),
        ref = os.path.join(ref_dir, ref_basename + ".fa")
    output:
        "/scratch/eknodel/SCC_samples/Progeny/strelka/{subject}/runWorkflow.py"
    params:
        strelka = "/home/eknodel/strelka-2.9.2.centos6_x86_64/bin/configureStrelkaSomaticWorkflow.py",
        run_dir = "/scratch/eknodel/SCC_samples/Progeny/strelka/{subject}"
    shell:
        """
        {params.strelka} --normalBam {input.normal_bam} --tumorBam {input.tumor_bam} --referenceFasta {input.ref} --runDir {params.run_dir}
        """

rule run:
    input:
        normal_bam = os.path.join(bam_dir, "gDNA_normal_tissue_377_200_S55_L004." + ref_basename + ".sorted.bam"),
        tumor_bam = os.path.join(bam_dir, "{subject}." + ref_basename + ".sorted.bam"),
        ref = os.path.join(ref_dir, ref_basename + ".fa")
    output:
        snvs = os.path.join(strelka_dir, "{subject}/results/variants/somatic.snvs.vcf.gz"),
        indels = os.path.join(strelka_dir, "{subject}/results/variants/somatic.indels.vcf.gz")
    params:
        run = os.path.join(strelka_dir, "{subject}/runWorkflow.py")
    shell:
        """
        {params.run} -m local -j 20
        """

rule select_pass_variants:
    input:
        ref = os.path.join(ref_dir, ref_basename + ".fa"),
        snvs = os.path.join(strelka_dir, "{subject}/results/variants/somatic.snvs.vcf.gz"),
        indels = os.path.join(strelka_dir, "{subject}/results/variants/somatic.indels.vcf.gz")
    output:
        snvs = os.path.join(strelka_dir, "{subject}/results/variants/somatic.snvs.pass.vcf.gz"),
        indels = os.path.join(strelka_dir, "{subject}/results/variants/somatic.indels.pass.vcf.gz")
    params:
        gatk = "/home/eknodel/gatk-4.1.7.0/gatk"
    shell:
        """
        {params.gatk} SelectVariants -R {input.ref} -V {input.snvs} --exclude-filtered -O {output.snvs};
        {params.gatk} SelectVariants -R {input.ref} -V {input.indels} --exclude-filtered -O {output.indels}
        """

rule gunzip:
    input:
        snvs = os.path.join(strelka_dir, "{subject}/results/variants/somatic.snvs.pass.vcf.gz"),
        indels = os.path.join(strelka_dir, "{subject}/results/variants/somatic.indels.pass.vcf.gz")
    output:
        snvs = os.path.join(strelka_dir, "{subject}/results/variants/somatic.snvs.pass.vcf"),
        indels = os.path.join(strelka_dir, "{subject}/results/variants/somatic.indels.pass.vcf")
    shell:
        """
        gunzip -c {input.snvs} > {output.snvs};
        gunzip -c {input.indels} > {output.indels}
        """

