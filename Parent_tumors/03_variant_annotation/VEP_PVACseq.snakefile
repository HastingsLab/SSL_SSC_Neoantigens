# Setting up filesnames here:
from os.path import join
import os

samples = ["gDNA_185_25_2E1_5C_365_212_S56_L004", "gDNA_188_25_2E2_5C_157_036_S57_L004", "gDNA_244_25_2E1_chu_329_248_S59_L004"]

rule all:
    input:
        expand("/scratch/eknodel/SCC_samples/Parent_tumors/variants/{subject}_merged.vcf", subject=samples), # combine all mutations
        expand("/scratch/eknodel/SCC_samples/Parent_tumors/variants/{subject}_merged_vep.vcf", subject=samples), # run VEP
        expand("/scratch/eknodel/SCC_samples/Parent_tumors/peptides/{subject}_vep.17.peptides", subject=samples)

rule combine_strelka:
    input: 
        strelka = os.path.join("/scratch/eknodel/SCC_samples/Parent_tumors/strelka/{subject}/results/variants/somatic.snvs.pass.vcf.gz"),      
        strelka_indels = os.path.join("/scratch/eknodel/SCC_samples/Parent_tumors/strelka/{subject}/results/variants/somatic.indels.pass.vcf.gz")              
    output:
        strelka = os.path.join("/scratch/eknodel/SCC_samples/Parent_tumors/strelka/{subject}/results/variants/somatic.pass.vcf")
    shell:
        """
        bcftools concat -a {input.strelka_indels} {input.strelka} -o {output.strelka}
        """

rule gunzip:
    input:
        gatk = os.path.join("/scratch/eknodel/SCC_samples/Parent_tumors/gatk_mutect2/{subject}.somatic.filtered.pass.vcf.gz")
    output:
        gatk = os.path.join("/scratch/eknodel/SCC_samples/Parent_tumors/gatk_mutect2/{subject}.somatic.filtered.pass.vcf")
    shell: 
        """
        gunzip {input.gatk}
        """

rule generate_input:
    input:
        gatk = os.path.join("/scratch/eknodel/SCC_samples/Parent_tumors/gatk_mutect2/{subject}.somatic.filtered.pass.vcf"),
        strelka = os.path.join("/scratch/eknodel/SCC_samples/Parent_tumors/strelka/{subject}/results/variants/somatic.pass.vcf"),
    output:
        vep = os.path.join("/scratch/eknodel/SCC_samples/Parent_tumors/variants/{subject}_merged.vcf")
    shell: 
        """
        python merge_Mutect2_Strelka2_variants.py \
        --gatk_file {input.gatk} \
        --strelka_file {input.strelka} \
        --vep_format_fn {output.vep}
        """

rule sort:
    input:
        vcf = os.path.join("/scratch/eknodel/SCC_samples/Parent_tumors/variants/{subject}_merged.vcf")
    output:
        vcf = os.path.join("/scratch/eknodel/SCC_samples/Parent_tumors/variants/{subject}_merged_sorted.vcf")
    shell:
        """
        sort -V {input.vcf} > {output.vcf}
        """

rule run_vep:
    input:
        os.path.join("/scratch/eknodel/SCC_samples/Parent_tumors/variants/{subject}_merged_sorted.vcf")
    output:
        os.path.join("/scratch/eknodel/SCC_samples/Parent_tumors/variants/{subject}_merged_vep.vcf")
    shell:
        """
        vep -i {input} --format vcf --species mus_musculus --cache --cache_version 100 --offline --vcf -o {output} --force_overwrite  --symbol --plugin Wildtype --plugin Frameshift --terms SO --plugin Downstream;
        """ 

rule va_annotation:
    input:
        os.path.join("/scratch/eknodel/SCC_samples/Parent_tumors/variants/{subject}_merged_vep.vcf")
    output:
        os.path.join("/scratch/eknodel/SCC_samples/Parent_tumors/variants/{subject}_merged_vep_gt.vcf")
    params:
        sample = "{subject}"
    shell:
        """
        vcf-genotype-annotator -o {output} {input} {params.sample} 0/1;
        """

rule generate_fasta_ns:
    input:
        os.path.join("/scratch/eknodel/SCC_samples/Parent_tumors/variants/{subject}_merged_vep_gt.vcf")
    output:
        len_17 = os.path.join("/scratch/eknodel/SCC_samples/Parent_tumors/peptides/{subject}_vep.17.vcf"),
    params:
        sample = "{subject}"
    shell:
        """
        python /home/eknodel/bin/pVACtools/pvactools/tools/pvacseq/generate_protein_fasta.py {input} 8 {output.len_17} -s {params.sample};
        """

rule format_peptides:
    input:
        os.path.join("/scratch/eknodel/SCC_samples/Parent_tumors/peptides/{subject}_vep.17.vcf")
    output:
        os.path.join("/scratch/eknodel/SCC_samples/Parent_tumors/peptides/{subject}_vep.17.peptides")
    shell:
        """
        cat {input} | sed ':a;N;$!ba;s/\\n/ /g' | sed 's/>/\\n>/g' | sed 's/ //2' | sed 's/ //2' | sed 's/ //2' | sed 's/ //2' | sed 's/ //2' | sed 's/ //2' | sed '/>WT/d' | sed 's/\./\t/g' > {output};
        """
