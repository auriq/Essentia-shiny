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

}

###word count function
wordcount () {

ess stream gop '*' '*' | aq_pp -f,+1,eok,qui - -d s@3:text -filt 'PatCmp(text,"*trump*","ncas")' | \
           tr -s '[[:space:][:blank:][:punct:]]' '\n' | \
           aq_pp -d s:word -eval i:count 1 \
           -if -filt 'SLeng(word) > 3' -imp trump:wordcount -endif
ess stream gop '*' '*' | aq_pp -f,+1,eok,qui - -d s@3:text -filt 'PatCmp(text,"*hillary*","ncas")' | \
           tr -s '[[:space:][:blank:][:punct:]]' '\n' | \
           aq_pp -d s:word -eval i:count 1 \
           -if -filt 'SLeng(word) > 3' -imp hillary:wordcount -endif
ess stream gop '*' '*' | aq_pp -f,+1,eok,qui - -d s@3:text -filt 'PatCmp(text,"*sanders*","ncas")' | \
           tr -s '[[:space:][:blank:][:punct:]]' '\n' | \
           aq_pp -d s:word -eval i:count 1 \
           -if -filt 'SLeng(word) > 3' -imp sanders:wordcount -endif
aq_udb -exp trump:wordcount -sort count -dec -top 3000 > trumpTop.csv
aq_udb -exp hillary:wordcount -sort count -dec -top 3000 > hillaryTop.csv
aq_udb -exp sanders:wordcount -sort count -dec -top 3000 > sandersTop.csv

}           

#category_create gop 'tweets/candidate*'     
start_T=`date +%s`
database_create
ess udbd restart 10012
ess udbd restart 10013
ess udbd restart 10014
wordcount
end_T=`date +%s`
echo "Time spend is `expr $end_T - $start_T` second"
