# SSL SCC Neoantigens

Characterization of the neoantigens from a novel solar-simulated light-induced cutaneous squamous cell carcinoma cell line

----

## Contact information

**Cell lines created by:** Anngela Adams

**Contact:** anngelaa@arizona.edu

**Bioinformatics pipeline creation and analysis by:** Elizabeth Borden

**Contact:** knodele@catworks.arizona.edu

---

## Parent tumors

**TO DO: Make directories for the QC and variant calling steps and copy over files from Parent_cell_lines directory that are relevant to these analyses, then update this section of the README**

**Description:** Analysis of whole exome sequencing data from histologically-verified cutaneous squamous cell carcinoma cell lines generated with solar simulated light on BALB/C mice.

**Contents:**

/GATK_CNV 

* Calculates the copy number variation in the variants identified

/Run_fastclone_pipeline

* Steps used to assess heterogeneity of the tumor samples using the fastclone software

/Prep_mobster_input

* Steps used to assess heterogeneity of the tumor samples using the mobster software

---

## Parent Cell Lines

**Description:** Analysis of the neoantigens present in the passaged cell lines derived from the initial parent tumor

**Contents:**

/01_QC_read_mapping

* Quality control with FastQC and MultiQC (https://www.bioinformatics.babraham.ac.uk/projects/fastqc/)

* Trimming with BBduk (https://jgi.doe.gov/data-and-tools/software-tools/bbtools/bb-tools-user-guide/bbduk-guide/)

* Read mapping to the GRCm38.68 reference genome with BWA MEM (https://bio-bwa.sourceforge.net/bwa.shtml)

/02_variant_calling

* Variant calling with three different software GATK Mutect2 (https://gatk.broadinstitute.org/hc/en-us/articles/360037593851-Mutect2), Strelka2 (https://github.com/Illumina/strelka) and Varscan (https://varscan.sourceforge.net/)

/03_variant_annotation

* Variant annotation with Variant Effects Predictor from Ensembl (https://uswest.ensembl.org/info/docs/tools/vep/index.html) 

* Peptide generation with PVACseq (https://pvactools.readthedocs.io/en/latest/pvacseq.html)

* Binding predictions with NetMHCpan4.1 (https://services.healthtech.dtu.dk/service.php?NetMHCpan-4.1) and NetMHCIIpan4.0 (https://services.healthtech.dtu.dk/service.php?NetMHCIIpan-4.0)

/04_variant_specific_expression

* Read mapping with hisat2 (http://daehwankimlab.github.io/hisat2/) 

* Variant specific read counts with GATK ASE Readcounter (https://gatk.broadinstitute.org/hc/en-us/articles/360037428291-ASEReadCounter)

/expression

* Read count quantification with salmon (https://hbctraining.github.io/Intro-to-rnaseq-hpc-O2/lessons/08_salmon.html)

/manta

* Assessing for structural variants with manta (https://github.com/Illumina/manta)
