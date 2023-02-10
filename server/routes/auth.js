const express = require("express");
const User = require("../models/user");
const bcryptjs = require("bcryptjs");
const authRouter = express.Router();
// SIGNUP
authRouter.post("/api/signup", async (req, res) => {
  try {
    const { username, email, password } = req.body;
    const existringUser = await User.findOne({ email });
    if (existringUser) {
      return res
        .status(400)
        .json({ msg: "User with same email already exists!" });
    }
    const hashedPassword = await bcryptjs.hash(password, 8);
    let user = new User({
      username,
      email,
      password: hashedPassword,
    });
    user = await user.save();
    res.json(user);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

module.exports = authRouter;
