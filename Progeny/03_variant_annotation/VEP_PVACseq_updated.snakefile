# Setting up filesnames here:
from os.path import join
import os

sample = ["DNA_483-SC-01-B6_9-3-21_133_060_S138_L002"]

# Directory Pathways
gatk_path = "/scratch/eknodel/SCC_samples/Progeny/gatk_mutect2/"
peptide_path = "/scratch/eknodel/SCC_samples/Progeny/peptides/"
strelka_dir = "/scratch/eknodel/SCC_samples/Progeny/strelka/"
vep_path = "/scratch/eknodel/SCC_samples/Progeny/VEP/"


rule all:
    input:
        expand(vep_path + "{sample}_gatk_vep_filtered.vcf", sample=sample, vep_path=vep_path),
        expand(peptide_path + "{sample}_gatk_vep_filtered.vcf", sample=sample, peptide_path=peptide_path),
        expand(peptide_path + "{sample}_strelka_vep_filtered.vcf", sample=sample, peptide_path=peptide_path),
        expand(peptide_path + "{sample}_gatk_vep_filtered.peptides", sample=sample, peptide_path=peptide_path),
        expand(peptide_path + "{sample}_gatk_vep_filtered_21.peptides", sample=sample, peptide_path=peptide_path)

rule combine_strelka_vcfs:
    input: 
        strelka_snvs_filtered = os.path.join(strelka_dir, "{sample}/results/variants/somatic.snvs.pass.vcf.gz"),
        strelka_indels_filtered = os.path.join(strelka_dir, "{sample}/results/variants/somatic.indels.pass.vcf.gz"),
        strelka_snvs_unfiltered = os.path.join(strelka_dir, "{sample}/results/variants/somatic.snvs.vcf.gz"),
        strelka_indels_unfiltered = os.path.join(strelka_dir, "{sample}/results/variants/somatic.indels.vcf.gz")
    output:
        strelka_filtered = os.path.join(strelka_dir, "{sample}/results/variants/somatic.pass.vcf"),
        strelka_unfiltered = os.path.join(strelka_dir, "{sample}/results/variants/somatic.vcf")
    shell: 
        """
        bcftools concat -a {input.strelka_indels_filtered} {input.strelka_snvs_filtered} -o {output.strelka_filtered};
        bcftools concat -a {input.strelka_indels_unfiltered} {input.strelka_snvs_unfiltered} -o {output.strelka_unfiltered}
        """

#rule gunzip:
#    input:
#        gatk_filtered = os.path.join(gatk_path, "{sample}.somatic.filtered.pass.vcf.gz"),
#        gatk_unfiltered = os.path.join(gatk_path, "{sample}.somatic.vcf.gz")
#    output:
#        gatk_filtered = os.path.join(gatk_path, "{sample}.somatic.filtered.pass.vcf"),
#        gatk_unfiltered = os.path.join(gatk_path, "{sample}.somatic.vcf")
#    shell:
#        """
#        gunzip {input.gatk_filtered};
#        gunzip {input.gatk_unfiltered};
#        """

#rule gunzip_bgzip:
#    iput:
#        strelka_filtered = os.path.join(strelka_dir, "{sample}/results/variants/somatic.pass.vcf.gz"),
#        strelka_unfiltered = os.path.join(strelka_dir, "{sample}/results/variants/somatic.vcf.gz")
#    output:
#        strelka_filtered = os.path.join(strelka_dir, "{sample}/results/variants/somatic.pass.vcf"),
#        strelka_unfiltered = os.path.join(strelka_dir, "{sample}/results/variants/somatic.vcf")
#    shell:
#        """
#        bgzip -d {input.strelka_filtered};
#        bgzip -d {input.strelka_unfiltered};
#        """

rule isort_input: 
    input: 
        gatk_filtered = os.path.join(gatk_path, "{sample}.somatic.filtered.pass.vcf"),
        gatk_unfiltered = os.path.join(gatk_path, "{sample}.somatic.vcf"),
        strelka_filtered = os.path.join(strelka_dir, "{sample}/results/variants/somatic.pass.vcf"),
        strelka_unfiltered = os.path.join(strelka_dir, "{sample}/results/variants/somatic.vcf")
    output: 
        gatk_filtered = os.path.join(gatk_path, "{sample}.somatic_sorted.filtered.pass.vcf"),
        gatk_unfiltered = os.path.join(gatk_path, "{sample}.somatic_sorted.vcf"),
        strelka_filtered = os.path.join(strelka_dir, "{sample}/results/variants/somatic_sorted.pass.vcf"),
        strelka_unfiltered = os.path.join(strelka_dir, "{sample}/results/variants/somatic_sorted.vcf")
    shell:
        """
        bcftools sort {input.gatk_filtered} -o {output.gatk_filtered};
        bcftools sort {input.gatk_unfiltered} -o {output.gatk_unfiltered};
        bcftools sort {input.strelka_filtered} -o {output.strelka_filtered};
        bcftools sort {input.strelka_unfiltered} -o {output.strelka_unfiltered};
        """

