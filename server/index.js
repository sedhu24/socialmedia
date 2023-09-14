const express = require("express");
const User = require("./config");
const cors = require("cors");
const app = express();

app.use(express.json());
app.use(cors());

app.post("./create", async (req, res) => {
  const data = req.body;
  await User.add(data);
  res.send({ msg: "User Added" });
});

app.listen(4000, () => console.log("Running on 3000"));
