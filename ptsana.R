setwd("D:/2024 fall/DSE 511/hw6/")

season22regular <- read.csv("2022-2023 NBA Player Stats - Regular.csv", sep = ";")

season22playoff <- read.csv("2022-2023 NBA Player Stats - Playoffs.csv", sep = ";")

playoff_players <- season22playoff$Player

regular_in_playoff <- season22regular[season22regular$Player %in% playoff_players,]

regular_in_playoff_unique <- regular_in_playoff[regular_in_playoff$Tm == "TOT",]
remaining <- regular_in_playoff[!(regular_in_playoff$Player %in% regular_in_playoff_unique$Player),]
regular_in_playoff_unique <- rbind(regular_in_playoff_unique, remaining[!duplicated(remaining$Player),])

write.table(regular_in_playoff_unique, "Regular_in_Playoff_Unique.csv", row.names = FALSE, sep = ";")



### Points comparison

# top 10 points in regular season enter playoff
top10_PTS <- regular_in_playoff_unique[order(-regular_in_playoff_unique$PTS), ][1:10, ]
# names
top10_ptsname <- top10_PTS$Player
# points performance in playoffs
playoff_pts_performance <- season22playoff[season22playoff$Player %in% top10_ptsname, ]
playoff_pts_performance_sorted <- playoff_pts_performance[order(-playoff_pts_performance$PTS), ]

## plot points
library(ggplot2)

top10_PTS$Season <- "Regular"
playoff_pts_performance_sorted$Season <- "Playoff"

combined_data_pts <- rbind(
  data.frame(Player = top10_PTS$Player, PTS = top10_PTS$PTS, Season = top10_PTS$Season),
  data.frame(Player = playoff_pts_performance_sorted$Player, PTS = playoff_pts_performance_sorted$PTS, Season = playoff_pts_performance_sorted$Season)
)

combined_data_pts$Player <- factor(combined_data_pts$Player, levels = top10_PTS$Player)

combined_data_pts$Season <- factor(combined_data_pts$Season, levels = c("Regular", "Playoff"))

ggplot(combined_data_pts, aes(x = Player, y = PTS, fill = Season)) +
  geom_bar(stat = "identity", position = "dodge") +
  labs(title = "Top 10 Scorers in Regular Season and Playoff Performance",
       x = "Player",
       y = "Points",
       fill = "Season 22-23") +
  theme_minimal() +
  theme(
    axis.text.x = element_text(angle = 45, hjust = 1),
    plot.title = element_text(hjust = 0.5, size = 14, face = "bold"),
    legend.position = "top"
  )

