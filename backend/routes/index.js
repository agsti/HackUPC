var express = require('express');
var router = express.Router();

var mongoose = require('mongoose');
var db = mongoose.connect('mongodb://localhost:/midmi');
var Highscore =  require('../model/highscore');





router.get('/top', function(req, res, next){
  Highscore.find({}).limit(5).sort({'puntuacion':'desc'}).exec(function(err, hs){
    if(hs != null && err == null){
      res.json(hs);
    }
    else{
      res.send();
    }
  });
});


router.post('/partida', function(req, res){
  var newHighscore = new Highscore({
    nombre: req.body.nombre,
    puntuacion: req.body.puntuacion,
    date: Date.now()

  });
  newHighscore.save(function(err, highscore){
    if(err){
      console.log(err);
      res.send("OK");
    }
    else{
      console.log("new highscore created: "+highscore.usuario);
      res.send("NO");
    }

  });

});


router.get('/', function(req, res, next) {


  Highscore.find({}).limit(10).sort({'puntuacion':'desc'}).exec(function(err, hs){
    res.render('index', { highscores: hs, moment :require('moment') });
  });
});

module.exports = router;
