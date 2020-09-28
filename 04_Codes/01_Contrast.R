# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ #
# ProjectName:  MAX_CMAX_Contrast
# Purpose:      Contrast
# programmer:   Zhe Liu
# Date:         2020-09-27
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ #


data.part1 <- read.xlsx('02_Inputs/【医院200】17年安徽江苏交付表-200402.xlsx')
data.part2 <- read.xlsx('02_Inputs/【医院200】17年福建交付表-200402.xlsx')
data.part3 <- read.xlsx('02_Inputs/【医院200】17年山东浙江交付表-20200402.xlsx')
names(data.part3) <- c("序号", "年份", "月份", "季度", "省份", "城市", "区县", 
                       "类型（公立民营）", "医疗机构属性", "等级", "标准医院", 
                       "匹配名", "药品名称", "剂型", "规格包装", "生产企业", 
                       "价格", "数量", "金额", 'na')
data.part4 <- read.xlsx('02_Inputs/【医院200】18年安徽、福建、江苏数据交付表-20200322.xlsx', sheet = 2)
data.part5 <- read.xlsx('02_Inputs/【医院200项目】18年山东、浙江数据交付表-20200322.xlsx')
data.part6 <- read.xlsx('02_Inputs/【医院200】19年交付表-2003.xlsx', sheet = 2)
data.part7 <- read.xlsx('02_Inputs/【医院200】19年交付表-2003.xlsx', sheet = 3)

data.total <- bind_rows(data.part1, data.part2, data.part3, data.part4, data.part5, data.part6, data.part7)

contrast1 <- data.total %>% 
  filter(grepl('奥沙利铂', `匹配名`)) %>% 
  mutate(flag = if_else(grepl('Thissen|赛诺菲', `生产企业`), 1, 0)) %>% 
  group_by(`年份`, flag) %>% 
  summarise(units = sum(`数量`), 
            sales = sum(`金额`)) %>% 
  ungroup() %>% 
  group_by(`年份`) %>% 
  mutate(sales_total = sum(sales)) %>% 
  ungroup() %>% 
  filter(flag == 1) %>% 
  mutate(sales_share = sales / sales_total, 
         molecule = '奥沙利铂')

contrast2 <- data.total %>% 
  filter(grepl('多柔比星', `匹配名`)) %>% 
  mutate(flag = if_else(grepl('石药', `生产企业`), 1, 0)) %>% 
  group_by(`年份`, flag) %>% 
  summarise(units = sum(`数量`), 
            sales = sum(`金额`)) %>% 
  ungroup() %>% 
  group_by(`年份`) %>% 
  mutate(sales_total = sum(sales)) %>% 
  ungroup() %>% 
  filter(flag == 1) %>% 
  mutate(sales_share = sales / sales_total, 
         molecule = '多柔比星')

wb <- createWorkbook()
addWorksheet(wb, '奥沙利铂')
addWorksheet(wb, '多柔比星')
writeData(wb, '奥沙利铂', contrast1)
writeData(wb, '多柔比星', contrast2)
saveWorkbook(wb, '03_Outputs/MAX_CMAX_Contrast.xlsx')



