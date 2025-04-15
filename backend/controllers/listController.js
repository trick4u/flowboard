const List = require('../models/List');

exports.createList = async (req, res) => {
  try {
    const list = await List.create(req.body);
    res.status(201).json(list);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

exports.getListsByBoard = async (req, res) => {
  try {
    const lists = await List.find({ board: req.params.boardId });
    res.status(200).json(lists);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};
