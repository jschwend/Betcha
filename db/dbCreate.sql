drop database if exists betcha_development;
create database betcha_development;
use betcha_development;

DROP TABLE IF EXISTS wagers;
DROP TABLE IF EXISTS acounts;
DROP TABLE IF EXISTS game_lines;
DROP TABLE IF EXISTS sportsbooks;
DROP TABLE IF EXISTS ranks;
DROP TABLE IF EXISTS games;
DROP TABLE IF EXISTS teams;
DROP TABLE IF EXISTS conferences;

CREATE TABLE conferences (
    conference_id  int          NOT NULL auto_increment,
    conference_nm  varchar(30)  NOT NULL,
    PRIMARY KEY    (conference_id))
    ENGINE=InnoDB  DEFAULT CHARSET=latin1;
CREATE TABLE teams (
    team_id        int          NOT NULL auto_increment,
    school_nm      varchar(30)  NOT NULL, 
    team_nm        varchar(30)  NOT NULL, 
    abbreviation   varchar(6)   NOT NULL, 
    conference_id  int          NULL, 
    PRIMARY KEY    (team_id),
    FOREIGN KEY    (conference_id)    REFERENCES conferences (conference_id) ON DELETE RESTRICT ON UPDATE RESTRICT)
    ENGINE=InnoDB  DEFAULT CHARSET=latin1;
CREATE TABLE games (
    game_id        int          NOT NULL auto_increment,
	season         int          NOT NULL,
	wk             int          NOT NULL,
    away_team_id   int	 		NOT NULL,
    home_team_id   int	 		NOT NULL,
    away_score     int	 		NULL,
    home_score 	   int	 		NULL,
    PRIMARY KEY    (game_id),
    FOREIGN KEY    (away_team_id)    REFERENCES teams (team_id) ON DELETE RESTRICT ON UPDATE RESTRICT,
    FOREIGN KEY    (home_team_id)    REFERENCES teams (team_id) ON DELETE RESTRICT ON UPDATE RESTRICT)
    ENGINE=InnoDB  DEFAULT CHARSET=latin1;
CREATE TABLE ranks (
    rank_id        int          NOT NULL auto_increment,
	team_id        int          NOT NULL,
	season         int          NOT NULL,
	wk             int          NOT NULL,
    rank 		   int	 		NOT NULL,
    PRIMARY KEY    (rank_id),
    UNIQUE KEY     (team_id, season, wk),
    UNIQUE KEY     (rank, season, wk),
    FOREIGN KEY    (team_id)    REFERENCES teams (team_id) ON DELETE RESTRICT ON UPDATE RESTRICT)
    ENGINE=InnoDB  DEFAULT CHARSET=latin1;
CREATE TABLE sportsbooks (
    sportsbook_id  int          NOT NULL auto_increment,
    sportsbook_nm  varchar(30)  NOT NULL,
    PRIMARY KEY    (sportsbook_id))
    ENGINE=InnoDB  DEFAULT CHARSET=latin1;
CREATE TABLE game_lines (
    game_line_id   int          NOT NULL auto_increment,
	game_id        int          NOT NULL,
	sportsbook_id  int          NOT NULL,
    home_spread    decimal(3,1) NOT NULL,
    vig			   int	 		NOT NULL,
    PRIMARY KEY    (game_line_id),
    UNIQUE KEY     (game_id, sportsbook_id),
    FOREIGN KEY    (game_id)         REFERENCES games (game_id) ON DELETE RESTRICT ON UPDATE RESTRICT,
    FOREIGN KEY    (sportsbook_id)   REFERENCES sportsbooks (sportsbook_id) ON DELETE RESTRICT ON UPDATE RESTRICT)
    ENGINE=InnoDB  DEFAULT CHARSET=latin1;
CREATE TABLE accounts (
    account_id     int          NOT NULL auto_increment,
	account_nm	   varchar(30)  NOT NULL,
	balance		   int          NOT NULL,
    PRIMARY KEY    (account_id))
    ENGINE=InnoDB  DEFAULT CHARSET=latin1;
CREATE TABLE wagers (
    wager_id   	   int          NOT NULL auto_increment,
    game_line_id   int          NOT NULL,
    account_id     int          NOT NULL,
    team  		   ENUM('Home','Away') NOT NULL ,
	amount         int          NOT NULL,
    PRIMARY KEY    (wager_id),
    FOREIGN KEY    (game_line_id)    REFERENCES game_lines (game_line_id) ON DELETE RESTRICT ON UPDATE RESTRICT,
    FOREIGN KEY    (account_id)      REFERENCES accounts (account_id) ON DELETE RESTRICT ON UPDATE RESTRICT)
    ENGINE=InnoDB  DEFAULT CHARSET=latin1;
    