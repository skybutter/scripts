-- **********************************************
-- Logging 
-- **********************************************
create database logging;

CREATE TABLE IF NOT EXISTS cs_logs
(
   requestId bigint NOT NULL,
   dateTime timestamp NOT NULL,
   csElapsed int NOT NULL,
   saveElapsed int NOT NULL,
   user varchar(30) NOT NULL,
   location varchar(12) NOT NULL,
   allocations int NOT NULL,
   ticket varchar(50) NOT NULL,
   tradeIds JSON NOT NULL,
   PRIMARY KEY (requestId)
);

select * from cs_logs;

INSERT INTO cs_logs (requestId,dateTime,csElapsed,saveElapsed,user,location,allocations,ticket,tradeIds)
    VALUES (100000,'2017-02-15 13:00:00',60000,1000,'awong','China',4,'My Ticket Ticket Type','[1010,1009]');

delete from cs_logs 
-- ******************************************************************************************
CREATE TABLE IF NOT EXISTS posting
(
   eventId bigint NOT NULL,
   ticketId bigint NOT NULL,
   dateTime timestamp NOT NULL,
   elapsed int NOT NULL,
   instrumentId varchar(20) NOT NULL,
   numOfAllocations int NOT NULL,
   importId int NULL,
   category varchar(50) NOT NULL,
   csElapsed int NOT NULL default 0,
   username varchar(30) NOT NULL,
   locationId int NOT NULL,
   PRIMARY KEY (eventId)
);

select * from posting;
delete from posting;

INSERT INTO posting (eventId,ticketId,dateTime,elapsed,instrumentId,numOfAllocations,importId,category,csElapsed,username,locationId) VALUES 
(12345002,1002,'2017-02-16 14:02:00',62,'346728EA7',6,122,'My Category',62000,'awong',102);
