USE premierleague;

# Q1: Which player with yellow cards scored more goals in 5 years than other players with more cards?
CREATE OR REPLACE VIEW yellow_cards AS (
SELECT players.first_name, players.last_name, yellow_cards, goals
	FROM players
		JOIN player_cards USING(player_id)
        JOIN player_goals USING(player_id)
WHERE yellow_cards > 0
ORDER BY yellow_cards, goals DESC
);

# Q2: How many assists did a player have in a certain position vs another?
CREATE OR REPLACE VIEW position_assists AS (
SELECT position, assists
	FROM players
    JOIN player_goals USING(player_id)
GROUP BY position
ORDER BY assists DESC
);

# Q3: What is the average number of goals for a club when playing home vs. playing away?
CREATE OR REPLACE VIEW home_away_avg AS (
WITH avg_away AS 
(SELECT away_name, AVG(away_score) AS away_avg
	FROM matches
	WHERE away_name = "Manchester United")
    
SELECT home_name AS "Team Name",  home_avg AS "Home AVG", away_avg AS "Away AVG"
	FROM (SELECT home_name, AVG(home_score) AS home_avg
		FROM matches
		WHERE home_name = "Manchester United") home_avg
	JOIN avg_away ON home_name = away_name
);
    
# Q4: Of the best players in all matches, who scored the most goals?
CREATE OR REPLACE VIEW matches_best_players AS (
SELECT CONCAT(players.first_name, " ", players.last_name) AS "Player Name", best_player_counter ,goals
	FROM players
    JOIN player_goals USING(player_id)
    WHERE players.best_player_counter > 0
    ORDER BY goals DESC
);

# Q5: What are the stats of best players of each season?
CREATE OR REPLACE VIEW season_best_players_stats AS (
SELECT player_id, season AS "Season", best_player AS "Player Name", 
	players.club AS "Club Name", shirt_number AS "Shirt Number", position AS "Position", 
		CONCAT(coach_first_name, " ", coach_last_name) AS "Coach Name", goals AS "Total Goals",
        assists AS "Assists", yellow_cards AS "Yellow Cards", red_cards AS "Red Cards"
	FROM winners
    JOIN player_cards USING (player_id)
    JOIN player_goals USING (player_id)
    JOIN players USING (player_id)
    JOIN clubs ON players.club_id = clubs.club_id
);
