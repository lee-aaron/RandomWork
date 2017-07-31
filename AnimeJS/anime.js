var animeList = [];
var links = [];
var parsedLink = [];

// Fetches anime from user input
function fetchAnime() {
	while (true) {
		var input = prompt("Would you like to enter an anime? Y/N", 'N');
		if (input == 'N') {
			break;
		} else {
			var anime = prompt("Please enter an anime (ex One Piece, Kono Subarashii Sekai ni Shukufuku Wo!, Gamers!", "One Piece");
			if (animeList.indexOf(anime) > -1) {
				console.log("Anime already entered");
			} else {
				animeList.push(anime);
			}
		}
	}

}

function readWebpage(i) {
	var aTags = document.getElementsByTagName("a");
	var searchText = animeList[i];
	for (var i = 0; i < aTags.length; i++) {
		if (aTags[i].textContent == searchText || aTags[i].textContent == searchText.toUpperCase()) {
			// Returns tag with search text
			if (links.indexOf(aTags[i]) > -1) {
				console.log("Tag already entered");
			} else {
				links.push(aTags[i]);
			}
			break;
		}
	}
}

function httpGet(url) {
	if (window.XMLHttpRequest) {
		xmlhttp = new XMLHttpRequest();
	} else {
		xmlhttp = new ActiveXObject("Microsoft.XMLHTTP");
	}
	xmlhttp.onreadystatechange = function () {
		if (this.readyState == this.DONE) {
			dump(xmlhttp.responseText);
		}
	}
	xmlhttp.open("GET", url, false);
	xmlhttp.send();
}

fetchAnime();
for (i in animeList) {
	readWebpage(i);
}
for (i in links) {
	console.log(links[i]);
	parsedLink.push(links[i].toString());
	httpGet(parsedLink[i]);
}