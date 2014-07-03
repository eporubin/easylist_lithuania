#!/bin/bash
export LC_COLLATE="C"
file=$1
if  [ "$1" = "" ]; then
	file="../easylistlithuania.txt"
fi

#src2pipe 
cp $file ~easylistlithuania.txt
sed -i 's/\(.*\#\#\[\)\(src\|src\^\)="http:\/\/\(.*\)"\]$/||\3/' $file
sed -i 's/\(.*\#\#IMG\[\)\(src\|src\^\)="http:\/\/\(.*\)"\]$/||\3/' $file
sed -i 's/\(.*\)\#\#\[\(src\|src\^\)="\(\/.*\)"\]$/||\1\3/' $file
sed -i 's/\(.*\)\#\#\[\(src\|src\^\)="\(.*\)"\]$/||\1\/\3/' $file
sed -i 's/\(.*\)\#\#IMG\[\(src\|src\^\)="\(\/.*\)"\]$/||\1\3/' $file
sed -i 's/\(.*\)\#\#IMG\[\(src\|src\^\)="\(.*\)"\]$/||\1\/\3/' $file
sed -i  's/||www\.\(.*\..*[^|\/].*\)/||\1/p' $file
diff --side-by-side --suppress-common-lines $file ~easylistlithuania.txt >src2pipe_changes.txt
rm ~easylistlithuania.txt

#dėl tarpo meta įspėjimą
sed -i '/^|/ { s/ /%20/gp; }' $file

#surikiuot
cp $file ~easylistlithuania.txt
sed -n '1,8p' ~easylistlithuania.txt > $file
sed -i '1,8d' ~easylistlithuania.txt
cat ~easylistlithuania.txt|sort -u >> $file
rm ~easylistlithuania.txt

#pakeist datą, surašyt komentarus
sed -i '/^\[/d' $file
sed -i '/^\!/d' $file
data=$(date +%Y-%m-%d)
sed -i "1 i\
\[Adblock Plus 2.0\]\n! Title: EasyList Lithuania\n! Contributors: Algimantas Margevičius, Mantas Malcius \n! About not blocked ad or any issues report to algimantas@margevicius.lt\n! Apie neužblokuotas reklamas ar kitas bėdas praneškite el. paštu algimantas@margevicius.lt\n! License: this software is licensed under GNU GPL3 license.\n! License url: http://www.gnu.org/licenses/gpl-3.0.txt\n! Homepage: http://margevicius.lt/easylist_lithuania/\n! Last update: $data\n! Expires: 7 days (update frequency)" $file

#pridėt checksum
cp $file ~easylistlithuania.txt
python2 addChecksum.py < ~easylistlithuania.txt > $file
rm ~easylistlithuania.txt

