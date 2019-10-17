/**
 * Created by Syed Afzal
 */
const mongoose = require('mongoose');
const {log} = require('../utils/helpers/logger');

exports.connect = () => {
    mongoose.Promise = global.Promise;
    mongoose.connect(process.env.MONGODB_URI, { useNewUrlParser: true });
    const db = mongoose.connection;
    db.on('error', console.error.bind(console, 'connection error:'));

    db.once('open', () => {
        log.info(`MongoDB connected on ${process.env.MONGODB_URI}`);
    });
};
