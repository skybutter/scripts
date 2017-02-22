// Node server for logging events into Database (MongoDB and MemSQL)
// Alan Wong - Feb 22, 2017
var restify = require('restify');
var server = restify.createServer({name: "logger"});
// moment js is for formating Date/Time
var moment = require('moment');
// ****************************************
// For MongoDB
// ****************************************
var mongoskin = require('mongoskin');
var db = mongoskin.db('mongodb://localhost:27017/logging', {safe:false});

// ****************************************
// For MemSQL - using mysql driver
// ****************************************
var mysql = require('mysql');
var pool = mysql.createPool({
    connectionLimit : 10,
    host : "memsqld01",
    port : 3306,
    user : "root",
    database : "logging"
});

// posting event
server.get('/posting/event/insert/:elapsed/:ticketId/:allocs/:instrumentId/:date/:time/:category/:csElapsed/:username/:locationId/:eventId/:importId', function (request, response, next) {
    var dt = moment(request.params.date + ' ' + request.params.time, 'MM-DD-YY hh:mm:ss');
    var allocs = parseInt(request.params.allocs);
    if (isNaN(allocs)) {
        allocs = 0;
    }
    var doc = { 
            ticketId: parseInt(request.params.ticketId),
            dateTime: dt.toISOString(),
            elapsed: parseInt(request.params.elapsed),
            instrumentId: request.params.instrumentId,
            allocs: allocs,
            category: request.params.category,
            csElapsed: parseInt(request.params.csElapsed),
            username: request.params.username,
            locationId: request.params.locationId,
            eventId: request.params.eventId,
    };
    if (request.params.importId !== 'null') {
      doc.importId = request.params.importId;
    }
    console.log(doc);
    
    // ******************************************************************
    // ** For adding records into MongoDB
    // ******************************************************************
    db.collection('posting').insert(doc, function (err, docs) {
        if (err) {
            console.log("== ERROR == inserting record");
            console.log(err);
            console.log(docs);
        } else {
            console.log("Complete inserting record.");
        }
    });
    
    // ******************************************************************
    // ** For adding records into MemSQL
    // ******************************************************************
    var sqlFields = '(eventId,ticketId,dateTime,elapsed,instrumentId,numOfAllocations,importId,category,csElapsed,username,locationId)';
    var sqlinsert = 'INSERT INTO posting ' + sqlFields + ' VALUES (?,?,?,?,?,?,?,?,?,?,?,?)';
    console.log(sqlinsert);
    var dateStr = moment(dt).format('YYYY-MM-DD HH:mm:ss');
    var paramValues = [doc.eventId,doc.ticketId,dateStr,doc.elapsed,doc.instrumentId,doc.allocs,doc.importId,doc.category,doc.csElapsed,doc.username, doc.locationId];
    //console.log('param Values=' + paramValues);
    pool.getConnection(function(err, connection) {
        connection.query(sqlinsert, paramValues, function(err) {
            if (err) {
                console.log(err);
                response.json({success: false});
            } else {
                console.log("success");
                response.json({success: true});
            }
        });
        connection.release();
    });
    return next();
});

// CS perf stat event
server.get('/cs/event/insert/:csElapsed/:saveElapsed/:requestId/:user/:tradeIds/:allocations/:location/:date/:time/:tickets', function (request, response, next) {
    console.log("== cs event request ==");
    console.log(request.params);
    var dt = moment(request.params.date + ' ' + request.params.time, 'MM-DD-YY hh:mm:ss');
    //console.log(dt.toISOString());
    var allocations = parseInt(request.params.allocations);
    if (isNaN(allocations)) {
        allocations = 0;
    }
    var tradeIds = request.params.tradeIds.split(",");
    for (var x=0; x<tradeIds.length; x++) { tradeIds[x] = parseInt(tradeIds[x], 10); }
    
    var doc = { 
            requestId: parseInt(request.params.requestId),
            dateTime: dt.toISOString(),
            csElapsed: parseInt(request.params.csElapsed),
            saveElapsed: parseInt(request.params.saveElapsed),
            user: request.params.user,
            tradeIds: tradeIds,
            location: request.params.location,
            allocations: allocations,
            tickets: request.params.tickets.split(","),
        };
    console.log(doc);
    
    // ******************************************************************
    // ** For adding records into MongoDB
    // ******************************************************************
    db.collection('cs').insert(doc, function (err, docs) {
        if (err) {
            console.log("== ERROR inserting cs record ==");
            console.log(err);
            console.log(docs);
        } else {
            console.log("Complete inserting cs record");
        }
    });

    // ******************************************************************
    // ** For adding records into MemSQL
    // ******************************************************************
    var sqlFields = '(requestId,dateTime,csElapsed,saveElapsed,user,location,allocations,ticket,tradeIds)';
    var sqlinsert = 'INSERT INTO cs_logs ' + sqlFields + ' VALUES (?,?,?,?,?,?,?,?,?)';
    console.log(sqlinsert);
    var dateStr = moment(dt).format('YYYY-MM-DD HH:mm:ss');
    // formatting trade ids into a JSON array
    var trades = '[' + tradeIds + ']';
    console.log('trades=' + trades);
    var paramValues = [doc.requestId, dateStr, doc.csElapsed, doc.saveElapsed, doc.user, doc.location, doc.allocations, doc.tickets, trades];
    console.log('param Values=' + paramValues);
    pool.getConnection(function(err, connection) {
        connection.query(sqlinsert, paramValues, function(err) {
            if (err) {
                console.log(err);
                response.json({success: false});
            } else {
                console.log("success");
                response.json({success: true});
            }
        });
        connection.release();
    });
    return next();
});

server.listen(3200, function() {
    console.log('%s listening at %s', server.name, server.url);
});
