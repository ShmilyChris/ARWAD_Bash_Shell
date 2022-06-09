# /bin/bash

read -p "Input Target: " target

python3 ./Sublist3r/sublist3r.py -d $target -o $target.txt &&
./ksubdomain -d $target -f TOP5K.txt -o $target.txt -silent &&
assetfinder -subs-only $target >> $target.2.txt &&
amass enum -passive -d $target -config ./config.ini -o $target.3.txt &&
amass enum -active -d $target -config ./config.ini  -o $target.4.txt
cat $target.txt $target.2.txt $target.3.txt $target.4.txt| sort | uniq > $target.txt &&
httpx -list $target.txt -o $target.active.txt &&
sed  -i "s/https:\/\///g" $target.active.txt &&
sed  -i "s/http:\/\///g" $target.active.txt &&
./ksubdomain -dl $target.active.txt -f TOP5K.txt -o $target.dns.txt -silent &&
httpx -list $target.dns.txt -o $target.dns.active.txt &&
cat $target.dns.active.txt >> $target.active.txt &&
sed  -i "s/https:\/\///g" $target.active.txt &&
sed  -i "s/http:\/\///g" $target.active.txt &&
httpx -list $target.active.txt -sc -title -o $target.active.title.txt &&
subjack -w $target.active.txt -t 100 -timeout 30 -o results.txt -ssl &&
rm -rf $target.2.txt && rm -rf $target.3.txt && rm -rf $target.4.txt && rm -rf $target.dns*
