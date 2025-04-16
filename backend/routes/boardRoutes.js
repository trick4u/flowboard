const express = require('express');
const router = express.Router();
const auth = require('../middleware/auth');

const isBoardMember = require('../middleware/isBoardMember');
const isBoardOwner = require('../middleware/isBoardOwner');
const { inviteByEmail } = require('../controllers/boardController');

const { createBoard, getBoards } = require('../controllers/boardController');

router.post('/', auth, createBoard);
router.get('/', auth, getBoards);
router.post('/invite/:boardId', auth, isBoardMember, isBoardOwner, inviteByEmail);

module.exports = router;
