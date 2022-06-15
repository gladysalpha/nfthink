var dbConn = require('../config/dbConfig');
const request = require('request');

var Nft = function(user) {
  this.id = user.id;
  this.name = user.name;
  this.nft_photo = user.nft_photo;
  this.web_site = user.web_site;
  this.discord_account = user.discord_account;
  this.discord_member_count = user.discord_member_count;
  this.discord_online_member_count = user.discord_online_member_count;
  this.twitter_account = user.twitter_account;
  this.twitter_follower_count = user.twitter_follower_count;
  this.point = user.point;
  this.created_at = user.created_at;
  this.updated_at = user.updated_at;
  this.symbol = user.symbol;
  this.verified = user.verified;
  this.collection_size = user.collection_size;
  this.mint_price = user.mint_price;
  this.markets_to_list = user.markets_to_list;
};


Nft.getAll = (searchKey, deviceId, result) => {
  var queryString = "SELECT nfts.*, mainpage.device_id FROM nfts LEFT JOIN mainpage ON mainpage.device_id = ? AND mainpage.nft_id = nfts.id WHERE nfts.verified = 1";
  if(searchKey != ""){
    queryString += " AND nfts.name LIKE '%" + searchKey + "%'";
  }
  queryString += " ORDER BY nfts.point DESC";
  dbConn.query(queryString, deviceId, (err, res) => {
    if (err) {
      console.log("Error occured while fetching nfts. => Nft Model", err);
      result(null, err);
    } else {
      var nfts = [];
      res.forEach((nft) => {
        if(nft.device_id == null || nft.device_id == undefined){
          if(nft.point == -1){
            nft.point = 0;
          }else {
            nft.point = nft.point/10;
          }
          nfts.push(nft);
        }
      });
      console.log("Nfts fetched successfully.");
      result(null,{
        status: 200,
        success: true,
        nfts: nfts
      });
    }
  });
};

Nft.getAllWithKeywords = (result) => {
  Nft.getAll("", -1, (err,nfts) => {
    if(err){
      console.log("Error occured while fetching nfts with keywords. => Nft Model", err);
      result(null, err);
    }else {
      var nftIds = [-1];
      nfts.nfts.forEach((n) => {
        n.keywords = [];
        nftIds.push(n.id);
      });
      dbConn.query("SELECT * FROM scrapped_words WHERE nft_id IN ?", [[nftIds]], (err, keywordDatas) => {
        if(err){
          console.log("Error occured while fetching nfts with keywords. => Nft Model", err);
          result(null, err);
        }else {
          keywordDatas.forEach((keyword) => {
            nfts.nfts.find( ({ id }) => id == keyword.nft_id).keywords.push({word: keyword.word, count: keyword.count});
          });
          result(null,nfts.nfts);
        }
      });
    }
  });
};

Nft.getAllByDeviceId = (device_id, result) => {
  dbConn.query("SELECT nfts.*, nfts.point/10 as point FROM mainpage LEFT JOIN nfts ON mainpage.nft_id = nfts.id WHERE mainpage.device_id = ? and nfts.verified = 1 ORDER BY nfts.point DESC", device_id, (err, res) => {
    if (err) {
      console.log("Error occured while fetching nfts by device id. => Nft Model", err);
      result(null, err);
    } else {
      console.log("Nfts fetched successfully by device id.");
      result(null,{
        status: 200,
        success: true,
        nfts: res
      });
    }
  });
};

Nft.addNftToMainPage = (device_id, nft_id, result) => {
  dbConn.query("INSERT INTO mainpage (device_id, nft_id) VALUES (?, ?)", [device_id, nft_id], (err, res) => {
    if (err) {
      console.log("Error occured while adding nft to mainpage of a user. => Nft Model", err);
      result(null, err);
    } else {
      console.log("Nfts added successfully to a user's mainpage.");
      result(null,{
        status: 200,
        success: true
      });
    }
  });
};

