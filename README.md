# PDF-PSD_shell
This shell help plot spectrogram. 

## Prerequisite
- [GMT4](https://github.com/GenericMappingTools/gmt)
- [PDF-PSD](https://ds.iris.edu/ds/products/pdf-psd/)

## Usage
To carry out the PDF-PSD analysis, we can take the following steps:                                                    
### preprocess
    1. Put RESP files into ~/QC/PDF/RESP/
    2. Put miniseed files into ~/QC/PDF/data.
       Warning: Put link files in the data directory instead of the real ms files.
### process
    1. Clear data in ~/QC/PDF/PROD/script
    2. cd /home/dmc/QC/PDF/PROD/bin  Then, run makePDFscript.
    3. Run excutePDF.
    4. (Optional) Run splitHourIdx.csh, if the seed files are more then one year.
### results
    1. The results will be in the ~/QC/PDF/STATS/
    2. There are some tools for plotting in the ~/QC/PDF/plot/

