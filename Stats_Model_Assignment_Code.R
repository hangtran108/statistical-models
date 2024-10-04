# Hang Tran - Assignment 1 - Statistical Models
# Exercise 2
tips <- rep(1:4, times = 4)
coupons <- rep(1:4, each = 4)
hardness_values <- c(9.3, 9.4, 9.2, 9.7, 
                     9.4, 9.3, 9.4, 9.6, 
                     9.6, 9.8, 9.5, 10.0, 
                     10.0, 9.9, 9.7, 10.2)
dataframe <- data.frame(Coupon = coupons, Tip = tips, Hardness = hardness_values)
random_order <- sample(1:16, size = 16, replace = FALSE)
df <- data.frame(dataframe, random_order)
df

## b
par(mfrow=c(2,2))
boxplot(hardness_values~tips,data=df)
boxplot(hardness_values~coupons,data=df)
# Interaction shows up as nonparallel curves.  
interaction.plot(coupons,tips,hardness_values,ylab="Hardness Values",
                 xlab="Coupons",col=c("orange","red","blue","green"),lty=c(1:4),lwd=2) 

interaction.plot(tips,coupons, hardness_values,ylab="Hardness Values",
                 xlab="Tips",col=c("orange","red","blue","green"),lty=c(1:4),lwd=2) 

## c
Coupon <- as.factor(df$Coupon)  # Convert to factor
Tip <- as.factor(df$Tip)  # Convert to factor
Hardness=as.vector(unlist(hardness_values))
mod.full=lm(Hardness~Coupon+Tip)   # full model
anova(mod.full)
# Since the p-value of Tip = 0.0008713 < 0.05, we reject the null hypothesis that the hardness is
# the same for all types of tips. This indicates that there are significant differences in hardness
# among at least some of the different tips tested.

## d

# The mean hardness values calculated will give us insight into which tip is preferable. The tip with the highest mean hardness across all coupons would generally be considered the best option.

mean_hardness <- aggregate(Hardness ~ Tip, data = df, FUN = mean)
print(mean_hardness)

# Tip 4 has the highest mean of hardness, hence, it is the most preferable.
# 
# The Coupon factor has a very small p-value (4.52e-05 < 0.05). This suggests that different coupons (type 1 to 4) lead to significantly different hardness.
# 
# Using the fitted model from part (c) to estimate hardness for specific combinations:
  
# Estimate for Coupon 3 and Tip 2:
predicted_hardness_32 <- predict(mod.full, newdata = data.frame(Coupon = factor(3), Tip = factor(2)))
predicted_hardness_32

# Estimate for Coupon 1 and Tip 4:
predicted_hardness_14 <- predict(mod.full, newdata = data.frame(Coupon = factor(1), Tip = factor(4)))
predicted_hardness_14

## e

# To ignore the "Coupon" factor, we will perform a one-way ANOVA:
anova_mod2 <- aov(Hardness ~ Tip)
summary(anova_mod2)

# Ignoring Coupon factor leads to a wrong conclusion about the effect of Tip on Hardness. This test shows that the p-value of Tip = 0.22 > 0.05, so we do not reject the hypothesis that the hardness is the same for all types of tip, which is a wrong conclusion (as seen from part (b)).

# Exercise 3

## a
# Load the data
crops_data <- read.table("crops.txt", header = TRUE)
head(crops_data,5)

# We need to investigate if County and Related (and possibly their interaction) influence the crop yields without taking Size into account. We perform a two-way ANOVA, considering County and Related as factors and Crops as the response variable.

County <- factor(crops_data$County, 
                 levels = c(1, 2, 3, 4),
                 labels = c("C1", "C2", "C3", "C4"))
Related <- factor(crops_data$Related)
Size <- crops_data$Size
Crops <- crops_data$Crops
crop_df=data.frame(County,Related,Size,Crops)
crop_df
# Perform two-way ANOVA
mod.full=lm(Crops~County*Related)   # full model
anova(mod.full)
summary(mod.full)

# Make the prediction using the ANOVA model
county3_yes <- predict(mod.full, newdata = data.frame(County = 'C3', Related = "no"))
county3_yes

