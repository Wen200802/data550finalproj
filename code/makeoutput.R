here::i_am(
  "code/makeoutput.R"
)


library(here)
library(dplyr)
library(ggplot2)
library(labelled)
library(gtsummary)
library(stringr)

# Step 1: Load and Merge Data -------------------------------------------------
# Read split CSV files using here::here() for locating files
data_part1 <- fread(here::here("code", "Alzheimer_s_Disease_Part_1.csv"))
data_part2 <- fread(here::here("code", "Alzheimer_s_Disease_Part_2.csv"))
data_part3 <- fread(here::here("code", "Alzheimer_s_Disease_Part_3.csv"))
data_part4 <- fread(here::here("code", "Alzheimer_s_Disease_Part_4.csv"))

# Merge all parts into one data frame
alzhe <- rbind(data_part1, data_part2, data_part3, data_part4)

# Save merged data as RDS
saveRDS(alzhe, here::here("output", "alzhe_combined.rds"))

# Step 2: Filter and Modify Data -----------------------------------------------
# Load the combined dataset from RDS file
alzhe <- readRDS(here::here("output", "alzhe_combined.rds"))

# Filter data to focus on "Cognitive Decline"
filtered_data <- alzhe %>%
  filter(Class == "Cognitive Decline")

# Modify StratificationID1 column
summary_data <- filtered_data %>%
  mutate(StratificationID1 = case_when(
    StratificationID1 == "AGE_OVERALL" ~ "All Ages",
    StratificationID1 == "5064" ~ "50-64 years old",
    StratificationID1 == "65PLUS" ~ "65 years old and above"
  ))

# Modify Stratification2 column to replace empty values with "No Value"
summary_data <- summary_data %>%
  mutate(Stratification2 = if_else(Stratification2 == "" | trimws(Stratification2) == "", "No Value", Stratification2))

# Save filtered and modified data as RDS
saveRDS(summary_data, here::here("output", "summary_data_filtered.rds"))

# Step 3: Generate Summary Table ----------------------------------------------
# Load filtered summary data from RDS file
summary_data <- readRDS(here::here("output", "summary_data_filtered.rds"))

# Add labels to variables for clarity in tables
var_label(summary_data) <- list(
  StratificationID1 = "Age",
  LocationDesc = "Region",
  Stratification2 = "Race and Gender"
)

# Create summary table and save it as RDS
summary_tbl <- summary_data |>
  select("StratificationID1", "LocationDesc", "Stratification2") |>
  tbl_summary(by = StratificationID1) |>
  modify_spanning_header(c("stat_1", "stat_2", "stat_3") ~ "**Age**") |>
  add_overall() |>
  add_p()

# Save summary table to RDS
saveRDS(summary_tbl, here::here("output", "summary_table.rds"))

# Step 4: Generate Topic Frequency Plot ---------------------------------------
# Calculate frequency for each topic
topic_counts <- summary_data %>%
  group_by(Topic) %>%
  summarise(Count = n()) %>%
  mutate(Topic = str_wrap(Topic, width = 30)) 

# Create topic frequency plot
topic_plot <- ggplot(topic_counts, aes(x = Topic, y = Count)) +
  geom_bar(stat = "identity") +
  geom_text(aes(label = Count), vjust = 0.1, color = "black") +
  coord_flip() +  
  labs(title = "Frequency of Topics", x = "Topic", y = "Count")

# Save topic frequency plot to RDS
saveRDS(topic_plot, here::here("output", "topic_frequency_plot.rds"))

# Step 5: Generate Question Frequency Plot ------------------------------------
# Calculate frequency for each question
question_counts <- summary_data %>%
  group_by(Question) %>%
  summarise(Count = n()) %>%
  mutate(Question = str_wrap(Question, width = 35)) 

# Create question frequency plot
question_plot <- ggplot(question_counts, aes(x = Question, y = Count)) +
  geom_bar(stat = "identity") +
  geom_text(aes(label = Count), vjust = 0.1, color = "black") +
  coord_flip() +  
  labs(title = "Frequency of Questions", x = "Question", y = "Count")

# Save question frequency plot to RDS
saveRDS(question_plot, here::here("output", "question_frequency_plot.rds"))