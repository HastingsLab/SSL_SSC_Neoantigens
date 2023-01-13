#!/bin/bash
#SBATCH --job-name=Gatk  # Job name
#SBATCH --mail-type=ALL           # notifications for job done & fail
#SBATCH --mail-user=eknodel@asu.edu # send-to address
#SBATCH -n 1
#SBATCH -N 1
#SBATCH -c 1
#SBATCH -t 168:00:00
#SBATCH --mem=40000
#SBATCH -p wildfire
#SBATCH -q wildfire

newgrp combinedlab

# 185 F11

python overlap_RNA_GATK_Strelka.py \
 --vcf_filenames /scratch/eknodel/SCC_samples/cell_lines/gatk_mutect2/185_1_SC_01_F11_364_213_S1_L003.somatic.filtered.pass.vcf,/scratch/eknodel/SCC_samples/cell_lines/strelka/185_1_SC_01_F11_364_213_S1_L003/results/variants/somatic.indels.pass.vcf,/scratch/eknodel/SCC_samples/cell_lines/strelka/185_1_SC_01_F11_364_213_S1_L003/results/variants/somatic.snvs.pass.vcf \
 --rna_vcf_filenames /scratch/eknodel/SCC_samples/cell_lines/RNAseq/gatk_mutect2/185-1-5c-01-F11-6-26-21-1_216_361_S9_L003.somatic.filtered.pass.vcf,/scratch/eknodel/SCC_samples/cell_lines/RNAseq/gatk_mutect2/185-1-5c-01-F11-6-26-21-2_204_373_S10_L003.somatic.filtered.pass.vcf,/scratch/eknodel/SCC_samples/cell_lines/RNAseq/gatk_mutect2/185-1-5c-01-F11-6-26-21-3_287_290_S11_L003.somatic.filtered.pass.vcf,/scratch/eknodel/SCC_samples/cell_lines/RNAseq/gatk_mutect2/185-1-5c-01-F11-6-26-21-4_275_302_S12_L003.somatic.filtered.pass.vcf,/scratch/eknodel/SCC_samples/cell_lines/RNAseq/gatk_mutect2/185-1-5c-01-F11-6-26-21-5_263_314_S13_L003.somatic.filtered.pass.vcf,/scratch/eknodel/SCC_samples/cell_lines/RNAseq/gatk_mutect2/185-1-5c-01-F11-6-26-21-6_251_326_S14_L003.somatic.filtered.pass.vcf \
 --vep_format_fn /scratch/eknodel/SCC_samples/cell_lines/RNA_overlap_mutations/185_F11_RNA_filtered_overlap.vcf \
 --number_of_variants 185_F11_numbers_RNA_filtered.out \
 --variant_ids 185_F11_variant_ids_RNA_filtered.out

# 185 G9

python overlap_RNA_GATK_Strelka.py \
 --vcf_filenames /scratch/eknodel/SCC_samples/cell_lines/gatk_mutect2/185_1_SC_09_G9_304_273_S6_L003.somatic.filtered.pass.vcf,/scratch/eknodel/SCC_samples/cell_lines/strelka/185_1_SC_09_G9_304_273_S6_L003/results/variants/somatic.indels.pass.vcf,/scratch/eknodel/SCC_samples/cell_lines/strelka/185_1_SC_09_G9_304_273_S6_L003/results/variants/somatic.snvs.pass.vcf \
 --rna_vcf_filenames /scratch/eknodel/SCC_samples/cell_lines/RNAseq/gatk_mutect2/185-15c-09-G9-6-11-21_252_325_S6_L003.somatic.filtered.pass.vcf,/scratch/eknodel/SCC_samples/cell_lines/RNAseq/gatk_mutect2/185-15c-09-G9-6-15-21_240_337_S7_L003.somatic.filtered.pass.vcf,/scratch/eknodel/SCC_samples/cell_lines/RNAseq/gatk_mutect2/185-15c-09-G9-6-22-21_228_349_S8_L003.somatic.filtered.pass.vcf,/scratch/eknodel/SCC_samples/cell_lines/RNAseq/gatk_mutect2/185-15c-09-G9-6-3-21_288_289_S3_L003.somatic.filtered.pass.vcf,/scratch/eknodel/SCC_samples/cell_lines/RNAseq/gatk_mutect2/185-15c-09-G9-6-6-21_276_301_S4_L003.somatic.filtered.pass.vcf,/scratch/eknodel/SCC_samples/cell_lines/RNAseq/gatk_mutect2/185-15c-09-G9-6-9-21_264_313_S5_L003.somatic.filtered.pass.vcf \
 --vep_format_fn /scratch/eknodel/SCC_samples/cell_lines/RNA_overlap_mutations/185_G9_RNA_filtered_overlap.vcf \
 --number_of_variants 185_G9_numbers_RNA_filtered.out \
 --variant_ids 185_G9_variant_ids_RNA_filtered.out


