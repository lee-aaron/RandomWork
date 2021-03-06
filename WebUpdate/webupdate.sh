#!/bin/bash

index()
{
	echo "$(echo $@ | grep -aob '"' | grep -oE '[0-9]+' | sed "${!#};d")"
}

[ ! -d $(pwd)/Manga ] && mkdir -p ./Manga
[ ! -f $(pwd)/Manga/manga.txt ] && touch ./Manga/manga.txt

PS3='Type a number corresponding to option: '
options=("Download Manga" "Check for Updates" "Delete Manga" "Quit")
select opt in "${options[@]}"
do
	case $opt in
		"Download Manga")
			while true; do
				echo "Please enter the full name of the manga (ex. One Piece or Kono Subarashii Sekai Ni Shukufuku O). Type Done or done if you don't want to enter anymore."
				read resp
				if [[ "$resp" == "Done" || "$resp" == "done" ]]; then
					break
				else
					resp=${resp// /-}
					[ ! -d $(pwd)/Manga/$resp ] && mkdir -p ./Manga/$resp
					if grep -Fxq $resp ./Manga/manga.txt; then
						echo "Manga is already entered"
					else
						echo "$resp" >> ./Manga/manga.txt
					fi
				fi
			done
			cd Manga
			while IFS='' read -r line <&9 || [[ -n "$line" ]]; do
				[ ! -d ./$line ] && mkdir -p ./$line
				cd $line
				manga=$line
				manga=${manga//-/ }
				echo "Type Y/y to download all chapters for $manga or type 0 to skip or type anything else to select a range"
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
					cd ..
				elif [ $ans == "0" ]; then
					cd ..
					continue
				else
					echo "Enter the chapter range."
					echo "Start:"
					read chaps
					echo "End:"
					read chape
					for((c=$chaps;c<=$chape;c++)) do
						[ ! -d ./$c ] && mkdir -p ./$c
						cd $c
						line=${line,,}
						wget -q -O index.html -c www.mangareader.net/$line/$c
						if grep -q "not released yet" index.html; then
							echo "Ch. $c of $line  is not available at www.mangareader.net"
							cd ..
							rm -rf $c
							break
						fi
						rm index.html
						declare -i i=1
						while true; do
							echo "Downloading page $i of Ch. $c"
							wget -q -O $i.html -c www.mangareader.net/$line/$c/$i
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
						chapno=0000$c
						chapno=${chapno: -4}
						convert *.jpg ../Ch$chapno.pdf
						echo "Cleaning up....."
						cd ..
						path=$(pwd)
						echo -e "Your downloaded file is in this path:\n" $path
						rm -rf $c
					done
					cd ..
				fi
			done 9< "manga.txt"
			echo "Downloads complete. Please use 'gnome-open' to open the PDFs."
			cd ..
			;;
		"Check for Updates")
			cd Manga
			while IFS='' read -r line <&9 || [[ -n "$line" ]]; do
				manga=$line
				manga=${manga,,}
				wget -O temp.html -q www.mangareader.net/$manga
				latest=$(grep -m1 -oP "(?<=a href=\"/${manga}/).*(?=</a>)" temp.html)
				chapl=$(echo $latest | sed -e 's/.*>//g')
				lnum=$(cat -n temp.html | grep "$chap1" | tail -1 | cut -f 1)
				((lnum++))
				date=$(sed "${lnum}q;d" temp.html)
				date=${date:4:-5}
				rm temp.html
				chap="${chapl##* }"
				title="${chapl% *}"
				printf "%-25s %35s %18s\n" "$title" "$chap" "$date"
			done 9< "manga.txt"
			cd ..
			;;
		"Delete Manga")
			echo "Which manga would you like to delete? (ex. One Piece or Kono Subarashii Sekai Ni Shukufuku O)"
			read resp
			resp=${resp// /-}
			if [ -d  ./Manga/$resp ]; then
				rm -r ./Manga/$resp
				echo "Manga deleted"			
			else
				echo "Manga doesn't exist"				
			fi
			;;
		"Quit")
			break
			;;
		*) echo Invalid Option;;
	esac
done
