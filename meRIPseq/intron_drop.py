import os
import matplotlib.pyplot as plt
import argparse
import warnings
import pandas as pd
warnings.filterwarnings("ignore")

def handler():
  parser = argparse.ArgumentParser()
  parser.add_argument("-i", "--input_dir", help="Absolute path to the directory (the project directory)", type=str)
  parser.add_argument('-b', '--bed', help='bed file name', type=str)
  parser.add_argument('-f', '--fa', help='fasta file name', type=str)
  args = parser.parse_args()
  return args

def read_fasta(path):
    file = open(path)
    lines = file.read().splitlines()
    ids = [s[1:] for s in lines if '>' in s]
    n = [i for i,s in enumerate(lines) if '>' in s]
    n.append(len(lines))
    sequences = [''.join(lines[i+1:j]) for i,j in zip(n[:-1],n[1:])]
    file.close()
    fa = dict(zip(ids, sequences))
    return fa

def write_fasta(path, fa):
    file = open(path, 'w')
    for f in fa:
        file.write('>' + f + '\n')
        file.write(fa[f] + '\n')
    file.close()

def remove_intron(bed, fa):
    fa = read_fasta(fa)
    bed = pd.read_table(bed, header=0)
    tochange = bed[bed.blockCount > 1]
    starts = [tochange.blockStarts[i].split(',')[:tochange.blockCount[i]] for i in tochange.index.tolist() ]
    sizes = [tochange.blockSizes[i].split(',')[:tochange.blockCount[i]] for i in tochange.index.tolist() ]
    for id, x, l in zip(tochange.name.tolist(), starts, sizes):
        fa[id] = ''.join([fa[id][int(i):int(i)+int(j)] for i,j in zip(x,l)])
    return fa


args = handler()
path = {}
path['indir'] = args.input_dir
path['bed'] = f'./{args.bed}'
path['fa'] = f'./{args.fa}'
path['nointron.fa'] = f'./{args.fa}nointron.fa'
os.chdir(path['indir'])
# write fa file without intron sequences
write_fasta(path['nointron.fa'], remove_intron(path['bed'], path['fa']))
