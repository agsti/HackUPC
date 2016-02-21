var express = require('express');
var router = express.Router();

var mongoose = require('mongoose');
var db = mongoose.connect('mongodb://localhost:/midmi');
var Highscore =  require('../model/highscore');





router.get('/top', function(req, res, next){
  Highscore.find({}).limit(5).sort({'puntuacion':'desc'}).exec(function(err, hs){
    res.json(hs);
  });
});


router.get('/', function(req, res, next) {


  Highscore.find({}).limit(10).sort({'puntuacion':'desc'}).exec(function(err, hs){
    res.render('index', { highscores: hs, moment :require('moment') });
  });
});

module.exports = router;
