setwd("D:/2024 fall/DSE 511/hw6/")

season22regular <- read.csv("2022-2023 NBA Player Stats - Regular.csv", sep = ";")

season22playoff <- read.csv("2022-2023 NBA Player Stats - Playoffs.csv", sep = ";")

playoff_players <- season22playoff$Player

regular_in_playoff <- season22regular[season22regular$Player %in% playoff_players,]

regular_in_playoff_unique <- regular_in_playoff[regular_in_playoff$Tm == "TOT",]
remaining <- regular_in_playoff[!(regular_in_playoff$Player %in% regular_in_playoff_unique$Player),]
regular_in_playoff_unique <- rbind(regular_in_playoff_unique, remaining[!duplicated(remaining$Player),])

write.table(regular_in_playoff_unique, "Regular_in_Playoff_Unique.csv", row.names = FALSE, sep = ";")



### Block compare

# Top 10 block players in regular season enter playoff
top10_BLK <- regular_in_playoff_unique[order(-regular_in_playoff_unique$BLK), ][1:10, ]
# Extract player names
top10_blkname <- top10_BLK$Player

# Block performance in playoffs
playoff_blk_performance <- season22playoff[season22playoff$Player %in% top10_blkname, ]
playoff_blk_performance_sorted <- playoff_blk_performance[order(-playoff_blk_performance$BLK), ]

top10_BLK$Season <- "Regular"
playoff_blk_performance_sorted$Season <- "Playoff"

# Combine regular and playoff block data
combined_data3 <- rbind(
  data.frame(Player = top10_BLK$Player, BLK = top10_BLK$BLK, Season = top10_BLK$Season),
  data.frame(Player = playoff_blk_performance_sorted$Player, BLK = playoff_blk_performance_sorted$BLK, Season = playoff_blk_performance_sorted$Season)
)

combined_data3$Player <- factor(combined_data3$Player, levels = top10_BLK$Player)

combined_data3$Season <- factor(combined_data3$Season, levels = c("Regular", "Playoff"))

# Plot block data
ggplot(combined_data3, aes(x = Player, y = BLK, fill = Season)) +
  geom_bar(stat = "identity", position = "dodge") +
  labs(title = "Top 10 Blockers in Regular Season and Playoff Performance",
       x = "Player",
       y = "Blocks",
       fill = "Season 22-23") +
  theme_minimal() +
  theme(
    axis.text.x = element_text(angle = 45, hjust = 1),
    plot.title = element_text(hjust = 0.5, size = 14, face = "bold"),
    legend.position = "top"
  )

