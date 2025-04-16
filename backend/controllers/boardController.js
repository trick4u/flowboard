const Board = require('../models/Board');
const User = require('../models/User');

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




exports.inviteByEmail = async (req, res) => {
  const { email } = req.body;
  const board = req.board;

  try {
    const user = await User.findOne({ email });
    if (!user) return res.status(404).json({ message: 'User not found' });

    const alreadyMember = board.members.includes(user._id);
    if (alreadyMember) return res.status(400).json({ message: 'User is already a board member' });

    board.members.push(user._id);
    await board.save();

    res.status(200).json({ message: 'User invited to board' });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

