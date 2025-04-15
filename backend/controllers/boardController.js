const Board = require('../models/Board');

exports.createBoard = async (req, res) => {
  try {
    const board = await Board.create({ ...req.body, owner: req.user.id });
    res.status(201).json(board);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

exports.getBoards = async (req, res) => {
  try {
    const boards = await Board.find({ owner: req.user.id });
    res.status(200).json(boards);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};
