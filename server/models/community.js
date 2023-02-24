const mongoose = require("mongoose");
const communitySchema = mongoose.Schema({
  uid: {
    require: true,
    type: String,
  },
  email: {
    require: true,
    type: String,
  },
  title: {
    require: true,
    type: String,
  },
  message: {
    require: true,
    type: String,
  },
  image: {
    require: true,
    type: String,
  },
  type: {
    require: true,
    type: String,
  },
  date: {
    require: true,
    type: String,
  },
  likes: {
    type: Array,
    default: null,
  },
});

const Community = mongoose.model("Community", communitySchema);
module.exports = Community;
