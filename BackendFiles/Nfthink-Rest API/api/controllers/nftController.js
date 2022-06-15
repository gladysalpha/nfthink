const Nft = require('../models/nft');

exports.getAll = (req, res, next) => {
  if (req.body.contructor === Object && Object.keys(req.body).length === 0) {
    res.status(400).json({
      status: 400,
      success: false,
      message: "Not a valid data"
    });
  } else {
    Nft.getAll(req.body.searchKey, req.body.deviceId, (err, result) => {
      if (err) {
        res.status(500).send(err);
      }else {
        res.status(result.status).send(result);
      }
    });
  }
};

exports.getAllByDeviceId = (req, res, next) => {
  Nft.getAllByDeviceId(req.query.deviceId, (err, result) => {
    if (err) {
      res.status(500).send(err);
    }else {
      res.status(result.status).send(result);
    }
  });
};

exports.addNftToMainPage = (req, res, next) => {
  Nft.addNftToMainPage(req.query.deviceId, req.query.nftId, (err, result) => {
    if (err) {
      res.status(500).send(err);
    }else {
      res.status(result.status).send(result);
    }
  });
};

exports.getDetailedInfo = (req, res, next) => {
  Nft.getDetailedInfo(req.query.nftId, (err, result) => {
    if (err) {
      res.status(500).send(err);
    }else {
      res.status(result.status).send(result);
    }
  });
};

exports.calculatePoints = (req, res, next) => {
  Nft.calculatePoints((err, result) => {
    if (err) {
      res.status(500).send(err);
    }else {
      res.status(result.status).send(result);
    }
  });
};
