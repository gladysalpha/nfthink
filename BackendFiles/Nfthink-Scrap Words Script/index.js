var dbConn = require('./config/dbConfig');
const {spawn} = require('child_process');


function run(){
  console.log("runned");
  var nftsToUpdate = [];
  dbConn.query("SELECT * FROM nfts", (err, res) => {
    if(err){
      console.log("An error occured while fetching nfts.", err);
    }else{
      console.log("Nfts have been fetched.");
      if(res.length > 0){
        read(res, 0);
      }else {
        console.log("There isn't any nft record on db.");
        const python = spawn("python", ["script2.py","https://www.roguesharks.org/"]);

      }
    }
  });
}

function read(nfts, index){
  if(index == nfts.length){
    run();
  }else {
    var dataToSend;
    const python = spawn("python", ["main.py", nfts[index].web_site]);

    python.stdout.on('data', function (data) {
      dataToSend = data.toString();
    });

    python.on('close', (code) => {
      if(dataToSend != null && dataToSend != undefined){
        var data = JSON.parse(dataToSend.replace("play to earn","play_to_earn").replaceAll("'",'"'));
        if(data != null && data != undefined){
          dbConn.query("DELETE FROM scrapped_words WHERE nft_id = ?", nfts[index].id, (err, res) => {
            if(err){
              console.log("An error occured while deleting nft's scrapped words", err);
              read(nfts, index+1)
            }else {
              var keywordsToInsert = [];
              for (const [key, value] of Object.entries(data)) {
                if(value > 0){
                  keywordsToInsert.push([key,value,nfts[index].id]);
                }
              }
              if(keywordsToInsert.length > 0){
                dbConn.query("INSERT INTO scrapped_words (word, count, nft_id) VALUES ?",[keywordsToInsert], (err, res) => {
                  if(err){
                    console.log("An error occured while inserting nft's scrapped words", err);
                    read(nfts, index+1)
                  }else {
                    console.log("Nft inserted");
                    read(nfts, index+1)
                  }
                });
              }else{
                console.log("There is no words to insert");
                read(nfts, index+1)
              }
            }
          });
        }else {
          console.log("data is undefined or null");
          read(nfts, index+1)
        }
      }else{
        console.log("dataToSend is undefined or null");
        read(nfts, index+1)
      }
    });
  }
}

run();
