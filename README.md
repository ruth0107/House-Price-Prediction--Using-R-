# House Price Prediction using Boston Housing Dataset

![R](https://img.shields.io/badge/language-R-blue.svg)
![License](https://img.shields.io/badge/license-MIT-green.svg)

## Project Overview
This project develops a predictive model to estimate house prices based on key features from the Boston Housing Dataset. The model assists both buyers and sellers in making informed decisions within the real estate market by providing accurate price predictions.

## Dataset Information
- **Dataset Name**: Boston Housing Dataset
- **Dimensions**: 506 rows × 14 columns
- **Features Include**:
  - CRIM: Per capita crime rate by town
  - ZN: Proportion of residential land zoned for lots over 25,000 sq.ft.
  - INDUS: Proportion of non-retail business acres per town
  - CHAS: Charles River dummy variable (1 if tract bounds river; 0 otherwise)
  - NOX: Nitric oxides concentration (parts per 10 million)
  - RM: Average number of rooms per dwelling
  - AGE: Proportion of owner-occupied units built prior to 1940
  - DIS: Weighted distances to five Boston employment centers
  - RAD: Index of accessibility to radial highways
  - TAX: Full-value property-tax rate per $10,000
  - PTRATIO: Pupil-teacher ratio by town
  - B: 1000(Bk - 0.63)² where Bk is the proportion of blacks by town
  - LSTAT: % lower status of the population
  - MEDV: Median value of owner-occupied homes in $1000s (target variable)


## Methodology
1. **Data Preprocessing**:
   - Handling missing values
   - Normalizing/scaling numeric features
   - Identifying and removing outliers

2. **Exploratory Data Analysis**:
   - Univariate analysis (histograms, boxplots)
   - Bivariate analysis (scatter plots, correlation)
   - Feature importance analysis

3. **Model Building**:
   - Linear regression model
   - Train-test split (80-20)
   - Model evaluation using RMSE and R-squared

4. **Visualization**:
   - Relationship between features and target variable
   - Actual vs predicted values
   - Sensitivity analysis

## Key Findings
1. Positive correlation between average room count (RM) and house prices (MEDV)
2. Outlier removal improved model performance by 12%
3. Top 3 important features:
   - RM (number of rooms)
   - LSTAT (% lower status population)
   - PTRATIO (pupil-teacher ratio)
4. Achieved R-squared value of 0.78 on test data

## How to Run
1. Install required packages:
```R
install.packages(c("MASS", "ggplot2", "caret", "e1071"))
```

2. Run the main script:
```R
source("House_Price_Prediction.R")
```

## Results Interpretation
- **RMSE (Root Mean Squared Error)**: Lower values indicate better fit
- **R-squared**: Proportion of variance explained (0-1, higher is better)
- **Feature Importance**: Shows which variables most influence house prices

## Conclusion
This project successfully developed a linear regression model for house price prediction with good accuracy. The model can help:
- Home buyers estimate fair prices
- Real estate agents make data-driven recommendations
- Sellers price their properties competitively
