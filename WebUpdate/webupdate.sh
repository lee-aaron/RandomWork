#!/bin/bash

index()
{
	echo "$(echo $@ | grep -aob '"' | grep -oE '[0-9]+' | sed "${!#};d")"
}

[ ! -d $(pwd)/Manga ] && mkdir -p ./Manga
[ ! -f $(pwd)/Manga/manga.txt ] && touch ./Manga/manga.txt

while true; do
	echo "Please enter the full name of the manga (ex. One Piece or Kono Subarashii Sekai Ni Shukufuku O). Type Done or done if you don't want to enter anymore."
	read resp
	if [[ "$resp" == "Done" || "$resp" == "done" ]]; then
		break
	else
		resp=${resp// /-}
		[ ! -d $(pwd)/Manga/$resp ] && mkdir -p ./Manga/$resp
		echo "$resp" >> ./Manga/manga.txt
	fi
done
cd Manga
while IFS='' read -r line <&9 || [[ -n "$line" ]]; do
	cd $line
	manga=$line
	manga=${manga//-/ }
	echo "Do you want to download all the chapters for $manga? Type Y/y"
	read -r ans
	if [[ $ans == "Y" || $ans == "y" ]]; then
		chaps=1
		while true; do
			[ ! -d ./$chaps ] && mkdir -p ./$chaps
			cd $chaps
			line=${line,,}
			wget -q -O index.html -c www.mangareader.net/$line/$chaps	
			if grep -q "not released yet" index.html; then
				cd ..
				rm -rf $chaps
				break
			fi
			rm index.html
			declare -i i=1
			while true; do
				echo "Downloading page $i of Ch. $chaps"
				wget -q -O $i.html -c www.mangareader.net/$line/$chaps/$i
				grep 'src=\"http' $i.html | grep 'mangareader' > jump.txt
				link=$(head -n 1 jump.txt)
				starti=$(index $link "11q")
				endi=$(index $link "12q")
				if grep -q "Larger Image" $i.html; then
					starti=$(index $link "9q")
					endi=$(index $link "10q")
				fi
				length=$((endi-starti))
				image=${link:$((starti+1)):$((length-1))}
				length=${#image}
				if [[ "$length" -eq 0 ]]; then
					break
				fi
				imagename=0000$i
				wget -O ${imagename: -4}.jpg -q -c $image
				i=i+1	
			done
			echo "Converting to pdf..."
			chapno=0000$chaps
			chapno=${chapno: -4}
			convert *.jpg ../Ch$chapno.pdf
			echo "Cleaning up....."
			path=$(pwd)
			echo -e "Your downloaded file is in this path:\n" $path
			cd ..
			rm -rf $chaps
			chaps=chaps+1
		done
	else	
		echo "Enter the chapter range."
		echo "Start:"
		read chaps
		echo "End:"
		read chape
		for((c=$chaps;c<=$chape;c++)) do
			[ ! -d ./$chaps ] && mkdir -p ./$chaps
			cd $chaps
			line=${line,,}
			wget -q -O index.html -c www.mangareader.net/$line/$chaps	
			if grep -q "not released yet" index.html; then
				echo "Ch. $chaps of $line  is not available at www.mangareader.net"
				cd ..
				rm -rf $chaps
				break
			fi
			rm index.html
			declare -i i=1
			while true; do
				echo "Downloading page $i of Ch. $chaps"
				wget -q -O $i.html -c www.mangareader.net/$line/$chaps/$i
				grep 'src=\"http' $i.html | grep 'mangareader' > jump.txt
				link=$(head -n 1 jump.txt)
				starti=$(index $link "11q")
				endi=$(index $link "12q")
				if grep -q "Larger Image" $i.html; then
					starti=$(index $link "9q")
					endi=$(index $link "10q")
				fi
				length=$((endi-starti))
				image=${link:$((starti+1)):$((length-1))}
				length=${#image}
				if [[ "$length" -eq 0 ]]; then
					break
				fi
				imagename=0000$i
				wget -O ${imagename: -4}.jpg -q -c $image
				i=i+1	
			done
			echo "Converting to pdf..."
			chapno=0000$chaps
			chapno=${chapno: -4}
			convert *.jpg ../Ch$chapno.pdf
			echo "Cleaning up....."
			cd ..
			path=$(pwd)
			echo -e "Your downloaded file is in this path:\n" $path
			rm -rf $chaps
		done
	fi
	cd ..
done 9< "manga.txt"
echo "Downloads complete. Please use 'gnome-open' to open the PDFs."