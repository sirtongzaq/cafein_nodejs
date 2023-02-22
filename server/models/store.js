const mongoose = require("mongoose");
const storeSchema = mongoose.Schema({
  string_name: {
    require: true,
    type: String,
  },
  rating: {
    require: true,
    type: String,
  },
  count_rating: {
    require: true,
    type: String,
  },
  price: {
    require: true,
    type: String,
  },
  open_daily: {
    require: true,
    type: String,
  },
  address: {
    require: true,
    type: String,
  },
  contact: {
    require: true,
    type: String,
  },
  facebook: {
    require: true,
    type: String,
  },
  type: {
    require: true,
    type: Array,
  },
  likes: {
    type: Array,
    default: null,
  },
  views: {
    type: Number,
    default: 0,
  },
  map: {
    require: true,
    type: Array,
  },
});

const Store = mongoose.model("Store", storeSchema);
module.exports = Store;
