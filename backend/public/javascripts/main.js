

$().ready(function(){
	var $body = $("body");
	var socket = io();
	console.log("document ready");
	$("#start").on("click", function(button){
		socket.emit("startgame", Date.now());
		console.log("game started");
	});
	$("#end").on("click", function(button){
		socket.emit("endgame", Date.now());
		console.log("game ended");
	});


	var playing = false;
	socket.on('startgame', function(){
		playing = true;

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
			var d = (Math.random() > 0.5);


			$body.css({"background":"repeating-linear-gradient( "+angle+"deg , #"+color1+" , #"+color2+" "+width1+"px , #"+color3+" "+width2+"px , #"+color4+" "+width3+"px)"});
			$body.children().effect( "shake", {distance:100, direction: dir[d]} );
		}
		else{
			$body.css({"background":"black"});
		}
	}, 1000);




});
