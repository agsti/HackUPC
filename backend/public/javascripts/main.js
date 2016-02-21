
function shuffle(o) {
  var j, x;
  for (var i = o.length; i; i -= 1) {
    j = Math.floor(Math.random() * i);
    x = o[i-1];
    o[i-1] = o[j];
    o[j] = x;
  }

  return o;
}



$().ready(function(){
	var $body = $("body");
	var socket = io();
	var titleClasses = ["a", "b", "c", "d", "e", "f", "g"];



	console.log(titleClasses);
	$("#start").on("click", function(button){
		socket.emit("startgame", Date.now());
	});
	$("#end").on("click", function(button){
		socket.emit("endgame", "agus");
	});

	var $titulo = $("#title");

	var music = new Audio('../assets/psytrance.mp3');
	var playing = false;
	socket.on('startgame', function(){
		playing = true;
		music.currentTime = 0
		music.play();
	});

	socket.on('endgame', function(){
		playing =  false;
		location.reload();
	});

	setInterval(function(){
		if(playing){
			//$body.toggleClass("shake")
			var angle =  Math.round(Math.random()*180).toString(10);
			var color1 = Math.round(Math.random()*0xFFFFFF).toString(16);
			var color2 = Math.round(Math.random()*0xFFFFFF).toString(16);
			var color3 = Math.round(Math.random()*0xFFFFFF).toString(16);
			var color4 = Math.round(Math.random()*0xFFFFFF).toString(16);

			var width1 = Math.round(Math.random()*300).toString(10);
			var width2 = Math.round(Math.random()*300).toString(10);
			var width3 = Math.round(Math.random()*300).toString(10);

			var dir = ["left", "up"];
			var d;
			if (Math.random() > 0.5){
				d = 0;
			}
			else{
				d = 1;
			}

			// for (var i = 0; i< $titulo.children().length ; i++) {
			// 	var elemento  = $titulo.children()[i];
			//
			// }


			var times = Math.round(Math.random()*10);
			var distance =  Math.round(Math.random()*100);

			$body.css({"background":"repeating-linear-gradient( "+angle+"deg , #"+color1+" , #"+color2+" "+width1+"px , #"+color3+" "+width2+"px , #"+color4+" "+width3+"px)"});
			$body.children().effect( "shake", {distance:distance, direction: dir[d], times:times} );
		}
		else{
			$body.css({"background":"black"});
		}
	}, 1000);




});
