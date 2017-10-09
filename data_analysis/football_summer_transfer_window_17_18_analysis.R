#loads required packages
require('RCurl')
require('dplyr')
options(scipen=999)


#loads data from online source
transfer_data <- read.csv(text=getURL("https://raw.githubusercontent.com/Worville/guardian_transfers/master/guardian_all_transfers_2017-09-02.csv"), header=T, stringsAsFactors = FALSE)

player_transfers <- select(transfer_data, player_name, new_club, price_pounds, new_league) %>% filter(new_league == "Premier League" | new_league == "Serie A" | new_league == "Bundesliga" | new_league == "La Liga" | new_league == "Ligue 1") %>% arrange(desc(new_league)) %>% filter(new_club != "Pescara") %>% filter(new_club != "Free agent")

player_transfers$price_pounds[is.na(player_transfers$price_pounds)] <- " "

write.csv(player_transfers, "~/Desktop/coding_projects/football_transfers/data/player_transfers.csv")

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
outgoing_transfers_cost <- group_by(transfer_data, previous_club) %>% summarise(total = sum(price_pounds, na.rm=TRUE)) %>% arrange(desc(total))

#merges cost of incoming transfers and outgoing transfer dataset and creates a column on total net spend by club
net_spend_per_club <- merge(incoming_transfers_cost, outgoing_transfers_cost, by.x=c("new_club"), by.y=c("previous_club")) %>% mutate(net_spend = total.x - total.y) %>% select(new_club, net_spend)

#creates a unique list of all clubs in the data 
new_clubs <- select(transfer_data, new_club, new_league) 
names(new_clubs) <- c("club", "league")

old_clubs <-select(transfer_data, previous_club, previous_league)
names(old_clubs) <- c("club", "league")

#removes clubs which appear twice
all_clubs <- rbind(new_clubs, old_clubs) %>% subset(!duplicated(club))

#merges club list with net spend dataset and keeps clubs only in the big five European leagues. Removes Pescara which looks like an error and adds a column each for total incoming and total outgoing players
net_spend_per_club_top_five_leagues <- merge(net_spend_per_club, all_clubs, by.x = "new_club", by.y = "club") %>% filter(league == "Premier League" | league == "Serie A" | league == "Bundesliga" | league == "La Liga" | league == "Ligue 1") %>% arrange(desc(league)) %>% filter(new_club != "Pescara") %>% merge(incoming_transfers, by="new_club") %>% merge(outgoing_transfers, by.x = "new_club", by.y = "club") %>% View() %>% write.csv("data.csv")

group_by(net_spend_per_club_top_five_leagues, league) %>% summarise(count = n())



