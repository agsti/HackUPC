var Highscore =  require('./model/highscore');

var startedGames = {};
module.exports = function(io){



	io.on("connection", function(socket){
	  socket.on('startgame', function(){
			io.sockets.emit('startgame', null);
			startedGames[socket] = Date.now();
	  });

	  socket.on('endgame', function(nombre){

			var elapsedTime = Date.now()-startedGames[socket];

			var newHighscore = new Highscore({
	  		nombre: nombre,
	      puntuacion: (elapsedTime/10000)*(elapsedTime/10000),
	      date: Date.now()

	  	});
	  	newHighscore.save(function(err, highscore){
	  		if(err){
	  			console.log(err);
	  		}
	  		else{
	  			console.log("new highscore created: "+highscore.usuario);
	  		}

	    });



	    console.log("game ended: "+elapsedTime);
			io.sockets.emit('endgame', null);

	  });

		socket.on('disconnect', function(){
			console.log("user disconnected");
		});


	});
};
