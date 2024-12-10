setwd("D:/2024 fall/DSE 511/hw6/")

season22regular <- read.csv("2022-2023 NBA Player Stats - Regular.csv", sep = ";")

season22playoff <- read.csv("2022-2023 NBA Player Stats - Playoffs.csv", sep = ";")

playoff_players <- season22playoff$Player

regular_in_playoff <- season22regular[season22regular$Player %in% playoff_players,]

regular_in_playoff_unique <- regular_in_playoff[regular_in_playoff$Tm == "TOT",]
remaining <- regular_in_playoff[!(regular_in_playoff$Player %in% regular_in_playoff_unique$Player),]
regular_in_playoff_unique <- rbind(regular_in_playoff_unique, remaining[!duplicated(remaining$Player),])

write.table(regular_in_playoff_unique, "Regular_in_Playoff_Unique.csv", row.names = FALSE, sep = ";")


### regular season 3 point shooter
high_3pshooter_r <- regular_in_playoff_unique[
  regular_in_playoff_unique$`X3PA` > 5 & regular_in_playoff_unique$`X3P` > 0.38, 
]

top10_3pshooters_r <- high_3pshooter_r[order(-high_3pshooter_r$`X3P`), ][1:10, ]

### playoff season 3 point shooter
high_3pshooter_p <- season22playoff[
  season22playoff$`X3PA` > 5 & season22playoff$`X3P` > 0.35, 
]

top10_3pshooters_p <- high_3pshooter_p[order(-high_3pshooter_p$`X3P`), ][1:10, ]


### real 3p shooter


library(ggplot2)


top10_3pshooters_p$Season <- "Playoff"
top10_3pshooters_r$Season <- "Regular"  


combined_3p_data <- rbind(
  data.frame(Player = top10_3pshooters_r$Player, ThreePointPercentage = top10_3pshooters_r$X3P., Season = top10_3pshooters_r$Season),
  data.frame(Player = top10_3pshooters_p$Player, ThreePointPercentage = top10_3pshooters_p$X3P., Season = top10_3pshooters_p$Season)
)


combined_3p_data$Player <- factor(combined_3p_data$Player, levels = unique(combined_3p_data$Player))


ggplot(combined_3p_data, aes(x = Player, y = ThreePointPercentage, fill = Season)) +
  geom_bar(stat = "identity", position = "dodge") +
  labs(title = "Regular vs Playoff 3-Point Performance",
       x = "Player",
       y = "3-Point Percentage",
       fill = "Season") +
  theme_minimal() +
  theme(
    axis.text.x = element_text(angle = 45, hjust = 1),
    plot.title = element_text(hjust = 0.5, size = 14, face = "bold"),
    legend.position = "top"
  )
