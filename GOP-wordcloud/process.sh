#!/bin/sh

ess select gop

###create a category ####
category_create () {

ess category add $1 $2 --preprocess 'jsncnv -f,eok,qui - -d s:created_at:created_at l:id:id s:text:text s:source:source l:user_id:user.id s:user_des:user.description s:usr_lang:user.lang s:is_translator:user.is_translator f:geo_lat:geo.coordinates[0] f:geo_lon:geo.coordinates[1] s:place_id:place.id s:url:place.url s:place_type:place.place_type s:place_name:place.name s:place_full_name:place.full_name s:place_country_code:place.country_code s:place_country:place.country f:place_coor1_lon:place.bounding_box.coordinates[0].[0].[0] f:place_coor1_lat:place.bounding_box.coordinates[0].[0].[1] f:place_coor2_lon:place.bounding_box.coordinates[0].[1].[0] f:place_coor2_lat:place.bounding_box.coordinates[0].[1].[1] f:place_coor3_lon:place.bounding_box.coordinates[0].[2].[0] f:place_coor3_lat:place.bounding_box.coordinates[0].[2].[1] f:place_coor4_lon:place.bounding_box.coordinates[0].[3].[0] f:place_coor4_lat:place.bounding_box.coordinates[0].[3].[1] s:lang:lang s:timestamp:timestamp_ms' --delimiter=',' --overwrite

}


#####create database#####
database_create () {

ess create database trump --ports 10012
ess create vector wordcount s,pkey:word i,+add:count

ess create database hillary --ports 10013
ess create vector wordcount s,pkey:word i,+add:count

ess create database sanders --ports 10014
ess create vector wordcount s,pkey:word i,+add:count
ess server commit

ess create database random --ports 10016
ess create vector wordcount s,pkey:word i,+add:count
ess server commit

}

###word count function
wordcount () {

ess stream gop '*' '*' | aq_pp -f,+1,eok,qui - -d s,lo@3:text -filt 'PatCmp(text,"*trump*")' | \
           sed 's/ /\n/g' | sed 's/^[[:punct:]]*//;s/[[:punct:]]*$//g' | \
           aq_pp -f,eok,sep='\n' - -d s:word -eval i:count 1 \
           -if -filt 'SLeng(word) > 2' -imp trump:wordcount -endif
ess stream gop '*' '*' | aq_pp -f,+1,eok,qui - -d s,lo@3:text -filt 'PatCmp(text,"*hillary*")' | \
           sed 's/ /\n/g' | sed 's/^[[:punct:]]*//;s/[[:punct:]]*$//g' | \
           aq_pp -f,eok,sep='\n' - -d s:word -eval i:count 1 \
           -if -filt 'SLeng(word) > 2' -imp hillary:wordcount -endif
ess stream gop '*' '*' | aq_pp -f,+1,eok,qui - -d s,lo@3:text -filt 'PatCmp(text,"*sanders*")' | \
           sed 's/ /\n/g' | sed 's/^[[:punct:]]*//;s/[[:punct:]]*$//g' | \
           aq_pp -f,eok,sep='\n' - -d s:word -eval i:count 1 \
           -if -filt 'SLeng(word) > 2' -imp sanders:wordcount -endif
ess stream random '*' '*' | aq_pp -f,+1,eok,qui - -d s,lo@3:text | \
           sed 's/ /\n/g' | sed 's/^[[:punct:]]*//;s/[[:punct:]]*$//g' | \
           aq_pp -f,eok,sep='\n' - -d s:word -eval i:count 1 \
           -if -filt 'SLeng(word) > 2' -imp random:wordcount -endif

aq_udb -exp trump:wordcount -sort count -dec -top 3000 > trumpTopN.csv
aq_udb -exp hillary:wordcount -sort count -dec -top 3000 > hillaryTopN.csv
aq_udb -exp sanders:wordcount -sort count -dec -top 3000 > sandersTopN.csv
aq_udb -exp random:wordcount -sort count -dec -top 3000 > randomTopN.csv

}           

#category_create gop 'tweets/candidate*'     
#database_create
start_T=`date +%s`
ess udbd restart 10012
ess udbd restart 10013
ess udbd restart 10014
ess udbd restart 10016
wordcount
end_T=`date +%s`
echo "Time spend is `expr $end_T - $start_T` second"
