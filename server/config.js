const firebase = require("firebase");

const firebaseConfig = {
  apiKey: "AIzaSyC4caWFTy1edXINHUcl36FJgi_MTLyB9-M",

  authDomain: "iplexgram.firebaseapp.com",

  projectId: "iplexgram",
  storageBucket: "iplexgram.appspot.com",
  messagingSenderId: "450481081257",
  appId: "1:450481081257:web:ceb171499821c2aa6112b8",

  measurementId: "G-GG87KC0YWW",
};

firebase.initializeApp(firebaseConfig);
const db = firebase.firestore();
const User = db.collection("users");
module.exports = User;
// firebase.initializeApp(firebaseConfig);
// const db = firebase.firestore();
// const User = db.collection("users");

// module.export = User;
