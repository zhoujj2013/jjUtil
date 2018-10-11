python get_sample_info.py sample.json > all.sample.info
less -S all.sample.info | grep "skeletal muscle" > muscle.sample.lst

# http://epigenomesportal.ca/cgi-bin/downloadList.cgi?as=1&i=9&ctc=5&session=
# get GIS.ftp.lst

python get_sample_data_link.py sample.json > dataset.info

#####################
#perl ~/bin/fishInWinter.pl muscle.sample.lst dataset.info | grep "H3K27ac" > muscle.dataset.lst
#perl ~/bin/fishInWinter.pl muscle.sample.lst dataset.info | grep "Input" > input.dataset.lst
#####################
#perl ~/bin/fishInWinter.pl muscle.sample.lst dataset.info | grep "H3K27me3" > muscle.dataset.H3K27me3.lst
#perl ~/bin/fishInWinter.pl muscle.sample.lst dataset.info | grep "H3K36me3" > muscle.dataset.H3K36me3.lst
#perl ~/bin/fishInWinter.pl muscle.sample.lst dataset.info | grep "H3K4me1" > muscle.dataset.H3K4me1.lst
#perl ~/bin/fishInWinter.pl muscle.sample.lst dataset.info | grep "H3K4me3" > muscle.dataset.H3K4me3.lst
#perl ~/bin/fishInWinter.pl muscle.sample.lst dataset.info | grep "H3K9me3" > muscle.dataset.H3K9me3.lst

