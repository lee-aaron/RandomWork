while(true) {
	if(document.getElementById("time_remaining")) {
		var div = document.getElementById("time_remaining");
		var spans = div.getElementsByTagName("span");
		var minutes = parseInt(spans[2].textContent);
		var seconds = parseInt(spans[4].textContent);
		var totalTime = minutes*60 + seconds;
		console.log(totalTime);
	} else {
		document.getElementById("free_play_form_button").click();	
	}
}