Nft.getDetailedInfo = (nft_id, result) => {
  dbConn.query("SELECT * FROM nfts WHERE id = ?", nft_id, (err, res) => {
    if (err) {
      console.log("Error occured while fetching nft's detailed info. => Nft Model", err);
      result(null, err);
    } else {
      request('https://api-mainnet.magiceden.dev/v2/collections/' + res[0].symbol, function (err, meRes, body) {
        if(err){
          console.log("Error occured while fetching nft's detailed info. => Nft Model", err);
          result(null, err);
        }else {
          console.log("Nft's detailed info fetched successfully.");
          body = JSON.parse(body);
          res[0].floor_price = body.floorPrice/1000000000;
          res[0].listed_count = body.listedCount;
          res[0].average_price_24h = body.avgPrice24hr/1000000000;
          res[0].volume_all = body.volumeAll/1000000000;
          if(res[0].point == -1){
            res[0].point = 0;
          }else {
            res[0].point = res[0].point/10;
          }
          result(null,{
            status: 200,
            success: true,
            nft: res[0]
          });
        }
      });
    }
  });
};

Nft.calculatePoints = (result) => {
  Nft.getAllWithKeywords((err,res) => {
    if(err){
      console.log("Error occured while fetching nfts to calculate points. => Nft Model", err);
      result(null, err);
    }else {
      var queries = "";
      res.forEach((nft) => {
        var point = Nft.calculatePointForAnNft(nft);
        queries += "UPDATE nfts SET point = " + point + " WHERE id = " + nft.id + ";";
      });

      dbConn.query(queries, (err, res) => {
        if(err){
          console.log("Error occured while saving calculated points. => Nft Model", err);
          result(null, err);
        }else {
          console.log("All nft points calculated and saved");
          result(null,{
            status: 200,
            success: true
          })
        }
      });
    }
  });
};

Nft.calculatePointForAnNft = (nft) => {
  var point = 0;
  //twitter criterias
  if(nft.twitter_follower_count == -1){
    return 0;
  }else {
    var twitPoint = nft.twitter_follower_count / 1000;
    if(twitPoint > 10){
      twitPoint = 10;
    }
    point += twitPoint;
  }

  //discord criterias
  if(nft.discord_member_count == -1 || nft.discord_online_member_count == -1){
    return 0;
  }else {
    var discordPoint = nft.discord_member_count / 500;
    if(discordPoint > 10){
      discordPoint = 10;
    }
    point += discordPoint;

    discordPoint = nft.discord_online_member_count / 100;
    if(discordPoint > 15){
      discordPoint = 15;
    }
    point += discordPoint;
  }

  //collection_size criterias
  var s = nft.collection_size;
  var sizePoint;
  if(s < 1000){
    sizePoint = 0;
  }else if (s < 3000){
    sizePoint = 5;
  }else if (s < 5000){
    sizePoint = 10;
  }else if (s < 7000){
    sizePoint = 5;
  }else {
    sizePoint = 0;
  }
  point += sizePoint;

  //mint_price
  var mp = nft.mint_price;
  var mintPoint;
  if(mp < 0.5){
    mintPoint = 0;
  }else if(mp < 0.99){
    mintPoint = 5;
  }else if(mp < 2.01){
    mintPoint = 10;
  }else if(mp < 4.01){
    mintPoint = 5;
  }else {
    mintPoint = 0;
  }

  point += mintPoint;

  //market list
  var mtl = nft.markets_to_list;
  var mtlPoint = mtl * 3;
  if(mtlPoint > 15){
    mtlPoint = 15;
  }
  if(mtlPoint < 0){
    mtlPoint = 0;
  }
  point += mtlPoint;

  //keyword scrapping
  var keywordPoint = 0;
  nft.keywords.forEach((keyword) => {
    switch(keyword.word.toLowerCase()){
      case 'metaverse':
        keywordPoint += (keyword.count*5);
        break;
      case 'roadmap':
        keywordPoint += (keyword.count*8);
        break;
      case 'airdrop':
        keywordPoint += (keyword.count*-5);
        break;
      case 'loyalty':
        keywordPoint += (keyword.count*5);
        break;
      case 'game':
        keywordPoint += (keyword.count*5);
        break;
      case 'p2e':
        keywordPoint += (keyword.count*5);
        break;
      case 'play_to_earn':
        keywordPoint += (keyword.count*5);
        break;
      case 'stake':
        keywordPoint += (keyword.count*8);
        break;
      case 'staking':
        keywordPoint += (keyword.count*8);
        break;
      case 'rarity':
        keywordPoint += (keyword.count*5);
        break;
    }
  });
  if(keywordPoint > 30){
    keywordPoint = 30;
  }
  point += keywordPoint;

  return point;
};

module.exports = Nft;
