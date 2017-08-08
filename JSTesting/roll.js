function sleep(seconds) {
	var start = new Date().getTime();
	for(var i = 0; i < 1e7; i++) {
		if((new Date().getTime() - start) > seconds*60) {
			break;		
		}	
	}
}

while(true) {
	if(document.getElementById("time_remaining")) {
		var div = document.getElementById("time_remaining");
		var spans = div.getElementsByTagName("span");
		var minutes = parseInt(spans[2].textContent) * 60;
		var seconds = parseInt(spans[4].textContent);
		var totalTime = Number(minutes) + Number(seconds);
		sleep(totalTime);
	} else {
		document.getElementById("free_play_form_button").click();	
	}
}
