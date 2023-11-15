<p align="center"><img width="320" src="https://github.com/laurieburchell/open-lid-dataset/blob/0cbea4aca70677333da1d7d63babeaab538d7e56/openlid-logo.png" alt="OpenLID - fast natural language identification for 200+ languages"></p>

# OpenLID

Fast natural language identification for 200+ languages, plus all the data to train the model.

## Features

 - Supports [201 languages](languages.md)
 - High performance
 - Fast and easy to use
 - Fully transparent: training data and per-language performance openly available
 - Used by [Wikimedia](https://diff.wikimedia.org/2023/10/24/open-language-identification-api-for-200-languages/)

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

### Quantised model

There is also a quantised version of the model with a much smaller memory footprint (7MB rather than 1.2GB) but similar performance (macroaverage F1 score of 0.921 versus 0.927). 

```shell
wget https://data.statmt.org/lid/lid201-model.ftz
```


## Dataset

Download the dataset (c. 21GB) and convert it to fastText training format:
```shell
wget https://data.statmt.org/lid/lid201-data.tsv.gz
pigz -dc lid201-data.tsv.gz | awk -F"\t" '{print"__label__"$2" "$1}' > lid201-data.fasttext.tsv

```
Each tab-separated line consists of a sentence in one of the 201 languages, a code for the language, and script (e.g. `wol_Latn` = Wolof in Latin script), and the source of that line of data.

The classes in the training dataset have been sampled to help ameliorate class skew. This means that the larger classes have been subsampled and the smaller classes have been upsampled. If you would like the unsampled datset, you can download it from https://data.statmt.org/lid/lid201-data-unsampled.tsv.gz. 


## Training

We used the following command to train the model:
```shell
fasttext supervised -input lid201-data.fasttext.tsv -output lid201-model -minCount 1000 -bucket 1000000 -minn 2 -maxn 5 -lr 0.8 -dim 256 -epoch 2 -thread 68 -wordNgrams 1
```
More details about the dataset and model creation are available in the accompanying paper: [An Open Dataset and Model for Language Identification](https://aclanthology.org/2023.acl-short.75.pdf).

## Citations

If you use our model, please [cite us](https://aclanthology.org/2023.acl-short.75). If you use the dataset, please cite us plus all the articles in the `citations.bib` file. Thank you to everyone who put in so much work creating these datasets! 


## Licenses

The model is licensed under the [GNU General Public License v3.0](LICENSE). The individual datasets that make up the training dataset have different licenses but all allow (at minimum) free use for research - [a full list](licenses.md) is available in this repo.