rule run_vep:
    input:
        gatk_filtered = os.path.join(gatk_path, "{sample}.somatic_sorted.filtered.pass.vcf"),
        gatk_unfiltered = os.path.join(gatk_path, "{sample}.somatic_sorted.vcf"),
        strelka_filtered = os.path.join(strelka_dir, "{sample}/results/variants/somatic_sorted.pass.vcf"),
        strelka_unfiltered = os.path.join(strelka_dir, "{sample}/results/variants/somatic_sorted.vcf")
    output:
        gatk_filtered = os.path.join(vep_path, "{sample}_gatk_vep_filtered.vcf"),
        gatk_unfiltered = os.path.join(vep_path, "{sample}_gatk_vep_unfiltered.vcf"),
        strelka_filtered = os.path.join(vep_path, "{sample}_strelka_vep_filtered.vcf"),
        strelka_unfiltered = os.path.join(vep_path, "{sample}_strelka_vep_unfiltered.vcf")
    shell:
        """
        vep -i {input.gatk_filtered} --format vcf --species mus_musculus --cache --cache_version 100 --offline --vcf -o {output.gatk_filtered} --force_overwrite  --symbol --plugin Wildtype --plugin Frameshift --terms SO --plugin Downstream;
        vep -i {input.gatk_unfiltered} --format vcf --species mus_musculus --cache --cache_version 100 --offline --vcf -o {output.gatk_unfiltered} --force_overwrite  --symbol --plugin Wildtype --plugin Frameshift --terms SO --plugin Downstream;
        vep -i {input.strelka_filtered} --format vcf --species mus_musculus --cache --cache_version 100 --offline --vcf -o {output.strelka_filtered} --force_overwrite  --symbol --plugin Wildtype --plugin Frameshift --terms SO --plugin Downstream;
        vep -i {input.strelka_unfiltered} --format vcf --species mus_musculus --cache --cache_version 100 --offline --vcf -o {output.strelka_unfiltered} --force_overwrite  --symbol --plugin Wildtype --plugin Frameshift --terms SO --plugin Downstream;
        """ 

#rule add_sample_name: 
#    input: 
#        gatk_filtered = os.path.join(vep_path, "{sample}_gatk_vep_filtered.vcf"),
#        gatk_unfiltered = os.path.join(vep_path, "{sample}_gatk_vep_unfiltered.vcf"),
#        strelka_filtered = os.path.join(vep_path, "{sample}_strelka_vep_filtered.vcf"),
#        strelka_unfiltered = os.path.join(vep_path, "{sample}_strelka_vep_unfiltered.vcf")
#    output:
#        gatk_filtered = os.path.join(vep_path, "{sample}_gatk_vep_filtered_sn.vcf"),
#        gatk_unfiltered = os.path.join(vep_path, "{sample}_gatk_vep_unfiltered_sn.vcf"),
#        strelka_filtered = os.path.join(vep_path, "{sample}_strelka_vep_filtered_sn.vcf"),
#        strelka_unfiltered = os.path.join(vep_path, "{sample}_strelka_vep_unfiltered_sn.vcf")
#    params:
#        sample = "{sample}"
#    shell:
#        """
#        vcf-genotype-annotator {input.gatk_filtered} {params.sample} 0/1 -o {output.gatk_filtered}
#        vcf-genotype-annotator {input.gatk_unfiltered} {params.sample} 0/1 -o {output.gatk_unfiltered}
#        vcf-genotype-annotator {input.strelka_filtered} {params.sample} 0/1 -o {output.strelka_filtered}
#        vcf-genotype-annotator {input.strelka_unfiltered} {params.sample} 0/1 -o {output.strelka_unfiltered}
#        """

rule generate_fasta_gatk:
    input:
        gatk_filtered = os.path.join(vep_path, "{sample}_gatk_vep_filtered.vcf"),
        gatk_unfiltered = os.path.join(vep_path, "{sample}_gatk_vep_unfiltered.vcf")
    output:
        gatk_filtered = os.path.join(peptide_path, "{sample}_gatk_vep_filtered.vcf"),
        gatk_unfiltered = os.path.join(peptide_path, "{sample}_gatk_vep_unfiltered.vcf")
    params: 
        sample = "{sample}"
    shell:
        """
        python /home/eknodel/bin/pVACtools/pvactools/tools/pvacseq/generate_protein_fasta.py {input.gatk_filtered} 8 {output.gatk_filtered} -s {params.sample};
        python /home/eknodel/bin/pVACtools/pvactools/tools/pvacseq/generate_protein_fasta.py {input.gatk_unfiltered} 8 {output.gatk_unfiltered} -s {params.sample};
        """

