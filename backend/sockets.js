var Highscore =  require('./model/highscore');

var startedGames = {};
module.exports = function(io){



	io.on("connection", function(socket){
	  socket.on('startgame', function(){
			io.sockets.emit('startgame', null);
			startedGames[socket] = Date.now();
	  });

	  socket.on('endgame', function(){

			var elapsedTime = Date.now()-startedGames[socket];
	    console.log("game ended: "+elapsedTime);
			io.sockets.emit('endgame', null);

	  });

		socket.on('disconnect', function(){
			console.log("user disconnected");
		});


	});
};
