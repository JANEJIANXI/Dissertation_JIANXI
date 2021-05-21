import pandas as pd
import numpy as np

FSM = pd.read_excel('functional_similarity_matrix_GS.xlsx')
# FSM.set_index(['Drug_id'],inplace=True)
FSM.drop('Drug_id',axis=1,inplace=True)
SSM = pd.read_excel('tanimoto_matrix_GS.xlsx')
# SSM.set_index(['Drug_id'],inplace=True)
SSM.drop('Drug_id',axis=1,inplace=True)

x = np.zeros((21736,2))

n = FSM.shape[1]

t=0
while t < 21736:
    for i in range(n):
        for j in range(i+1,n):
            x[t][0],x[t][1] = SSM.iloc[i][j],FSM.iloc[i][j]
            t += 1

df = pd.DataFrame(x)
df.columns = ['Structure_similarity','Function_similarity']
S2F = pd.ExcelWriter('similarity_2_function.xlsx')
df.to_excel(S2F)
S2F.save()
