var dbConn = require('./config/dbConfig');
const request = require('request');

function getDatasFirstTime(){
  request('https://api-mainnet.magiceden.dev/v2/collections', function (err, res, body) {
    if(err){
      console.log("An error occured while fetching collection datas from magic eden", err);
    }else {
      if(res && res.statusCode == 200){
        var values = JSON.parse(body);
        console.log(values.length + " nfts fetched from magic eden");
        var nftsToInsert = []
        values.forEach((nft) => {
          var isValid = true;
          var n = [
            nft.name,
            nft.image,
            nft.website,
            nft.discord,
            nft.twitter,
            nft.symbol
          ];
          n.forEach((s) => {
            if(s == undefined || s == null || s == ""){
              isValid = false;
            }
          });
          if(isValid){
            nftsToInsert.push(n);
          }
        });
        dbConn.query("INSERT INTO nfts (name, nft_photo, web_site, discord_account, twitter_account, symbol) VALUES ?", [nftsToInsert], (err, res) => {
          if(err){
            console.log("An error occured while inserting collection datas from magic eden to database", err);
          }else {
            console.log(res.affectedRows + " nfts added to database");
          }
        });
      }else {
        if(res){
          console.log('Something went wrong with statusCode:', res && res.statusCode); // Print the response status code if a response was received
        }else {
          console.log('There is no response from Magic Eden');
        }
      }
    }
  });
}


getDatasFirstTime();
