var dbConn = require('./config/dbConfig');
const puppeteer = require('puppeteer');


function run(){
  console.log("runned");
  var nftsToUpdate = [];
  dbConn.query("SELECT * FROM nfts", (err, res) => {
    if(err){
      console.log("An error occured while fetching nfts.");
      update(nftsToUpdate);
    }else{
      console.log("Nfts have been fetched.");
      if(res.length > 0){
        (async () => {
          for(let i = 0; i<res.length; i++){
            var nft = res[i];
            const browser = await puppeteer.launch();
            const page = await browser.newPage();
            console.log(nft.twitter_account);
            await page.goto(nft.twitter_account.includes("?lang=en") ? nft.twitter_account : (nft.twitter_account.split("?")[0] + "?lang=en"), {
              waitUntil: 'networkidle2',
            });
            const bodyHandle = await page.$('body');
            const html = await page.evaluate((body) => body.innerHTML, bodyHandle);

            if(html != undefined && html != null){

              var firstSpl = html.split('<span class="css-901oao css-16my406 r-18jsvk2 r-poiln3 r-b88u0q r-bcqeeo r-qvutc0"><span class="css-901oao css-16my406 r-poiln3 r-bcqeeo r-qvutc0">');

              if(firstSpl != undefined && firstSpl != null && firstSpl.length > 1){
                var follower = firstSpl[2].split('</span>')[0].split(" ")[0];
                if(follower != undefined && follower != null){
                  if(follower.includes("K")){
                    if(follower.includes(".")){
                      follower = follower.split(".")[0] + "," + follower.split(".")[1].split("K")[0] + "00";
                    }else {
                      follower = follower.split("K")[0] + ",000";
                    }
                  }
                  if(follower.includes("M")){
                    follower = follower.split("M")[0] + ",000,000";
                  }
                  follower = follower.split(",");
                  var followerStr = "";
                  follower.forEach((f) => {
                    followerStr += f;
                  });
                  var follower_count = parseInt(followerStr);
                  console.log("Follower Count: " + follower_count);

                  await browser.close();

                  nftsToUpdate.push(
                    {
                      id: nft.id,
                      follower: follower_count
                    }
                  );
                  //wait for 1 min
                  console.log("a");
                  await sleep(120000);
                  console.log("b");
                }
              }else {
                console.log(firstSpl);
              }
            }
            if(i == res.length-1){
              update(nftsToUpdate);
            }
          }
        })();
      }else {
        update(nftsToUpdate);
        console.log("There isn't any nft record.");
      }
    }
  });
}

function update(nftsToUpdate){
  if(nftsToUpdate.length > 0){
    nftsToUpdate.forEach((nft, i) => {
      dbConn.query("UPDATE nfts SET twitter_follower_count = ? WHERE id = ?", [nft.follower, nft.id], (err,res) => {
        if(err){
          console.log("An error occured while updating twitter follower count of a nft with id " + nft.id + ". ", err);
        }else {
          if(i == nftsToUpdate.length-1){
            console.log(nftsToUpdate.length + " NFT record has been updated");
            setTimeout(run, 3600000);
          }
        }
      });
    });
  }else {
    console.log("There isn't any nft to update.");
    setTimeout(run, 3600000);
  }
}

function sleep(ms) {
  return new Promise((resolve) => {
    setTimeout(resolve, ms);
  });
}

run();
