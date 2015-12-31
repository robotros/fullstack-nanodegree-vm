-- Database Schema for the tournament project.
-- Author: Aron Roberts
-- Version: 1.00
-- Date: 12/30/2015
-- filename: tournament.sql
--
-- Last Update: NONE

CREATE TABLE Players
( 
	player_id int AUTO_INCREMENT,
	full_name VARCHAR(255) NOT NULL,
	PRIMARY KEY(player_id)
);

CREATE TABLE Matches
(
	match_id int AUTO_INCREMENT,
	winner int,
	loser int,
	PRIMARY KEY (match_id),
	FOREIGN KEY (winner) REFERENCES Players(player_id),
	FOREIGN KEY (loser) REFERENCES Players(player_id)
);

CREATE VIEW Player_Wins AS
	SELECT winner AS player_id, COUNT(match_id) as wins from Matches
	GROUP BY winner;
	
CREATE VIEW Player_Losses AS
	SELECT loser AS player_id, COUNT(match_id) as losses from Matches
	GROUP BY loser;
	
CREATE VIEW Opponent_Wins AS
	SELECT m.winner AS player_id, SUM(w.wins) AS o_wins FROM Matches AS m INNER JOIN Player_Wins AS w on m.loser=w.player_id
	GROUP BY m.winner;

CREATE VIEW Player_Standings AS
	SELECT p.player_id, p.full_name, w.wins, (w.wins+l.losses) AS matches, o.o_wins AS opponent_wins
	FROM Players AS p 
	 INNER JOIN Player_Wins AS w ON p.player_id=w.player_id
	 INNER JOIN Player_Losses AS l ON p.player_id=l.player_id
	 INNER JOIN Opponent_Wins AS o ON p.player_id=o.player_id
	ORDER BY w.wins DESC, o.o_wins DESC;
