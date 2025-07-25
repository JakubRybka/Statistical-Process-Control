# Load PCB measurement data from CSV file
PCB <- read.csv("Data.csv", sep = ";", dec = ",")

# Number of measurements per sample
n <- 3

# Calculate the mean and range (max - min) for each sample
Ms <- tapply(PCB$Measurement, INDEX = PCB$Sample, FUN = mean)
Rs <- tapply(PCB$Measurement, INDEX = PCB$Sample, FUN = function(x) max(x) - min(x))

# Total number of samples
m <- length(Ms)

# Average of sample ranges
R.mean <- mean(Rs)

# Constants for control chart with n = 3
d2 <- 1.693
d3 <- 0.888

# Compute R-chart control limits
UCL.R.mean <- R.mean + 3 * d3 * R.mean / d2
LCL.R.mean <- max(0, R.mean - 3 * d3 * R.mean / d2)  # Cannot be negative

# Compute X̄-chart control limits
x.mean <- mean(Ms)  # Center line
UCL.x.mean <- x.mean + 3 / (d2 * sqrt(n)) * R.mean
LCL.x.mean <- x.mean - 3 / (d2 * sqrt(n)) * R.mean

# Output control chart parameters
cat("Control charts parameters\nX-chart:\n",
    "Upper Control Limit:", UCL.x.mean, "\n",
    "Center Line:", x.mean, "\n",
    "Lower Control Limit:", LCL.x.mean, "\n")

cat("R-chart:\n",
    "Upper Control Limit:", UCL.R.mean, "\n",
    "Center Line:", R.mean, "\n",
    "Lower Control Limit:", LCL.R.mean, "\n")

# Plot X̄ chart
plot(Ms, pch = 19, ylim = c(0.0615, 0.065),
     xlab = "Sample number", ylab = "Sample mean", main = "X̄ Chart")
lines(1:m, Ms)
abline(h = c(LCL.x.mean, x.mean, UCL.x.mean), lty = c(2, 1, 2))

# Plot R chart
plot(Rs, pch = 19, ylim = c(0, 0.003),
     xlab = "Sample number", ylab = "Sample range", main = "R Chart")
lines(1:m, Rs)
abline(h = c(LCL.R.mean, R.mean, UCL.R.mean), lty = c(2, 1, 2))

# Identify out-of-control points
x.mean_ooc <- which(Ms < LCL.x.mean | Ms > UCL.x.mean)
R.mean_ooc <- which(Rs < LCL.R.mean | Rs > UCL.R.mean)
ooc <- unique(c(x.mean_ooc, R.mean_ooc))  # Out-of-control sample indices

# Remove out-of-control points
Ms.clean <- Ms[-ooc]
Rs.clean <- Rs[-ooc]

# Recalculate means from cleaned data
x.mean.clean <- mean(Ms.clean)
R.mean.clean <- mean(Rs.clean)

# Cleaned control limits
UCL.R.mean.clean <- R.mean.clean + 3 * d3 * R.mean.clean / d2
LCL.R.mean.clean <- max(0, R.mean.clean - 3 * d3 * R.mean.clean / d2)

UCL.x.mean.clean <- x.mean + 3 / (d2 * sqrt(n)) * R.mean.clean
LCL.x.mean.clean <- x.mean - 3 / (d2 * sqrt(n)) * R.mean.clean

# Output cleaned control chart parameters
cat("\nCleaned Control charts parameters\nX-chart:\n",
    "Upper Control Limit:", UCL.x.mean.clean, "\n",
    "Center Line:", x.mean.clean, "\n",
    "Lower Control Limit:", LCL.x.mean.clean, "\n")

cat("R-chart:\n",
    "Upper Control Limit:", UCL.R.mean.clean, "\n",
    "Center Line:", R.mean.clean, "\n",
    "Lower Control Limit:", LCL.R.mean.clean, "\n")

# Estimate process standard deviation
mu <- x.mean.clean
sigma <- R.mean.clean / d2
cat("Estimated standard deviation:", sigma, "\n")

# Specification limits
USL <- 0.0645
LSL <- 0.0615

# Process capability indices
Cp <- (USL - LSL) / (6 * sigma)
Cpk <- min((USL - x.mean.clean) / (3 * sigma), (x.mean.clean - LSL) / (3 * sigma))
cat("Process capability estimates\nCp:", Cp, "\nCpk:", Cpk, "\n")

# Defective parts per million (PPM)
p_total <- pnorm(LSL, mean = mu, sd = sigma) + (1 - pnorm(USL, mean = mu, sd = sigma))
ppm_total_out <- p_total * 1e6
cat("Defective parts per million (PPM):", ppm_total_out, "\n")

# Plot cleaned X̄ chart
plot(Ms.clean, pch = 19, ylim = c(0.0615, 0.065),
     xlab = "Sample number", ylab = "Sample mean", main = "Cleaned X̄ Chart")
lines(1:length(Ms.clean), Ms.clean)
abline(h = c(LCL.x.mean.clean, x.mean.clean, UCL.x.mean.clean), lty = c(2, 1, 2))

# Plot cleaned R chart
plot(Rs.clean, pch = 19, ylim = c(0, 0.003),
     xlab = "Sample number", ylab = "Sample range", main = "Cleaned R Chart")
lines(1:length(Rs.clean), Rs.clean)
abline(h = c(LCL.R.mean.clean, R.mean.clean, UCL.R.mean.clean), lty = c(2, 1, 2))