# 188

python overlap_RNA_GATK_Strelka.py \
 --vcf_filenames /scratch/eknodel/SCC_samples/cell_lines/gatk_mutect2/188_2_SC_05_F11_340_237_S3_L003.somatic.filtered.pass.vcf,/scratch/eknodel/SCC_samples/cell_lines/strelka/188_2_SC_05_F11_340_237_S3_L003/results/variants/somatic.indels.pass.vcf,/scratch/eknodel/SCC_samples/cell_lines/strelka/188_2_SC_05_F11_340_237_S3_L003/results/variants/somatic.snvs.pass.vcf \
 --rna_vcf_filenames /scratch/eknodel/SCC_samples/cell_lines/RNAseq/gatk_mutect2/188-2-5c-05-F11-6-11-21_203_374_S18_L003.somatic.filtered.pass.vcf,/scratch/eknodel/SCC_samples/cell_lines/RNAseq/gatk_mutect2/188-2-5c-05-F11-6-15-21_286_291_S19_L003.somatic.filtered.pass.vcf,/scratch/eknodel/SCC_samples/cell_lines/RNAseq/gatk_mutect2/188-2-5c-05-F11-6-22-21_274_303_S20_L003.somatic.filtered.pass.vcf,/scratch/eknodel/SCC_samples/cell_lines/RNAseq/gatk_mutect2/188-2-5c-05-F11-6-3-21_239_338_S15_L003.somatic.filtered.pass.vcf,/scratch/eknodel/SCC_samples/cell_lines/RNAseq/gatk_mutect2/188-2-5c-05-F11-6-6-21_227_350_S16_L003.somatic.filtered.pass.vcf,/scratch/eknodel/SCC_samples/cell_lines/RNAseq/gatk_mutect2/188-2-5c-05-F11-6-9-21_215_362_S17_L003.somatic.filtered.pass.vcf \
 --vep_format_fn /scratch/eknodel/SCC_samples/cell_lines/RNA_overlap_mutations/188_RNA_filtered_overlap.vcf \
 --number_of_variants 188_numbers_RNA_filtered.out \
 --variant_ids 188_variant_ids_RNA_filtered.out


# 244 B7

python overlap_RNA_GATK_Strelka.py \
 --vcf_filenames /scratch/eknodel/SCC_samples/cell_lines/gatk_mutect2/244_1_Chu_02_B7_352_225_S2_L003.somatic.filtered.pass.vcf,/scratch/eknodel/SCC_samples/cell_lines/strelka/244_1_Chu_02_B7_352_225_S2_L003/results/variants/somatic.indels.pass.vcf,/scratch/eknodel/SCC_samples/cell_lines/strelka/244_1_Chu_02_B7_352_225_S2_L003/results/variants/somatic.snvs.pass.vcf \
 --rna_vcf_filenames /scratch/eknodel/SCC_samples/cell_lines/RNAseq/gatk_mutect2/244-1-chu-02-B7-6-11-21_226_351_S24_L003.somatic.filtered.pass.vcf,/scratch/eknodel/SCC_samples/cell_lines/RNAseq/gatk_mutect2/244-1-chu-02-B7-6-15-21_214_363_S25_L003.somatic.filtered.pass.vcf,/scratch/eknodel/SCC_samples/cell_lines/RNAseq/gatk_mutect2/244-1-chu-02-B7-6-22-21_202_375_S26_L003.somatic.filtered.pass.vcf,/scratch/eknodel/SCC_samples/cell_lines/RNAseq/gatk_mutect2/244-1-chu-02-B7-6-3-21_262_315_S21_L003.somatic.filtered.pass.vcf,/scratch/eknodel/SCC_samples/cell_lines/RNAseq/gatk_mutect2/244-1-chu-02-B7-6-6-21_250_327_S22_L003.somatic.filtered.pass.vcf,/scratch/eknodel/SCC_samples/cell_lines/RNAseq/gatk_mutect2/244-1-chu-02-B7-6-9-21_238_339_S23_L003.somatic.filtered.pass.vcf \
 --vep_format_fn /scratch/eknodel/SCC_samples/cell_lines/RNA_overlap_mutations/244_B7_RNA_filtered_overlap.vcf \
 --number_of_variants 244_B7_numbers_RNA_filtered.out \
 --variant_ids 244_B7_variant_ids_RNA_filtered.out


