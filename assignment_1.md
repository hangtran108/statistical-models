# Assignment 1

**Question 1: Theoretical exercise**

Three competing factories (Factory 1, Factory 2 and Factory 3) produce the same type of steel cable using different manufacturing processes. The raw material used to construct the cable comes from two different locations (Location 1 and Location 2). At each of the three factories, 10 spools of cable made of material coming from Location 1 and 10 spools of cable made of material coming from Location 2 were randomly selected. Each spool was subjected to a strength test that involved increasing the weight on the cable until it broke. For each spool, the critical weight (in kg) on the cable at the moment it broke was recorded as variable Weight in data frame data which also contains two corresponding factor columns Location and Factory. The data frame itself is not provided for this theoretical exercise, but you can (and should) use R for computations. Suppose the following ANOVA model is constructed in R: `model=lm(Weight~Location*Factory,data)`

The partial output of the R-command anova(model) is given below:
![image](https://github.com/user-attachments/assets/3fc095c4-c9c2-4875-bc63-57f7ac345b5c)

a) If possible, provide the missing information in the above R-output. What is the studied model (and possible restrictions) here? By using this R-output (with recovered entries), draw a conclusion for that model (if possible).

b)  For the above ANOVA model, can you also recover the estimator $\sigma^2$, $R^2$, adjusted $R^2$? If possible, compute these quantities; if not, explain why not.

   c)  For the above ANOVA model, determine the sums of squares  $S_{\Omega}$ and $S_{\Omega_{AB}}$. Compute $E(2S_{\Omega_{AB}} - 3S_{\Omega})$ and $Var(2S_{\Omega_{AB}} - 3S_{\Omega})$ in terms of the error variance $\sigma^2$.

   d)  Is it possible to carry out an additive two-way ANOVA, a one-way ANOVA, and to decide which model is most relevant? If yes, carry out the relevant test(s).

   e)  Suppose $\sigma^2$=800 is known. Can you propose new (presumably better) tests for the problems in a) and d)? If possible, perform these tests; if not, explain why not.

 ---
**Question 2: Computational exercises**

_Whenever appropriate, use relevant diagnostic tools to check the model assumptions._

A hardness testing machine operates by pressing a tip into a metal test “coupon”. The hardness of the coupon can be determined from the depth of the resulting depression. Four tip types are being tested to see if they produce significantly different readings. The coupons might differ slightly in their hardness (for example, if they are taken from ingots produced in different heats). Thus coupon is a nuisance factor, which should in principle be taken into account. Such type of analysis (combination of factor(s) of importance and block factor(s) to be taken into account) is called randomized block design.

 Since coupons are large enough to test four tips on, a randomized block design can be used, with coupon as block. Four blocks were used. Within each block (coupon) the order in which the four tips were tested was randomly determined. The results (readings on a certain hardness scale) are shown in the below table.

 ![image](https://github.com/user-attachments/assets/21ba36b2-2607-4b53-83c1-891c41e8be62)


  a) Suppose you were to set up this experiment: propose an R-function which creates a random order of 16 tests covering all the combinations of levels of the two factors in a randomized block design.

From now on work with the above data.

   b)  Make some graphical summaries of the data and give some tentative comments. What can you say about eventual interaction between Coupon and Tip?

   c)  Test the null hypothesis that the hardness is the same for all types of tip.

   d)  Which type of tip is preferable? How does the hardness depend on the type coupon? Estimate the hardness of coupon of type 3 one uses a tip of type 2, do the same for coupon of type 1 and a tip of type 4.

   e)  Test the null hypothesis that the hardness is the same for all types of tip, now ignoring the variable Coupon. Is it right/wrong and useful/not useful to perform this test on this dataset?

 ---

**Question 3:**

In each of the three counties in Iowa, a sample of farm was taken from farms for which landlornd and tenant are related and also from farms for which landlord and tenant are not related. The data is contained in data frame crops.txt Download crops.txt, where column Crops contains the value of crops, column Size the size of farm, column County the county and column Related reflects the fact whether landlord and tenant related (value “yes”) or no (value “no”). We are primarily interested in investigating the effect of county and relation of landlord and tenant on the crops.

   a)  Investigate whether two factors County and Related (and possibly their interaction) influence the crops by performing relevant ANOVA model(s), without taking Size into account. Using a chosen model, estimate the crops for a typical farm in County 3 for which landlord and tenant are not related. Comment on your findings.

   b)  Now include also Size as explanatory variable into the analysis. Investigate whether the influence of Size on Crops is similar for all three counties and whether the influence of Size depends on the relation of landlord and tenant of the farm. (Consider at most one (relevant) pairwise interaction per model.) Choose the most appropriate model. Comment.

   c)  For the resulting model from b), investigate how County, Related and Size influence Crops, Comment.

   d)  Using the resulting model from b), predict the crops for for a farm from County 2 of size 165, with related landlord and tenant. Estimate also the error variance.

---

**Question 4:**

The dataset Boston contains information collected from the US Census about housing in the suburbs of Boston. The data is available in the MASS package (execute library(MASS) to load and attach the package). It contains n=506 observations and 14 columns (variables/features) measured on the census districts of the Boston metropolitan area, like average number of rooms (rm), per capita crime rate (crim), etc.; for the full list see the description of the dataset in R. Remove from the consideration two categorical variables chas and rad and treat the variable medv as response.

Apply the LASSO method along the lines outlined in the lecture to select the relevant variables (among the remaining 11 variables) for predicting the response medv (median value of owner-occupied homes in $1000s) with default parameters as in the lecture and lambda=lambda.1se. Compare the prediction by the selected LASSO model with that by the full linear model. Comment. (You will need to install the R-package glmnet, which is not included in the standard distribution of R. Also beware that in general a new run may deliver a new model because of a new train set.)