rule generate_fasta_21_gatk:
    input:
        gatk_filtered = os.path.join(vep_path, "{sample}_gatk_vep_filtered.vcf")
    output:
        gatk_filtered = os.path.join(peptide_path, "{sample}_gatk_vep_filtered_21.peptides")
    params:
        sample = "{sample}"
    shell:
        """
        python /home/eknodel/bin/pVACtools/pvactools/tools/pvacseq/generate_protein_fasta.py {input.gatk_filtered} 10 {output.gatk_filtered} -s {params.sample};
        """

rule va_annotation:
    input:
        strelka_filtered = os.path.join(vep_path, "{sample}_strelka_vep_filtered.vcf"),
        strelka_unfiltered = os.path.join(vep_path, "{sample}_strelka_vep_unfiltered.vcf")
    output:
        strelka_filtered = os.path.join(vep_path, "{sample}_strelka_vep_filtered_gt.vcf"),
        strelka_unfiltered = os.path.join(vep_path, "{sample}_strelka_vep_unfiltered_gt.vcf")
    params:
        sample = "TUMOR"
    shell:
        """
        vcf-genotype-annotator -o {output.strelka_filtered} {input.strelka_filtered} {params.sample} 0/1;
        vcf-genotype-annotator -o {output.strelka_unfiltered} {input.strelka_unfiltered} {params.sample} 0/1;
        """

rule generate_fasta_strelka:
    input:
        strelka_filtered = os.path.join(vep_path, "{sample}_strelka_vep_filtered_gt.vcf"),
        strelka_unfiltered = os.path.join(vep_path, "{sample}_strelka_vep_unfiltered_gt.vcf")
    output:
        strelka_filtered = os.path.join(peptide_path, "{sample}_strelka_vep_filtered.vcf"),
        strelka_unfiltered = os.path.join(peptide_path, "{sample}_strelka_vep_ubfiltered.vcf")
    params:
        sample = "TUMOR"
    shell:
        """
        python /home/eknodel/bin/pVACtools/pvactools/tools/pvacseq/generate_protein_fasta.py {input.strelka_filtered} 8 {output.strelka_filtered} -s {params.sample};
        python /home/eknodel/bin/pVACtools/pvactools/tools/pvacseq/generate_protein_fasta.py {input.strelka_unfiltered} 8 {output.strelka_unfiltered} -s {params.sample};
        """

rule format_peptides:
    input:
        gatk_filtered = os.path.join(peptide_path, "{sample}_gatk_vep_filtered.vcf"),
        gatk_unfiltered = os.path.join(peptide_path, "{sample}_gatk_vep_unfiltered.vcf"),
        strelka_filtered = os.path.join(peptide_path, "{sample}_strelka_vep_filtered.vcf"),
        strelka_unfiltered = os.path.join(peptide_path, "{sample}_strelka_vep_ubfiltered.vcf")
    output:
        gatk_filtered = os.path.join(peptide_path, "{sample}_gatk_vep_filtered.peptides"),
        gatk_unfiltered = os.path.join(peptide_path, "{sample}_gatk_vep_unfiltered.peptides"),
        strelka_filtered = os.path.join(peptide_path, "{sample}_strelka_vep_filtered.peptides"),
        strelka_unfiltered = os.path.join(peptide_path, "{sample}_strelka_vep_unfiltered.peptides")
    shell:
        """
        cat {input.gatk_filtered} | sed ':a;N;$!ba;s/\\n/ /g' | sed 's/>/\\n>/g' | sed 's/ //2' | sed 's/ //2' | sed 's/ //2' | sed 's/ //2' | sed 's/ //2' | sed 's/ //2' | sed '/>WT/d' | sed 's/\./ /g' > {output.gatk_filtered};
        cat {input.gatk_unfiltered} | sed ':a;N;$!ba;s/\\n/ /g' | sed 's/>/\\n>/g' | sed 's/ //2' | sed 's/ //2' | sed 's/ //2' | sed 's/ //2' | sed 's/ //2' | sed 's/ //2' | sed '/>WT/d' | sed 's/\./ /g' > {output.gatk_unfiltered};
        cat {input.strelka_filtered} | sed ':a;N;$!ba;s/\\n/ /g' | sed 's/>/\\n>/g' | sed 's/ //2' | sed 's/ //2' | sed 's/ //2' | sed 's/ //2' | sed 's/ //2' | sed 's/ //2' | sed '/>WT/d' | sed 's/\./ /g' > {output.strelka_filtered};
        cat {input.strelka_unfiltered} | sed ':a;N;$!ba;s/\\n/ /g' | sed 's/>/\\n>/g' | sed 's/ //2' | sed 's/ //2' | sed 's/ //2' | sed 's/ //2' | sed 's/ //2' | sed 's/ //2' | sed '/>WT/d' | sed 's/\./ /g' > {output.strelka_unfiltered};
        """
