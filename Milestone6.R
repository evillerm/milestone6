library(tidyverse)

#dropBoxURL = "https://www.dropbox.com/s/hqp6zxmuikfo7k0/3113395.csv?dl=1"
destFile = str_extract(strsplit(dropBoxURL,"/")[[1]][6],".*(?=\\?)")
download.file(dropBoxURL,destFile, mode = "wb")
# zip::unzip(destFile, exdir = 'Milesone3Files')


## read all data
liveBankAcct = read_csv('liveBankAcct.csv')
liveCustomerList = read_csv('liveCustomerList.csv')
sampleBankAccInput = read_csv(destFile) # This is be read in by URL
# This is not being used for the main data manipulation
sampleBankAcctSolution = read_csv('sampleBankAcctSolution.csv')


## compare login bank acct to cust bank acct and flag
bankAcctSolution = sampleBankAccInput %>% 
  left_join(liveCustomerList) %>% ## join cust list to get names
  left_join(liveBankAcct,by = c('firstName','lastName')) %>% ## join bank acct to get known bank acct
  mutate(rightAcctFlag = if_else(loginAcct == bankAcctID,1,0)) %>% ## compare loginAcct with bankAcct
  group_by(custID,loginAcct) %>%
  summarise(rightAcctFlag = sum(rightAcctFlag)) %>%
  select(custID,rightAcctFlag)


## compare result with sample solution
# setdiff(bankAcctSolution,sampleBankAcctSolution)

## write output csv file
write_csv(bankAcctSolution,destFile)