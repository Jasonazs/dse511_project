setwd("D:/2024 fall/DSE 511/hw6/")

season22regular <- read.csv("2022-2023 NBA Player Stats - Regular.csv", sep = ";")

season22playoff <- read.csv("2022-2023 NBA Player Stats - Playoffs.csv", sep = ";")

playoff_players <- season22playoff$Player

regular_in_playoff <- season22regular[season22regular$Player %in% playoff_players, ]

write.csv(regular_in_playoff, "Regular_Stats_For_Playoff_Players.csv", row.names = FALSE, sep = ";")

