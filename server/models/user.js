const mongoose = require("mongoose");
const userSchema = mongoose.Schema({
  username: {
    require: true,
    type: String,
    trim: true,
  },
  email: {
    require: true,
    type: String,
    trim: true,
    validate: {
      validator: (value) => {
        const emailRegexp =
          /^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$/;
        return value.match(emailRegexp);
      },
      message: "Please enter a valid email address",
    },
  },
  password: {
    require: true,
    type: String,
  },
  age: {
    require: true,
    type: Number,
  },
  gender: {
    require: true,
    type: String,
  },
  type: {
    type: String,
    default: "user",
  },
  uid: {
    type: String,
  },
  image: {
    require: true,
    type: String,
  },
});

const User = mongoose.model("User", userSchema);
module.exports = User;
