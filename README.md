# SSL SCC Neoantigens

Characterization of the neoantigens from a novel solar-simulated UV light-induced cutaneous squamous cell carcinoma cell line

----

## Contact information

**Cell lines created by:** Anngela Adams

**Contact:** anngelaa@arizona.edu

**Bioinformatics pipeline creation and analysis by:** Elizabeth Borden

**Contact:** knodele@catworks.arizona.edu

---

## Parent tumors

**TO DO: Determine if we will be using any of the heterogeneity analysis and remove if not**

**Description:** Analysis of whole exome sequencing data from histologically-verified cutaneous squamous cell carcinoma cell lines generated with solar simulated light on BALB/C mice. Cell lines were sequenced at passage 7.

**Contents:**

/01_QC_mapping

* Quality control with FastQC and MultiQC (https://www.bioinformatics.babraham.ac.uk/projects/fastqc/)

* Trimming with BBduk (https://jgi.doe.gov/data-and-tools/software-tools/bbtools/bb-tools-user-guide/bbduk-guide/)

* Read mapping to the GRCm38.68 reference genome with BWA MEM (https://bio-bwa.sourceforge.net/bwa.shtml)

/02_variant_calling

* Variant calling with two different software GATK Mutect2 (https://gatk.broadinstitute.org/hc/en-us/articles/360037593851-Mutect2) and Strelka2 (https://github.com/Illumina/strelka)

/03_variant_annotation

* Overlap of GATK Mutect2 and Strelka2

* Variant annotation with Variant Effects Predictor from Ensembl (https://uswest.ensembl.org/info/docs/tools/vep/index.html)

* Peptide generation with PVACseq (https://pvactools.readthedocs.io/en/latest/pvacseq.html)

* Binding predictions with NetMHCpan4.1 (https://services.healthtech.dtu.dk/service.php?NetMHCpan-4.1) and NetMHCIIpan4.0 (https://services.healthtech.dtu.dk/service.php?NetMHCIIpan-4.0)

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

* Variant calling with two different software GATK Mutect2 (https://gatk.broadinstitute.org/hc/en-us/articles/360037593851-Mutect2) and Strelka2 (https://github.com/Illumina/strelka)

/03_variant_annotation

* To enable comparisons of raw and filtered variant calls, unfiltered and filtered results from GATK Mutect2 and Strelka2 were each processed seperately

* gatk_mutect2_MNP_change.snakefile used to re-calle the variants from GATK, splitting MNPs to enable downstream GATK ASEreadcounts

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

## Progeny

**Description:** Analysis of the neoantigens present in a cell line after passage in vivo in a mouse for 3 weeks

**Contents:**


 /01_QC_read_mapping

* Quality control with FastQC and MultiQC (https://www.bioinformatics.babraham.ac.uk/projects/fastqc/)

* Trimming with BBduk (https://jgi.doe.gov/data-and-tools/software-tools/bbtools/bb-tools-user-guide/bbduk-guide/)

* Read mapping to the GRCm38.68 reference genome with BWA MEM (https://bio-bwa.sourceforge.net/bwa.shtml)

/02_variant_calling

* Variant calling with two different software GATK Mutect2 (https://gatk.broadinstitute.org/hc/en-us/articles/360037593851-Mutect2) and Strelka2 (https://github.com/Illumina/strelka)

/03_variant_annotation

* To enable comparisons of raw and filtered variant calls, unfiltered and filtered results from GATK Mutect2 and Strelka2 were each processed seperately

* gatk_mutect2_MNP_change.snakefile used to re-calle the variants from GATK, splitting MNPs to enable downstream GATK ASEreadcounts

* Variant annotation with Variant Effects Predictor from Ensembl (https://uswest.ensembl.org/info/docs/tools/vep/index.html)

* Peptide generation with PVACseq (https://pvactools.readthedocs.io/en/latest/pvacseq.html)

* Binding predictions with NetMHCpan4.1 (https://services.healthtech.dtu.dk/service.php?NetMHCpan-4.1), NetMHCIIpan4.0 (https://services.healthtech.dtu.dk/service.php?NetMHCIIpan-4.0), NetMHCpan4.0 (for comparison to previous manuscripts), netCTLpan for processing scores

* /archive contains previous iterations of the same scripts 

/04_variant_specific_expression

* Read mapping with hisat2 (http://daehwankimlab.github.io/hisat2/)

* Variant specific read counts with GATK ASE Readcounter (https://gatk.broadinstitute.org/hc/en-us/articles/360037428291-ASEReadCounter)

/expression

* Read count quantification with salmon (https://hbctraining.github.io/Intro-to-rnaseq-hpc-O2/lessons/08_salmon.html)

/RNA_mutations

* Variant calling from RNA in tumor-only mode
