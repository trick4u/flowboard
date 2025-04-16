module.exports = function (req, res, next) {
    if (req.board.owner.toString() !== req.user.id) {
      return res.status(403).json({ message: 'Only board owner can perform this action' });
    }
    next();
  };
  