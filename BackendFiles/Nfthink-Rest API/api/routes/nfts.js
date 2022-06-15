const express = require('express');
const router = express.Router();
const nftController = require('../controllers/nftController');

router.post('/getAll', nftController.getAll);
router.get('/getAllByDeviceId', nftController.getAllByDeviceId);
router.get('/getDetailedInfo', nftController.getDetailedInfo);
router.post('/addNftToMainPage', nftController.addNftToMainPage);
router.patch('/calculatePoints', nftController.calculatePoints)

module.exports = router;
