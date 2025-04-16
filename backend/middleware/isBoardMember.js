const Board = require('../models/Board');

module.exports = async function (req, res, next) {
  try {
    const board = await Board.findById(req.params.boardId || req.body.boardId);
    if (!board) return res.status(404).json({ message: 'Board not found' });

    const isMember = board.members.includes(req.user.id);
    if (!isMember) return res.status(403).json({ message: 'Access denied – not a board member' });

    req.board = board; // attach board to req for reuse
    next();
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};