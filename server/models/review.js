const mongoose = require("mongoose");
const reviewSchema = mongoose.Schema({
  uid: {
    require: true,
    type: String,
  },
  email: {
    require: true,
    type: String,
  },
  storename: {
    require: true,
    type: String,
  },
  message: {
    require: true,
    type: String,
  },
  rating: {
    require: true,
    type: String,
  },
  image: {
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

const Review = mongoose.model("Review", reviewSchema);
module.exports = Review;
