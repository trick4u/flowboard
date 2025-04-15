const express = require('express');
const router = express.Router();
const auth = require('../middleware/auth');
const { getActivitiesByBoard } = require('../controllers/activityController');

router.get('/:boardId', auth, getActivitiesByBoard);

module.exports = router;
