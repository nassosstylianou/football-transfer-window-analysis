setwd('~/Desktop/R/football_transfers/')
require('RCurl')
require('dplyr')
require('ggplot2')

#loads data from online source
transfer_data <- read.csv(text=getURL("https://raw.githubusercontent.com/Worville/guardian_transfers/master/guardian_all_transfers_2017-09-02.csv"), header=T, stringsAsFactors = FALSE)
#prints first few rows of data
head(transfer_data)

#analyses transfer data to sort by incoming transfers by club, ordered by  club with most transfers
incoming_transfers <- group_by(transfer_data, new_club) %>% summarise(count = n()) %>% arrange(desc(count))
names(incoming_transfers) <- c("new_club", "players_in")

#analyses transfer data to sort by outgoing transfers by club, ordered by  club with most transfers
outgoing_transfers <- group_by(transfer_data, previous_club) %>% summarise(count = n()) %>% arrange(desc(count))
names(outgoing_transfers) <- c("club", "players_out")

#analyses transfer data to sort by the cost of incoming transfers by club, ordered by  club with most transfers
incoming_transfers_cost <- group_by(transfer_data, new_club) %>% summarise(total = sum(price_pounds, na.rm=TRUE)) %>% arrange(desc(total))

#analyses transfer data to sort by the cost of outgoing transfers by club, ordered by  club with most transfers
total_outgoing_transfers_cost <- group_by(transfer_data, previous_club) %>% summarise(total = sum(price_pounds, na.rm=TRUE)) %>% arrange(desc(total))

net_spend_per_club <- merge(incoming_transfers_cost, total_outgoing_transfers_cost, by.x=c("new_club"), by.y=c("previous_club")) %>% mutate(net_spend = total.x - total.y) %>% select(new_club, net_spend)
 
new_clubs <- select(transfer_data, new_club, new_league) 
names(new_clubs) <- c("club", "league")


old_clubs <-select(transfer_data, previous_club, previous_league)
names(old_clubs) <- c("club", "league")

all_clubs <- rbind(new_clubs, old_clubs) %>% subset(!duplicated(club))

net_spend_per_club_top_five_leagues <- merge(net_spend_per_club, all_clubs, by.x = "new_club", by.y = "club") %>% filter(league == "Premier League" | league == "Serie A" | league == "Bundesliga" | league == "La Liga" | league == "Ligue 1") %>% arrange(desc(league)) %>% filter(new_club != "Pescara") %>% merge(incoming_transfers, by="new_club") %>% merge(outgoing_transfers, by.x = "new_club", by.y = "club") %>% View() %>% write.csv("data.csv")

group_by(net_spend_per_club_top_five_leagues, league) %>% summarise(count = n())





#analyses transfer data to summarise spending on players by league 
totals_spent_by_league <- group_by(transfer_data, new_league) %>% summarise(total = sum(price_pounds, na.rm=TRUE) ) %>% filter(new_league == "Premier League" | new_league == "Serie A" | new_league == "La Liga" | new_league == "Ligue 1" | new_league == "Bundesliga") %>% arrange(desc(total))

#analyses transfer data to summarise spending on players by club 
totals_spent_by_club <- group_by(transfer_data, new_club) %>% summarise(total =  sum(price_pounds, na.rm=TRUE) ) %>% arrange(desc(total))


transfer_data$new_club <- gsub("Vitesse Arnhem", "Vitesse", transfer_data$new_club, ignore.case=T)

transfer_data$previous_club <- gsub("Vitesse Arnhem", "Vitesse", transfer_data$previous_club, ignore.case=T)


number_of_transfers_same_clubs <- filter(transfer_data, new_club != "Free agent") %>% group_by(new_club, previous_club) %>% summarise(count = n()) %>% filter() %>% arrange(desc(count))

chelsea <- group_by(transfer_data, new_club, previous_club) %>% filter(previous_club == "Chelsea")

total_spend_by_clubs <- group_by(transfer_data, new_club, previous_club) %>% summarise(total =  sum(price_pounds, na.rm=TRUE) ) %>% arrange(desc(total))




average_per_player_by_league <- group_by(transfer_data, new_league) %>% summarise(avg = mean(price_pounds, na.rm=TRUE)) %>% arrange(desc(avg))

average_per_player_by_club <- group_by(transfer_data, new_club) %>% summarise(avg = mean(price_pounds, na.rm=TRUE)) %>% arrange(desc(avg))

average_per_player_by_club_with_count <- group_by(transfer_data, new_club) %>% summarise(count = n()) %>% merge(average_per_player_by_club, by = "new_club") %>% arrange(desc(avg))

transfer_data_within_leagues <- transfer_data[!duplicated(transfer_data$player_name),]
transfers_within_leagues <- group_by(transfer_data_within_leagues, previous_league, new_league) %>% summarise(count = n()) %>% arrange(desc(count))


transfers_within_leagues_checking <- group_by(transfer_data, previous_league, new_league) %>% summarise(count = n()) %>% arrange(desc(count))



transfers_within_leagues_check <- filter(transfer_data, previous_league == 'Serie A' & new_league == 'Serie A')


psg <- filter(transfer_data, new_club == "Paris Saint-Germain") %>% print()
chelsea <- filter(transfer_data, new_club == "Chelsea") %>% print()

