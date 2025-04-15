const Task = require('../models/Task');

exports.createTask = async (req, res) => {
  try {
    const task = await Task.create(req.body);
    res.status(201).json(task);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

exports.getTasksByList = async (req, res) => {
  try {
    const tasks = await Task.find({ list: req.params.listId });
    res.status(200).json(tasks);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};
