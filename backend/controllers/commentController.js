const Comment = require('../models/Comment');

exports.createComment = async (req, res) => {
  try {
    const comment = await Comment.create({ ...req.body, user: req.user.id });
    res.status(201).json(comment);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

exports.getCommentsByTask = async (req, res) => {
  try {
    const comments = await Comment.find({ task: req.params.taskId }).populate('user', 'name');
    res.status(200).json(comments);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};
