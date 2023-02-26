const mongoose = require("mongoose");
const notificationSchema = mongoose.Schema({
  email: {
    require: true,
    type: String,
  },
  title: {
    require: true,
    type: String,
  },
  own_email: {
    require: true,
    type: String,
  },
});

const Notification = mongoose.model("Notification", notificationSchema);
module.exports = Notification;
