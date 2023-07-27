<p align="center"><img width="320" src="https://github.com/laurieburchell/open-lid-dataset/blob/0cbea4aca70677333da1d7d63babeaab538d7e56/openlid-logo.png" alt="OpenLID - fast natural language identification for 200+ languages"></p>

# OpenLID

Fast natural language identification for 200+ languages, plus all the data to train the model.

## Features

 - Supports 201 languages
 - High performance
 - Fast and easy to use
 - Fully transparent: training data and per-language performance openly available

## Get started

OpenLID is a [fastText](https://fasttext.cc/docs/en/support.html) model.

To download and decompress:

```shell
wget https://data.statmt.org/lid/lid201-model.bin.gz
pigz -d lid201-model.bin.gz
```

Example to get most likely labels for $DATA:

```shell
fasttext predict lid201-model.bin $DATA > output.fasttext

```

## Dataset

Download the dataset (c. 21GB) and convert it to fastText traning format:
```shell
wget https://data.statmt.org/lid/lid201-data.tsv.gz
pigz -dc lid201-data.tsv.gz | awk -F"\t" '{print"__label__"$2" "$1}' > lid201-data.fasttext.tsv

```
Each tab-separated line consists of a sentence in one of the 201 languages, a code for the language, and script (e.g. `wol_Latn` = Wolof in Latin script), and the source of that line of data.

The classes in the training dataset have been sampled to help ameliorate class skew. This means that the larger classes have been subsampled and the smaller classes have been upsampled. If you would like the unsampled datset, you can download it from https://data.statmt.org/lid/lid201-data-unsampled.tsv.gz. 

## Citations

If you use this dataset, please [cite us](https://aclanthology.org/2023.acl-short.75) plus all the articles in the `citations.bib` file. Thank you to everyone who put in so much work creating these datasets! 
