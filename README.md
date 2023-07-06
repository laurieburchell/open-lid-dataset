# An Open Dataset and Model for Language Identification
Repository accompanying "An Open Dataset and Model for Language Identification" (Burchell et al., ACL 2023).

## LID model: OpenLID

The OpenLID fasttext LID model can be found at https://data.statmt.org/lid/lid201-model.bin.gz. To use it, install [FastText](https://fasttext.cc/), decompress the model, then run `fasttext predict lid201-model.bin $DATA > output.fasttext`.

The model is licensed under the [GNU General Public License v3.0](https://www.gnu.org/licenses/gpl-3.0.html).


## Dataset

The combined dataset used to train the language identification model can be found at https://data.statmt.org/lid/lid201-data.tsv.gz. Each tab-separated line consists of a sentence in one of the 201 languages, a code for the language, and script (e.g. `wol_Latn` = Wolof in Latin script), and the source of that line of data.

To convert the dataset into fasttext training format, run `pigz -dc lid201-data.tsv.gz | awk -F"\t" '{print"__label__"$2" "$1}' > lid201-data.fasttext.tsv`. 

The classes in the training dataset have been sampled to help ameliorate class skew. This means that the larger classes have been subsampled and the smaller classes have been upsampled. If you would like the unsampled datset, you can download it from https://data.statmt.org/lid/lid201-data-unsampled.tsv.gz. 

### Licenses

License considerations for each source are given below; thank you to everyone who put in so much work creating these datasets. Open use of the combined dataset for non-commercial purposes is covered by all licences. If you use this dataset, please cite us plus all the articles in the `citations.bib` file. 

If you view any part of this dataset as a violation of intellectual property rights, please let us know and we will remove it. 

| Source | Description | License |
|---|---|---|
|[Arabic Dialects Dataset](https://www.lancaster.ac.uk/staff/elhaj/corpora.html)| Dataset of Arabic dialects for Gulf, Egyptian, Levantine, and Tunisian Arabic dialects plus MSA|No explicit license; website describes data as "some free and useful Arabic corpora that I have created for researchers working on Arabic Natural Language Processing, Corpus and Computational Linguistics."|
|[BLTR](https://github.com/shashwatup9k/bho-resources)|Monolingual Bhojpuri corpus|[CC BY-NC-SA 4.0](https://creativecommons.org/licenses/by-nc-sa/4.0/)|
|[Global Voices](https://opus.nlpl.eu/GlobalVoices-v2015.php)|A parallel corpus of news stories from the web site Global Voices|The website for [Global Voices](https://globalvoices.org/) is licensed as [Creative Commons Attribution 3.0](https://creativecommons.org/licenses/by/3.0/). There is no explicit additional license accompanying the dataset.|
|[Guaraní Parallel Set](https://github.com/sgongora27/giossa-gongora-guarani-2021)|Parallel Guaraní-Spanish news corpus sourced from Paraguyan websites|No explicit license|
|[HKCanCor](https://github.com/fcbond/hkcancor)|Transcribed conversations in Hong Kong Cantonese|[CC BY 4.0](https://creativecommons.org/licenses/by/4.0/legalcode)|
|[IADD](https://github.com/JihadZa/IADD)|Arabic dialect identification dataset covering 5 regions (Maghrebi, Levantine, Egypt, Iraq, and Gulf) and 9 countries (Algeria, Morocco, Tunisia, Palestine, Jordan, Syria, Lebanon, Egypt and Iraq). It is created from five corpora: [DART](http://qufaculty.qu.edu.qa/telsay), [SHAMI](https://github.com/GU-CLASP/shami-corpus), [TSAC](https://github.com/fbougares/TSAC), [PADIC](https://sourceforge.net/projects/padic/), and [AOC](https://www.cs.jhu.edu/data-archive/AOC-2010/). | Multiple licenses: [Apache License 2.0](https://www.apache.org/licenses/LICENSE-2.0) (SHAMI); [GNU Lesser General Public License v3.0](https://github.com/fbougares/TSAC/blob/master/LICENSE) (TSAC); [GNU General Public License v3](https://www.gnu.org/licenses/gpl-3.0.en.html) (PADIC). DART and AOC had no explicit license.|
|[Leipzig Corpora Collection](https://wortschatz.uni-leipzig.de/en/download)|A collection of corpora in different languages with an identical format.|The [Terms of Usage](https://wortschatz.uni-leipzig.de/en/usage) states "Permission for use is granted free of charge solely for non-commercial personal and scientific purposes licensed under the [Creative Commons License CC BY-NC](https://creativecommons.org/licenses/by-nc/4.0/)."|
|[LTI](https://www.cs.cmu.edu/~ralf/langid.html)|Training data for language identification|From the README: "With the exception of the contents of the Europarl/, ProjectGutenberg/, and PublicDomain/ directories, all code and text in this corpus are copyrighted. However, they may be redistributed under the terms of various Creative Commons licenses and the GNU GPL.  Copying the unmodified archive noncommercially is permitted by all of the licenses. For commercial redistribution or redistribution of modified versions, please consult the individual licenses."|
|[MADAR Shared Task 2019, subtask 1](https://camel.abudhabi.nyu.edu/madar-shared-task-2019/)|Dialectal Arabic in the travel domain|The MADAR Corpus has a custom license, the text of which can be found in this repo.|
|[EM corpus](http://lepage-lab.ips.waseda.ac.jp/en/projects/meiteilon-manipuri-language-resources/)|Parallel Manipuri-English sentences crawled from [The Sangai Express](https://www.thesangaiexpress.com/)|[CC BY-NC 4.0](https://creativecommons.org/licenses/by-nc/4.0/)|
|[MIZAN](https://github.com/omidkashefi/Mizan)|Parallel Persian-English corpus from literature domain|[CC BY 4.0](https://creativecommons.org/licenses/by/4.0/)|
|[MT560 v1](https://opus.nlpl.eu/MT560.php)|A machine translation dataset for over 500 languages to English. We have filtered out data from OPUS-100, Europarl, Open Subtitles, Paracrawl, Wikimedia, Wikimatrix, Wikititles, and Common Crawl due to issues with the fidelity of the language labels. |[Apache License 2.0](https://www.apache.org/licenses/LICENSE-2.0)|
|[NLLB Seed](https://github.com/facebookresearch/flores/blob/main/nllb_seed/README.md)|Around 6000 sentences in 39 languages sampled from Wikipedia, intended to cover languages lacking training data.|[CC BY-SA 4.0](https://creativecommons.org/licenses/by-sa/4.0/)|
|[SETIMES](https://opus.nlpl.eu/SETIMES.php)|A parallel corpus of news articles in the Balkan languages|[CC-BY-SA 3.0](https://creativecommons.org/licenses/by-sa/3.0/)|
|[Tatoeba](https://opus.nlpl.eu/Tatoeba.php)|Collaborative sentence translations|[CC BY 2.0 FR](https://creativecommons.org/licenses/by/2.0/fr/)|
|[Tehran English-Persian parallel corpus (TEP)](https://opus.nlpl.eu/TEP.php)|Parallel Persian-English sentences sourced from subtitles|[GNU General Public License](https://www.gnu.org/licenses/gpl-3.0.html)|
|[Turkic Interlingua (TIL) Corpus](https://github.com/turkic-interlingua/til-mt)|A large-scale parallel corpus combining most of the public datasets for 22 Turkic languages|[CC BY-NC-SA 4.0](https://creativecommons.org/licenses/by-nc-sa/4.0/)|
|[WiLI-2018](https://zenodo.org/record/841984)|Wikipedia language identification benchmark containing 235K paragraphs of 235 languages|[Open Data Commons Open Database License (ODbL) v1.0](https://opendatacommons.org/licenses/odbl/1-0/)|
|[XL-Sum](https://github.com/csebuetnlp/xl-sum)|Summarisation dataset covering 44 languages, sourced from BBC News|[CC BY-NC-SA 4.0](https://creativecommons.org/licenses/by-nc-sa/4.0/)|
