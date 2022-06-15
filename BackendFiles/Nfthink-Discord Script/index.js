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
            console.log(nft.discord_account);
            await page.goto(nft.discord_account, {
              waitUntil: 'networkidle2',
            });
            const bodyHandle = await page.$('body');
            const html = await page.evaluate((body) => body.innerHTML, bodyHandle);

            if(html != undefined && html != null){

              var firstSpl = html.split('<span class="defaultColor-24IHKz text-sm-normal-3Zj3Iv pillMessage-3pHz6R" data-text-variant="text-sm/normal">');

              if(firstSpl != undefined && firstSpl != null && firstSpl.length > 2){
                var online = firstSpl[1].split('</span>')[0].split(" ")[0];
                var members = firstSpl[2].split('</span>')[0].split(" ")[0];
                if(online != undefined && online != null && members != undefined && members != null){

                  online = online.split(".");
                  members = members.split(".");
                  var onlineStr = "";
                  var membersStr = "";
                  online.forEach((o) => {
                    onlineStr += o;
                  });
                  members.forEach((m) => {
                    membersStr += m;
                  });

                  var online_count = parseInt(onlineStr);
                  var member_count = parseInt(membersStr);
                  console.log("Online Count: " + online_count);
                  console.log("Member Count: " + member_count);

                  await browser.close();

                  nftsToUpdate.push(
                    {
                      id: nft.id,
                      online: online_count,
                      member: member_count
                    }
                  );
                  //wait for 5 min
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
      dbConn.query("UPDATE nfts SET discord_member_count = ?, discord_online_member_count = ? WHERE id = ?", [nft.member, nft.online, nft.id], (err,res) => {
        if(err){
          console.log("An error occured while updating discord member counts of a nft with id " + nft.id + ". ", err);
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
