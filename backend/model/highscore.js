var mongoose = require('mongoose');
var Schema = mongoose.Schema;

var HighscoreSchema = Schema({
	nombre: {type: String, required: true },
	puntuacion: {type: Number, required: true},
	date:{type:Date}

});


module.exports = mongoose.model('HighscoreSchema', HighscoreSchema);
