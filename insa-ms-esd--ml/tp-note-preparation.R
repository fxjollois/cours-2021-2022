library(dplyr)
library(readr)
library(lubridate)
library(tidyr)
library(FactoMineR)

prod = read_delim("~/Downloads/prod.csv", delim = ";")

prod_date = prod %>%
  mutate(date = date(Horodate)) %>%
  filter(year(date) > 2017) %>%
  group_by(date, `Filière de production`, `Plage de puissance injection`) %>%
  summarise(Total = sum(`Total énergie injectée (Wh)`, na.rm = T))

write_delim(prod_date, file = "Production.csv", delim = ";")


filieres = prod_date %>%
  #filter(`Filière de production` != "F0 : Total toutes filières") %>%
  group_by(date, `Filière de production`) %>%
  summarise(Total = sum(Total, na.rm = T))

plages = prod_date %>%
  filter(`Plage de puissance injection` != "P0 : Total toutes puissances") %>%
  group_by(date, `Plage de puissance injection`) %>%
  summarise(Total = sum(Total, na.rm = T))


filieres_wide = filieres %>% 
  pivot_wider(names_from = `Filière de production`, values_from = Total)

PCA(filieres_wide[,-1])


plages_wide = plages %>% 
  pivot_wider(names_from = `Plage de puissance injection`, values_from = Total)

PCA(plages_wide[,-1])

filieres_wide %>%
  mutate(Ftotal = `F1 : Thermique non renouvelable` + `F2 : Bioénergies` + `F3 : Hydraulique` + `F4 : Eolien` + `F5 : Solaire` + `F6 : Autres`) %>%
  filter(Ftotal != `F0 : Total toutes filières`) %>%
  select(date, `F0 : Total toutes filières`, Ftotal)
