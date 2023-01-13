import argparse
from collections import defaultdict

def select_variants_at_least_two_callers(vcfs, rna_vcfs, vep_format, number_of_variants, variant_ids):
    """

    :param vcfs:
    :return:
    """
    variants_counter = defaultdict(list)
    rna_dict = defaultdict(list)    

    # Initialize a summary file to document the number of variants there are in each vcf file
    num_variants_summary = open(number_of_variants, "w")
    header = ["filename", "num_variants"]
    print("\t".join(header), file=num_variants_summary)

    # Initilize an output for vep
    vep_format = open(vep_format, "w")
    variant_ids = open(variant_ids, "w")

    for vcf in rna_vcfs:
        num_variants = 0
        with open(vcf, "r") as f:
            for line in f:
                if not line.startswith("#"):
                    num_variants += 1
                    cols = line.rstrip("\n").split("\t")
                    variant_id = cols[0] + "-" + cols[1] + "-" + cols[3] + "-" + cols[4]
                    rna_dict[variant_id].append(1)
        out = [vcf, str(num_variants)]
        print("\t".join(out), file=num_variants_summary)
    total_vcfs = 0
    vcfs1 = 0
    vcfs2 = 0
    vcfs3 = 0
    vcfs4 = 0
    vcfs5 = 0
    vcfs6 = 0
    for variant_id in rna_dict:
        if len(rna_dict[variant_id]) >= 1:
            total_vcfs += 1
    for variant_id in rna_dict:
        if len(rna_dict[variant_id]) == 1:
            vcfs1 += 1
        elif len(rna_dict[variant_id]) == 2:
            vcfs2 += 1
        elif len(rna_dict[variant_id]) == 3:
            vcfs3 += 1
        elif len(rna_dict[variant_id]) == 4:
            vcfs4 += 1
        elif len(rna_dict[variant_id]) == 5:
            vcfs5 += 1
        elif len(rna_dict[variant_id]) == 6:
            vcfs6 += 1
    out = ["total_variants", str(total_vcfs), "1_vcf", str(vcfs1), "2_vcfs", str(vcfs2), "3_vcfs", str(vcfs3), "4_vcfs", str(vcfs4), "5_vcfs", str(vcfs5), "6_vcfs", str(vcfs6)]
    print("\t".join(out), file=num_variants_summary)

    for vcf in vcfs:
        num_variants = 0
        overlap_RNA = 0
        with open(vcf, "r") as f:
            for line in f:
                if not line.startswith("#"):
                    num_variants += 1
                    cols = line.rstrip("\n").split("\t")
                    variant_id = cols[0] + "-" + cols[1] + "-" + cols[3] + "-" + cols[4]
                    variants_counter[variant_id].append(1)
                    if variant_id in rna_dict and len(variants_counter[variant_id])>=2:
                        overlap_RNA +=1
                    if variant_id in rna_dict and len(variants_counter[variant_id])==1:
                        cols = variant_id.split("-")
                        vep_row = [cols[0], cols[1], ".", cols[2], cols[3], ".", ".", "."]
                        var_id = [cols[0], cols[1], cols[2], cols[3]]
                        print("\t".join(vep_row), file=vep_format)
                        print(":".join(var_id), file=variant_ids)
                        overlap_RNA += 1
        out = [vcf, str(num_variants)]
        print("\t".join(out), file=num_variants_summary)
        out = [vcf, "RNA_overlap", str(overlap_RNA)]
        print("\t".join(out), file=num_variants_summary)
    vcfs2 = 0
    overlap_both_RNA = 0
    overlap_either_RNA = 0
    for variant_id in variants_counter:
        if len(variants_counter[variant_id]) == 2:
            vcfs2 += 1
            if variant_id in rna_dict:
                overlap_both_RNA +=1
    for variant_id in variants_counter:
        if variant_id in rna_dict:
            overlap_either_RNA +=1
    out = ["GATK/Strelka Overlap", str(vcfs2)]
    print("\t".join(out), file=num_variants_summary)
    out = ["GATK/Strelka Overlap in RNA", str(overlap_both_RNA)]
    print("\t".join(out), file=num_variants_summary)
    out = ["Either GATK/Strelka in RNA", str(overlap_either_RNA)]
    print("\t".join(out), file=num_variants_summary)

def main(args):
    vcfs_list = args.vcf_filenames.split(',')
    vcfs_rna_list = args.rna_vcf_filenames.split(',')
    select_variants_at_least_two_callers(vcfs_list, vcfs_rna_list, args.vep_format_fn, args.number_of_variants, args.variant_ids)

def parse_args():
    parser = argparse.ArgumentParser(
        description="Prepare input for the program variant effect predictor from one or more vcf files")
    parser.add_argument("--vcf_filenames", required=True,
                        help="Enter the path to one DNA vcf file or paths to many DNA vcf files separated by commas")
    parser.add_argument("--rna_vcf_filenames", required=True,
                        help="Enter the path to one RNA vcf file or paths to many RNA vcf files separated by commas")
    parser.add_argument("--vep_format_fn", required=True,
                        help="Enter the path to the output file in VEP format")
    parser.add_argument("--number_of_variants", required=True,
                        help="Enter the path to the output file for variant counts")
    parser.add_argument("--variant_ids", required=True,
                        help="Enter the path to the output file for variant ids (to be used for overlap analysis between cell lines)")

    return parser.parse_args()

main(parse_args())
