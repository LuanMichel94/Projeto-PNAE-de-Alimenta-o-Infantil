
#################################################################
#  Merge das bases de dados utilizando o arquivo ComexStat.xlsx #
#################################################################

# ======================================================================================================================
# Pacotes utililizados neste Script
# ======================================================================================================================
library(readxl)
library(tidyr)
library(dplyr)

# ======================================================================================================================
# PARTE 1 - IMPORTANDO OS DADOS DA COMEXSTAT - AGRICULTURA
# ======================================================================================================================
comexstat <- read_excel("data/ComexStat/ComexStat.xlsx", sheet = "Importar") %>% 
  #mutate(Municipio = str_sub(Municipio, end = -6)) %>% 
  mutate(
    Municipio = case_when(
      Municipio=="Mogi-Mirim - SP"   ~ "Mogi Mirim - SP",
      Municipio=="Belém de São Francisco - PE"   ~ "Belém do São Francisco - PE",
      Municipio=="Santana do Livramento - RS"   ~ "Sant'Ana do Livramento - RS",
      Municipio=="Embu - SP"  ~ "Embu-Guaçu - SP",
      Municipio=="Amambaí - MS"  ~ "Amambai - MS",
      Municipio=="Lagoa do Itaenga - PE" ~ "Lagoa de Itaenga - PE",
      Municipio=="São Valério da Natividade - TO" ~ "São Valério - TO",
      Municipio=="Barueri - SP"  ~ "Bariri - SP",
      TRUE ~ Municipio
    )
  ) %>% 
  mutate(join = paste(Municipio, "_", Produto)) %>% 
  select(join, `Quantidade (Toneladas)`, `Valor FOB (US$)`) %>% 
  distinct_all()

# ======================================================================================================================
# PARTE 2 - MANIPULANDO OS DADOS DA COMEXSTAT - AGRICULTURA
# ======================================================================================================================
quantidade_produzida <- quantidade_produzida %>% 
  mutate(join = paste(`Nome do Município`, "-", `Estado (UF)`, "_", Produto)) %>% 
  left_join(comexstat, by = c("join")) %>% 
  select(-join, -`Valor FOB (US$)`)

valor_da_producao <- valor_da_producao %>% 
  mutate(join = paste(`Nome do Município`, "-", `Estado (UF)`, "_", Produto)) %>% 
  left_join(comexstat, by = c("join")) %>% 
  select(-join, -`Quantidade (Toneladas)`)


# ======================================================================================================================
# PARTE 3 - CONSOLIDANDO OS DADOS DO COMEXSTAT - AGRICULTURA
# ======================================================================================================================
rm(comexstat)

gc()

# -------------------------------------------------------------------------