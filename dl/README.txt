# to get GSM id you want

1. Search in GEO DataSets by specific term, such as (H3K27ac) AND "Mus musculus"[porgn:__txid10090].
   you should filter by Series and Samples
2. Download gds_result_Series.txt and gds_result_Samples.txt
3. Get GSE id list from gds_result.
   perl get_gseid.pl gds_result_Series.txt
   perl get_gsmid.pl gds_result_Samples.txt
   
4. Get GSM id and GSM related information
   perl getGsmInfoByGsm.pl GSMid.lst > result 2>err

After manually check, we can download the dataset.
# to download data by a GSM id

