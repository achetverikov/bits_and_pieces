library(cmdstanr)
library(circular)

options("mc.cores" = 4)

# small function for angle distances
angle_dist_rad<-function(a,b){
  c = a - b
  (c+pi)%%(2*pi) - pi
}

# two models we are going to use, either using same precision for targets and distractors (as the original model assumes) or not
model <- cmdstan_model('unbiased_mix_with_swaps.stan') # compiles model with different precision
model_same_kappa <- cmdstan_model('unbiased_mix_with_swaps_same_kappas.stan') # compiles model with the same precision

# simulation parameters
sample_n <- 600 # sample size
p_guess <- 0.05 # prob. of guesses
p_swap <- 0.1 # prob. of swaps
mu_target <- 0 # target mean
k_target <- 60 # target precision (kappa)
mu_distractor <- pi/2 # distractor mean
k_distractor <- 35 # distractor precision

# laten variable for allocation
z <- sample(c('T','D','G'), sample_n, replace = T, prob = c(1-p_guess-p_swap, p_swap, p_guess))
table(z)

# sample data (using as.vector to get rid of the circular class)
x <- as.vector(rvonmises(sample_n, mu_target, k_target))
x[z == 'D'] <- as.vector(rvonmises(sum(z=='D'), mu_distractor, k_distractor))
x[z == 'G'] <- as.vector(rcircularuniform(sum(z=='G')))
hist(angle_dist_rad(x,0))

# format data for Stan
stan_data <- list(N = sample_n, Y = x, con_theta = c(0.6, 0.3, 0.1), mu = c(mu_target, mu_distractor))
fit <- model$sample(stan_data)
fit$summary() # OK for the target, swaps and biases are somewhat merged 

fit_same_kappa <- model_same_kappa$sample(stan_data)
fit_same_kappa$summary()

# as a comparison - unconstrained 3-component model
summary(BAMBI::fit_vmmix(x, ncomp = 3, show.progress = F))
