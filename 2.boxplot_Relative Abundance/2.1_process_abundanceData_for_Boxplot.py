
## run in terminal --
# pip install requests
# pip install json
# pip install pandas

import requests
import json
from pandas.core.frame import DataFrame

import pandas as pd
import numpy as np
import re, os
import math


def txt_2_dict(file):
    with open(file,'r',encoding='utf-8') as f:
        dic=[]
        for line in f.readlines():
            line=line.strip('\n')
            b=line.split(' ')
            dic.append(b)
    return dict(dic)

def get_abundance_each_microbe(mesh_id,ncbi_taxon_id):

    # data_query = {'mesh_id':'D003093',"ncbi_taxon_id" : "40520"}  ## -- to get statistics on MeSH ID D006262
    data_query = {'mesh_id': mesh_id, "ncbi_taxon_id" : str(ncbi_taxon_id)}
    url = 'https://gmrepo.humangut.info/api/getMicrobeAbundancesByPhenotypeMeshIDAndNCBITaxonID'
    data = requests.post(url, data=json.dumps(data_query))

    # The resulting data is a list containing:
    # - hist_data_for_phenotype: a data frame contains the distribution of the relative abundances of the species/genus of interests in all samples of current phenotype,
    # - hist_data_for_health: if current phenotype is not Health, the distribution of the relative abundances of the species/genus of interests in all samples of Health will also be retrieved,
    # - abundant_data_for_disease: a numeric vector contains the relative abundance data of the species/genus of interests in all samples of current phenotype,
    # - abundant_data_for_health: if current phenotype is not Health, the relative abundances of the species/genus of interests in all samples of Health will also be retrieved,
    # - taxon: NCBI taxonomy information for current taxonomy ID,
    # - disease: details of current phenotype,
    # - abundance_and_meta_data: runs in which current taxon is found and related meta data,
    # - co_occurred_taxa: cooccurred taxa of the taxon of interests in current phenotype


    ## --get DataFrames-- "abundance_and_meta_data"
    abundance_and_meta_data = DataFrame(data.json().get('abundance_and_meta_data'))
    # list(abundance_and_meta_data)
    meta_data_microbe = abundance_and_meta_data['relative_abundance'].values  # <class 'numpy.ndarray'>
    meta_data_microbe_log10 = np.log10((meta_data_microbe + 1e-05)/100).round(4)
    return meta_data_microbe_log10



tax_level = ["Genus","Species"]

G_list = np.loadtxt('microbe_info_LM_G.txt',dtype = str ,delimiter = '\n')
G_list = list(G_list)

S_list = np.loadtxt('microbe_info_LM_S.txt',dtype = str ,delimiter = '\n')
S_list = list(S_list)

taxLevel_2_microbes = dict(zip(tax_level,[G_list,S_list]))

D_dict = txt_2_dict('./disease_info_GMrepo.txt')
Disease_list = list(D_dict.keys())


path3 = './f2_diseaseGroup_for_Boxplot_log10/'


if not os.path.isdir(path3): os.mkdir(path3)

for taxLevel, microbe_list in taxLevel_2_microbes.items():

    out_path = path3 + taxLevel
    if not os.path.isdir(out_path): os.mkdir(out_path)

    for disease in Disease_list:
        out_file = out_path + '/' + disease + "_meta_data.txt"

        f = open(out_file,"w+")

        for microbe in microbe_list:
            print(microbe)
            try:
                meta_list = list(get_abundance_each_microbe(disease,microbe))

                for meta in meta_list:
                    f.write(microbe+'\t' + str(meta) + '\n')
            except:
                f.write(microbe + '\n')
        f.close()