## b

# To investigate whether the influence of Size on Crops is similar across all three counties, we use the ANCOVA model with an interaction term between Size and County as below:

mod1=lm(Crops~Size*County+Related)
anova(mod1)

# The p-value for the interaction term Size:County is 0.01192 < 0.05, we can conclude that the relationship between farm size and crops is not the same across counties.

# To test if the influence of Size depends on the relation of landlord and tenant of the farm, we use the model with the interaction term between Size and Related.
mod2=lm(Crops~Size*Related+County)
anova(mod2)

# The interaction term has p-value = 0.2959 > 0.05, it suggests that the influence of Size
# on Crops is similar regardless of whether the landlord and tenant are related. We drop
# the interaction term to simplify the model as follows.

mod3=lm(Crops~Size+Related+County)
anova(mod3)
summary(mod3)

# We observe that not only the factor Related has no significant impact on the crops but
# also it does not have an interaction effect with Size or County. We will exclude it in the
# previous models.

mod4=lm(Crops~Size*County)
anova(mod4)
summary(mod4)

mod5=lm(Crops~Size+County)
anova(mod5)
summary(mod5)

# We will now choose the most appropriate model for this data by using:
anova(mod5,mod3,mod4, mod2, mod1)
# The result shows that Model 3: Crop ∼ Size * County has the lowest p-value, which
# means that using Model 3 did lead to a significantly improved fit over Model 1, 2, 4, 5.

## c

# Among 3 factors, only Size does have a significant impact on the crop yields because its
# p-value in all above ANCOVA models is less than 0.05. Moreover, the influence of Size
# depends on the County since the interaction term between these two factors is also below
# 0.05.

## d

# Use the final model from (b) to make predictions
county2_yes_165 <- predict(mod4, 
                           newdata = data.frame(County = "C2", Related = "yes", Size = 165))
county2_yes_165

# Extract the residual standard error (RSE)
rse <- summary(mod4)$sigma
# Estimate the error variance (sigma^2)
error_variance <- rse^2
error_variance

# Exercise 4
# Load the required libraries
library(MASS)      # For the Boston dataset
library(glmnet)    # For LASSO implementation

# Load the Boston dataset
data("Boston")

# Remove categorical variables 'chas' and 'rad'
boston_data <- Boston[, !(names(Boston) %in% c("chas", "rad"))]
head(boston_data,5)

# Set seed for reproducibility
set.seed(123)

# Define the response (medv) and predictor variables
response <- boston_data$medv
predictors <- as.matrix(boston_data[, -which(names(boston_data) == "medv")])

# Split the data into training and testing sets (70% train, 30% test)
train_indices <- sample(1:nrow(boston_data), nrow(boston_data) * 0.7)
train_x <- predictors[train_indices, ]
train_y <- response[train_indices]
test_x <- predictors[-train_indices, ]
test_y <- response[-train_indices]

# Fit LASSO model using cross-validation
lasso_model <- cv.glmnet(train_x, train_y, alpha = 1)  # alpha=1 indicates LASSO

# Lambda values
lambda_min <- lasso_model$lambda.min
lambda_1se <- lasso_model$lambda.1se

# Coefficients for the selected lambda
lasso_coefs <- coef(lasso_model, s = "lambda.1se")
print(lasso_coefs)

# crim, rm, dis, ptratio, black, lstat have non-zero coefficients, so they are relevant variables
# (among the remaining 11 variables) for predicting the response.

# Predict on the test data using the lambda.1se
lasso_pred <- predict(lasso_model, s = "lambda.1se", newx = test_x)

# Calculate Mean Squared Error (MSE) for LASSO
lasso_mse <- mean((lasso_pred - test_y)^2)
print(paste("LASSO Test MSE:", lasso_mse))

# Fit a full linear model
full_model <- lm(medv ~ ., data = boston_data[train_indices, ])

# Predict on the test data
full_pred <- predict(full_model, newdata = as.data.frame(test_x))

# Calculate Mean Squared Error (MSE) for full model
full_mse <- mean((full_pred - test_y)^2)
print(paste("Full Model Test MSE:", full_mse))