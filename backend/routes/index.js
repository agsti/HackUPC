var express = require('express');
var router = express.Router();

var mongoose = require('mongoose');
var db = mongoose.connect('mongodb://localhost:/midmi');
var Highscore =  require('../model/highscore');





/* GET home page. */

router.post('/', function(req, res){
  	var newHighscore = new Highscore({
  		nombre: req.body.nombre,
      puntuacion: req.body.puntuacion,
      date: Date.now()

  	});
  	newHighscore.save(function(err, highscore){
  		if(err){
  			console.log(err);
  			res.status(500).send("Internal Error");
  		}
  		else{
  			console.log("new highscore created: "+highscore.usuario);
  			res.redirect("back");
  		}

    });
  }
  );



router.get('/', function(req, res, next) {


  Highscore.find({}).limit(10).sort({'puntuacion':'desc'}).exec(function(err, hs){
    res.render('index', { highscores: hs, moment :require('moment') });
  });
});

module.exports = router;
