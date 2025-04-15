const Activity = require('../models/Activity');

exports.getActivitiesByBoard = async (req, res) => {
  try {
    const logs = await Activity.find({ board: req.params.boardId }).sort({ createdAt: -1 });
    res.status(200).json(logs);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

// Utility function to log activity
exports.logActivity = async (userId, boardId, message) => {
  await Activity.create({ user: userId, board: boardId, message });
};
