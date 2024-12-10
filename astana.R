setwd("D:/2024 fall/DSE 511/hw6/")

season22regular <- read.csv("2022-2023 NBA Player Stats - Regular.csv", sep = ";")

season22playoff <- read.csv("2022-2023 NBA Player Stats - Playoffs.csv", sep = ";")

playoff_players <- season22playoff$Player

regular_in_playoff <- season22regular[season22regular$Player %in% playoff_players,]

regular_in_playoff_unique <- regular_in_playoff[regular_in_playoff$Tm == "TOT",]
remaining <- regular_in_playoff[!(regular_in_playoff$Player %in% regular_in_playoff_unique$Player),]
regular_in_playoff_unique <- rbind(regular_in_playoff_unique, remaining[!duplicated(remaining$Player),])

write.table(regular_in_playoff_unique, "Regular_in_Playoff_Unique.csv", row.names = FALSE, sep = ";")

### assist compare

# top 10 assist in regular season enter playoff
top10_AST <- regular_in_playoff_unique[order(-regular_in_playoff_unique$AST), ][1:10, ]
# names
top10_astname <-top10_AST$Player
# ast performance in playoffs
playoff_ast_performance <- season22playoff[season22playoff$Player %in% top10_astname, ]
playoff_ast_performance_sorted <- playoff_ast_performance[order(-playoff_ast_performance$AST), ]

## plot assist
library(ggplot2)

top10_AST$Season <- "Regular"
playoff_ast_performance_sorted$Season <- "Playoff"


combined_data2 <- rbind(
  data.frame(Player = top10_AST$Player, AST = top10_AST$AST, Season = top10_AST$Season),
  data.frame(Player = playoff_ast_performance_sorted$Player, AST = playoff_ast_performance_sorted$AST, Season = playoff_ast_performance_sorted$Season)
)

combined_data2$Player <- factor(combined_data2$Player, levels = top10_AST$Player)

combined_data2$Season <- factor(combined_data2$Season, levels = c("Regular", "Playoff"))

ggplot(combined_data2, aes(x = Player, y = AST, fill = Season)) +
  geom_bar(stat = "identity", position = "dodge") +
  labs(title = "Top 10 Assisters in Regular Season and Playoff Performance",
       x = "Player",
       y = "Assist",
       fill = "Season 22-23")+
  theme_minimal() +
  theme(
    axis.text.x = element_text(angle = 45, hjust = 1),
    plot.title = element_text(hjust = 0.5, size = 14, face = "bold"),
    legend.position = "top"
  )