# 244 D12

python overlap_RNA_GATK_Strelka.py \
 --vcf_filenames /scratch/eknodel/SCC_samples/cell_lines/gatk_mutect2/244_1_Chu_06_D12_316_261_S5_L003.somatic.filtered.pass.vcf,/scratch/eknodel/SCC_samples/cell_lines/strelka/244_1_Chu_06_D12_316_261_S5_L003/results/variants/somatic.indels.pass.vcf,/scratch/eknodel/SCC_samples/cell_lines/strelka/244_1_Chu_06_D12_316_261_S5_L003/results/variants/somatic.snvs.pass.vcf \
 --rna_vcf_filenames /scratch/eknodel/SCC_samples/cell_lines/RNAseq/gatk_mutect2/244-1-chu-06-D12-6-22-21_213_364_S33_L003.somatic.filtered.pass.vcf,/scratch/eknodel/SCC_samples/cell_lines/RNAseq/gatk_mutect2/244-1-chu-06-D12-6-26-21_201_376_S34_L003.somatic.filtered.pass.vcf,/scratch/eknodel/SCC_samples/cell_lines/RNAseq/gatk_mutect2/244-1-chu-06-D12-7-12-21-1_260_317_S37_L003.somatic.filtered.pass.vcf,/scratch/eknodel/SCC_samples/cell_lines/RNAseq/gatk_mutect2/244-1-chu-06-D12-7-12-21-2_248_329_S38_L003.somatic.filtered.pass.vcf,/scratch/eknodel/SCC_samples/cell_lines/RNAseq/gatk_mutect2/244-1-chu-06-D12-7-9-21-1_284_293_S35_L003.somatic.filtered.pass.vcf,/scratch/eknodel/SCC_samples/cell_lines/RNAseq/gatk_mutect2/244-1-chu-06-D12-7-9-21-2_272_305_S36_L003.somatic.filtered.pass.vcf \
 --vep_format_fn /scratch/eknodel/SCC_samples/cell_lines/RNA_overlap_mutations/244_D12_RNA_filtered_overlap.vcf \
 --number_of_variants 244_D12_numbers_RNA_filtered.out \
 --variant_ids 244_D12_variant_ids_RNA_filtered.out


# 244 F5

python overlap_RNA_GATK_Strelka.py \
 --vcf_filenames /scratch/eknodel/SCC_samples/cell_lines/gatk_mutect2/244_1_Chu_06_F5_328_249_S4_L003.somatic.filtered.pass.vcf,/scratch/eknodel/SCC_samples/cell_lines/strelka/244_1_Chu_06_F5_328_249_S4_L003/results/variants/somatic.indels.pass.vcf,/scratch/eknodel/SCC_samples/cell_lines/strelka/244_1_Chu_06_F5_328_249_S4_L003/results/variants/somatic.snvs.pass.vcf \
 --rna_vcf_filenames /scratch/eknodel/SCC_samples/cell_lines/RNAseq/gatk_mutect2/244-chu-06-F5-6-26-21_285_292_S27_L003.somatic.filtered.pass.vcf,/scratch/eknodel/SCC_samples/cell_lines/RNAseq/gatk_mutect2/244-chu-06-F5-7-2-21-1_273_304_S28_L003.somatic.filtered.pass.vcf,/scratch/eknodel/SCC_samples/cell_lines/RNAseq/gatk_mutect2/244-chu-06-F5-7-2-21-2_261_316_S29_L003.somatic.filtered.pass.vcf,/scratch/eknodel/SCC_samples/cell_lines/RNAseq/gatk_mutect2/244-chu-06-F5-7-2-21-3_249_328_S30_L003.somatic.filtered.pass.vcf,/scratch/eknodel/SCC_samples/cell_lines/RNAseq/gatk_mutect2/244-chu-06-F5-7-9-21-1_237_340_S31_L003.somatic.filtered.pass.vcf,/scratch/eknodel/SCC_samples/cell_lines/RNAseq/gatk_mutect2/244-chu-06-F5-7-9-21-2_225_352_S32_L003.somatic.filtered.pass.vcf \
 --vep_format_fn /scratch/eknodel/SCC_samples/cell_lines/RNA_overlap_mutations/244_F5_RNA_filtered_overlap.vcf \
 --number_of_variants 244_F5_numbers_RNA_filtered.out \
 --variant_ids 244_F5_variant_ids_RNA_filtered.out










