#Process somatic mutation
import sys
import pandas as pd

#neo_file=sys.argv[1]
mutation_file=sys.argv[1]
sample_name=sys.argv[2]
out_dir=sys.argv[3]

vaf_list=[]
mutation_list=[]
coverage=[]
f_mutation=open(mutation_file,'r')
for ele in f_mutation:
    if ele.startswith('#'):
        continue
    else:
        line=ele.strip().split('\t')
        if line[0]!="chrMT":
            #print(line)
            chro_pos=line[0]+':'+line[1]
            tumor_read_info=line[9].split(':')
            vaf=float(tumor_read_info[2].split(',')[0])
            depth=float(tumor_read_info[3].split(',')[0])
            mutation_list.append(chro_pos)
            vaf_list.append(vaf)
            coverage.append(depth)
        else:
            continue

import pandas as pd 
data_snp=pd.DataFrame()
data_snp["mutation_id"]=mutation_list
data_snp["VAF"]= vaf_list
data_snp["coverage"] = coverage

data_snp.to_csv(out_dir+"/"+sample_name+"_vaf.txt",header=1,sep="\t",index=0)
