const express = require("express");
const User = require("../models/user");
const Store = require("../models/store");
const bcryptjs = require("bcryptjs");
const authRouter = express.Router();
const jwt = require("jsonwebtoken");
const auth = require("../middleware/auth");
const crypto = require("crypto");

authRouter.get("/api/postStore", async (req, res) => {
  try {
    const data = await Store.find().exec();
    res.status(200).json(data);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

authRouter.put("/api/likeStore", async (req, res) => {
  try {
    const { string_name, uid } = req.body;
    const store = await Store.findOne({ string_name: string_name });
    if (!store) {
      return res.status(404).json({ error: "Store not found" });
    }
    const existingUser = store.likes.find((like) => like === uid);
    if (existingUser) {
      store.likes.pull(uid);
      const updatedStore = await store.save();
      return res.status(200).json(updatedStore);
    }
    store.likes.push(uid);
    const updatedStore = await store.save();
    res.status(200).json(updatedStore);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

authRouter.post("/api/postStore", async (req, res) => {
  try {
    const {
      string_name,
      rating,
      count_rating,
      price,
      open_daily,
      address,
      contact,
      facebook,
      type,
      map,
    } = req.body;
    const existringStore = await Store.findOne({ string_name });
    if (existringStore) {
      return res
        .status(400)
        .json({ msg: "Store with same name already exists!" });
    }
    let store = new Store({
      string_name,
      rating,
      count_rating,
      price,
      open_daily,
      address,
      contact,
      facebook,
      type,
      map,
    });
    store = await store.save();
    res.json(store);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

// SIGNUP
authRouter.post("/api/signup", async (req, res) => {
  try {
    const { username, email, password, age, gender, image } = req.body;
    const existringUser = await User.findOne({ email });
    if (existringUser) {
      return res
        .status(400)
        .json({ msg: "User with same email already exists!" });
    }
    const hashedPassword = await bcryptjs.hash(password, 8);
    const uID = await crypto.randomUUID();
    let user = new User({
      username,
      email,
      password: hashedPassword,
      age,
      gender,
      uid: uID,
      image,
    });
    user = await user.save();
    res.json(user);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});
// SIGNIN
authRouter.post("/api/signin", async (req, res) => {
  try {
    const { email, password } = req.body;
    const user = await User.findOne({ email });
    if (!user) {
      return res
        .status(400)
        .json({ msg: "User with this email does not exists!" });
    }
    const isMatch = await bcryptjs.compare(password, user.password);
    if (!isMatch) {
      return res.status(401).json({ msg: "incorrect password!" });
    }
    const token = jwt.sign({ id: user._id }, "passwordKey");
    res.json({ token, ...user._doc });
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});
//TOKEN VALID
authRouter.post("/tokenIsValid", async (req, res) => {
  try {
    const token = req.header("x-auth-token");
    if (!token) return res.json(false);
    const verified = jwt.verify(token, "passwordKey");
    if (!verified) return res.json(false);

    const user = await User.findById(verified.id);
    if (!user) return res.json(false);
    res.json(true);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});
//GET USER DATA
authRouter.get("/", auth, async (req, res) => {
  const user = await User.findById(req.user);
  res.json({ ...user._doc, token: req.token });
});

module.exports = authRouter;
