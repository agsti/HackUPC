var express = require('express');
var router = express.Router();

var mongoose = require('mongoose');
var db = mongoose.connect('mongodb://localhost:/midmi');
var Highscore =  require('../model/highscore');



var moment = require('moment');

router.get('/top', function(req, res, next){
  Highscore.find({}).limit(20).sort({'puntuacion':'desc'}).exec(function(err, hs){
    if(hs != null && err == null){

      for (var i = 0; i< hs.length; i++) {
        hs[i].fromNow = moment(hs[i].date).fromNow();
      }
      res.json(hs);
    }
    else{
      res.send();
    }
  });
});


router.post('/game', function(req, res){
  var newHighscore = new Highscore({
    nombre: req.body.name,
    puntuacion: req.body.score,
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
    res.render('index', { highscores: hs, moment : moment });
  });
});

module.exports = router;
