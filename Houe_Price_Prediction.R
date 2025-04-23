# Load necessary libraries
library(MASS)       # Contains Boston Housing dataset
library(ggplot2)    # For data visualization
library(caret)      # For machine learning functions
library(e1071)      # Required for caret package

# Load the dataset
data(Boston)
dataset <- Boston

# Display dataset structure
str(dataset)
summary(dataset)

# Data Preprocessing ------------------------------------------------------

# Check for missing values
missing_values <- colSums(is.na(dataset))
print("Missing Values:")
print(missing_values)

# No categorical variables to encode in Boston dataset (all are numeric)

# Normalize numeric features
preprocessParams <- preProcess(dataset, method = c("center", "scale"))
dataset_normalized <- predict(preprocessParams, dataset)

# Check for outliers using boxplots
boxplot(dataset_normalized, main = "Boxplot of Normalized Features", las = 2)

# Function to remove outliers using IQR method
remove_outliers <- function(x) {
  qnt <- quantile(x, probs = c(0.25, 0.75))
  H <- 1.5 * IQR(x)
  y <- x
  y[x < (qnt[1] - H)] <- NA
  y[x > (qnt[2] + H)] <- NA
  y
}

# Apply outlier removal to all columns
dataset_clean <- as.data.frame(lapply(dataset_normalized, remove_outliers))
dataset_clean <- na.omit(dataset_clean)

# Exploratory Data Analysis -----------------------------------------------

# Bar graph of crime rate by town
ggplot(dataset, aes(x = reorder(rownames(dataset), crim), y = crim)) +
  geom_bar(stat = "identity", fill = "steelblue") +
  theme(axis.text.x = element_text(angle = 90, hjust = 1, size = 6)) +
  labs(title = "Crime Rate by Town", x = "Town", y = "Crime Rate")

# Scatter plot of RM vs MEDV (number of rooms vs house price)
ggplot(dataset, aes(x = rm, y = medv)) +
  geom_point(color = "darkgreen") +
  geom_smooth(method = "lm", color = "red") +
  labs(title = "Relationship between Room Number and House Price",
       x = "Average Number of Rooms",
       y = "House Price ($1000s)")

# Histogram of house prices
ggplot(dataset, aes(x = medv)) +
  geom_histogram(binwidth = 2, fill = "blue", color = "black") +
  labs(title = "Distribution of House Prices",
       x = "House Price ($1000s)",
       y = "Frequency")

# Model Building & Prediction ----------------------------------------------

# Split data into training and test sets (80% training, 20% testing)
set.seed(123)
trainIndex <- createDataPartition(dataset_clean$medv, p = 0.8, list = FALSE)
train_data <- dataset_clean[trainIndex, ]
test_data <- dataset_clean[-trainIndex, ]

# Build linear regression model
model <- lm(medv ~ ., data = train_data)

# Model summary
summary(model)

# Predict on test data
predictions <- predict(model, newdata = test_data)

# Evaluate model performance
results <- data.frame(Actual = test_data$medv, Predicted = predictions)
rmse <- sqrt(mean((results$Actual - results$Predicted)^2))
r_squared <- summary(model)$r.squared

cat("Model Performance Metrics:\n")
cat("RMSE:", rmse, "\n")
cat("R-squared:", r_squared, "\n")

# Visualization of actual vs predicted values
ggplot(results, aes(x = Actual, y = Predicted)) +
  geom_point(color = "blue") +
  geom_abline(intercept = 0, slope = 1, color = "red", linetype = "dashed") +
  labs(title = "Actual vs Predicted House Prices",
       x = "Actual Price ($1000s)",
       y = "Predicted Price ($1000s)") +
  annotate("text", x = min(results$Actual), y = max(results$Predicted),
           label = paste("RMSE =", round(rmse, 2), "\nR² =", round(r_squared, 2)),
           hjust = 0, vjust = 1)

# Feature importance
importance <- varImp(model)
ggplot(importance, aes(x = rownames(importance), y = Overall)) +
  geom_bar(stat = "identity", fill = "orange") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  labs(title = "Feature Importance in House Price Prediction",
       x = "Features",
       y = "Importance Score")

# Sensitivity analysis - How changing room number affects price
room_range <- seq(min(dataset$rm), max(dataset$rm), by = 0.1)
sensitivity_data <- data.frame(rm = room_range)
other_features <- colMeans(dataset[, !names(dataset) %in% c("medv", "rm")])
sensitivity_data <- cbind(sensitivity_data, as.data.frame(t(other_features)))

sensitivity_predictions <- predict(model, newdata = sensitivity_data)

sensitivity_results <- data.frame(Rooms = room_range, Predicted_Price = sensitivity_predictions)

ggplot(sensitivity_results, aes(x = Rooms, y = Predicted_Price)) +
  geom_line(color = "purple", size = 1) +
  labs(title = "Sensitivity Analysis: Effect of Room Number on House Price",
       x = "Average Number of Rooms",
       y = "Predicted Price ($1000s)") +
  geom_vline(xintercept = mean(dataset$rm), linetype = "dashed", color = "red") +
  annotate("text", x = mean(dataset$rm), y = max(sensitivity_predictions),
           label = paste("Mean Room Number =", round(mean(dataset$rm), 2)),
           hjust = 1.1, vjust = 1)