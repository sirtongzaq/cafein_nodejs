const express = require("express");
const mongoose = require("mongoose");
const DB =
  "mongodb+srv://sirtongzaq:JwjAWyp4vnmOBkXV@cluster0.qnbwdyz.mongodb.net/?retryWrites=true&w=majority";
// IMPORT FROM ANOTHER FILE
const authRouter = require("./routes/auth");
// INIT
const PORT = 3000;
const app = express();
// MIDDLEWARE CLIENT => MIDDLEWARE => SERVER
app.use(express.json());
app.use(authRouter);
// CONNECTIONS
mongoose
  .connect(DB)
  .then(() => {
    console.log("Connection Successful");
  })
  .catch((e) => {
    console.log(e);
  });
app.listen(PORT, "0.0.0.0", () => {
  console.log(`Connected an port ${PORT}`);
});
