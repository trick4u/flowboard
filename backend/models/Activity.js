const mongoose = require('mongoose');

const activitySchema = new mongoose.Schema({
  user: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true },
  board: { type: mongoose.Schema.Types.ObjectId, ref: 'Board', required: true },
  message: { type: String, required: true },
}, { timestamps: true });

module.exports = mongoose.model('Activity', activitySchema);
