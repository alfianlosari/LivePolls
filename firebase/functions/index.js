const fs = require('fs');
const jwt = require('jsonwebtoken');
const http2 = require('node:http2');

const { initializeApp } = require('firebase-admin/app');
const { onDocumentUpdated } = require("firebase-functions/v2/firestore");
const { getFirestore } = require('firebase-admin/firestore');

const teamID = "YOUR_APPLE_TEAM_ID";
const keyID = "YOUR_KEY_ID";
const p8FilePath = `./AuthKey_${keyID}.p8`;
const bundleID = "YOUR_BUNDLE_ID"

initializeApp();
const db = getFirestore();

exports.myFunction = onDocumentUpdated("polls/{pollId}", async (event) => {
    const pollId = event.params.pollId;
    const updatedPoll = event.data.after.data();

    console.log(updatedPoll);
    const tokensQuerySnapshot = await db.collection(`polls/${pollId}/push_tokens`).get();
    let tokens = [];

    tokensQuerySnapshot.forEach((doc) => {
        tokens.push(doc.data().token);
    });
    console.log(`tokens: ${tokens.length}`)
    if (tokens.length == 0) return;
    const date = new Date();
    const unixTimestamp = Math.floor(date.getTime() / 1000);

    const json = {
        "aps": {
            "timestamp": unixTimestamp,
            "event": "update",
            "relevance-score": 100.0,
            "stale-date": unixTimestamp + (60 * 60 * 8),
            "content-state": {
                ...updatedPoll,
                createdAt: null,
                updatedAt: {
                    seconds: updatedPoll.updatedAt.seconds,
                    nanoseconds: updatedPoll.updatedAt.nanoseconds
                }
            }
        }
    }
    publishToApns(tokens, json);
});

function publishToApns(tokens, json) {
    console.log(`Tokens to push: ${tokens}, payload: ${JSON.stringify(json)}`);
    
    const privateKey = fs.readFileSync(p8FilePath);
    const secondsSinceEpoch = Math.round(Date.now() / 1000);
    const payload = {
        iss: teamID,
        iat: secondsSinceEpoch
    };

    const session = http2.connect('https://api.sandbox.push.apple.com:443');
    session.on('error', (err) => {
        console.log("Session Error", err);
    })
    
    const finalEncryptToken = jwt.sign(payload, privateKey, {algorithm: 'ES256', keyid: keyID});
    for (token of tokens) {
        try {
            var buffer = new Buffer.from(JSON.stringify(json));
    
            const req = session.request(
                {
                    ":method": "POST",
                    ":path": "/3/device/" + token,
                    "authorization": "bearer " + finalEncryptToken,
                    "apns-push-type": "liveactivity",
                    "apns-topic": `${bundleID}.push-type.liveactivity`,
                    "Content-Type": 'application/json',
                    "Content-Length": buffer.length,
                }
            );
    
            req.on('response', (headers) => {
                console.log(headers[http2.constants.HTTP2_HEADER_STATUS]);
            });
    
            let data = '';
            req.setEncoding('utf8');
            req.on('data', (chunk) => data += chunk);
            
            req.on('end', () => {
                console.log(`The server says: ${data}`);
                session.close();
            });
            req.end(JSON.stringify(json));
        } catch (err) {
            console.error("Error sending token:", err);
        }
    }    
}