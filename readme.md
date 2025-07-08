## **MiraMon Integral Index of Connectivity (ICT)** - calculating habitat connectivity

![MiraMon](misc/images/miramon.png)

This short guide describes the calculation process of Integral Index of Connectivity (ICT), as produced by MiraMon © software.
It is quite simple to run calculations via the MiraMon graphical user interface for the single input dataset, but we focus on the semi-automatic processing of multiple land-use/land-cover (LULC) timeseries, with cleaning and harmonising input data to avoid common issues faced while running MiraMon.

### Installation
To install, download [Miramon v10](https://www.miramon.cat/mus/eng/index.htm) from the official website and follow the instructions. If you already have Miramon installed but you would like to update your version of the ICT plugin, scroll down to the **other applications in alphabetical order**, download `ICT.mmz`, and follow the instructions.

## Workflow
Check the required steps in the [Jupyter Notebook](main.ipynb).

## Useful links
1. [Miramon ICT documentation](https://www.miramon.cat/help/eng/msa/ICT.htm)
2. [Our paper](https://zenodo.org/records/15237079), describing some of the Miramon ICT outputs for Catalonia case study
3. [Short description of ICT datasets on GenCat portal](https://mediambient.gencat.cat/ca/05_ambits_dactuacio/patrimoni_natural/infraestructura-verda/connectivitat-ecologica/cartografia-de-la-connectivitat-ecologica-de-catalunya/)
4. [The detailed description of ICT datasets and computation methods](https://mediambient.gencat.cat/web/.content/home/ambits_dactuacio/patrimoni_natural/connectivitat_ecologica/guia_interpretativa.pdf)
5. [ICT datasets](https://sig.gencat.cat/visors/hipermapa.html), accessible in the Catalonian Hipermapa data service

## Limitations and issues
0. MiraMon ICT is designed for Windows OS. The workflow described in the notebook uses a batch file relying on Windows as well. It might be potentially implemented for another OS through Wine, however we did not aim to make MiraMon software avaialable in another systems at this stage.
1. The most common limitation is ICT performance and time required to run this tool. 
For the general understanding, increasing spatial resolution leads to the proportional increase in computation time:
According to the [official documentation](https://www.miramon.cat/help/eng/msa/ICT.htm), performance is affected not only by the spatial resolution and extent, but also by the parameters of sampling distance and exploration radius - a combination of long exploration radius and short sampling distance could take much more time.<br>
It is simple to plan the computation resources if there is at least one elapsed time known. Elapsed time for the different sampling distance will equal to:<br>
**T₂ = T₁ × (D₁ / D₂)²**<br>
, where D1 - distance for calculation with known time, D2 - distance for calculation with unknown time, T1 - known time, T2 - unknown time.
2. Exploration radius, one of the MiraMon ICT parameters, can only take specific values. Exploration radius, when doubled and divided by the cell side (spatial resolution) of the original files, should be equal to an integer **odd** number.<br><br>
Example:<br>
(525 × 2) / 30 = 35 (valid)<br>
(540 × 2) / 30 = 36 (invalid)<br><br>
If exploration radius does not match this condition, MiraMon ICT will raise an `ERROR: semicostat_quadrat erroni`.
3. MiraMon ICT doesn't support some compression algorithms of input raster datasets, such as ZSTD. If your input landscape impedance or affinity datasets have been compressed using ZSTD algorithm, in the 2nd step in [Notebook](main.ipynb) you will face an `ERROR: File with compression type 50000, not supported`. It is recommended to use one of the following algorithms instead: LZW, Deflate (zlib), TIFF-F/FX, PackBits (Macintosh RLE), JPEG (incl. Modern), CCITT (fax, etc).

#### Acknowledgement
This software is the part of the [AD4GD project, biodiversity pilot](https://ad4gd.eu/biodiversity/). The AD4GD project is co-funded by the European Union, Switzerland and the United Kingdom (UK Research and Innovation).

#### Licence
See [licence file](LICENSE.txt) for details.