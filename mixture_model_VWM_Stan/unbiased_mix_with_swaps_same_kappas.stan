// generated with brms 2.14.4
functions {
}
data {
  int<lower=1> N;  // total number of observations
  vector[N] Y;  // response variable
  vector[3] con_theta;  // prior concentration
  vector[2] mu; // means of Target and Distractors
}
transformed data {
}
parameters {
  real<lower=0> kappa;  // kappa target and distractors
  simplex[3] theta;  // mixing proportions
}
transformed parameters {
}
model {
  // likelihood including all constants
    // initialize linear predictor term
    vector[N] mu1 = mu[1] + rep_vector(0.0, N);
    // initialize linear predictor term
    vector[N] mu2 = mu[2] + rep_vector(0.0, N);
    // likelihood of the mixture model
    for (n in 1:N) {
      real ps[3];
      if (kappa < 100) {// see https://mc-stan.org/docs/2_22/functions-reference/von-mises-distribution.html
        ps[1] = log(theta[1]) + von_mises_lpdf(Y[n] | mu1[n], kappa);
        ps[2] = log(theta[2]) + von_mises_lpdf(Y[n] | mu2[n], kappa);
      }
      else {
        ps[1] = log(theta[1]) + normal_lpdf(Y[n] | mu1[n], sqrt(1/kappa));
        ps[2] = log(theta[2]) + normal_lpdf(Y[n] | mu2[n], sqrt(1/kappa));
      }
      ps[3] = log(theta[3]) +  uniform_lpdf(Y[n] | -pi(), pi());
      target += log_sum_exp(ps);
    }
  // priors including all constants
  //target += normal_lpdf(Intercept_mu1 | 0, 40);
  target += student_t_lpdf(kappa | 3, 0, 40);
  target += dirichlet_lpdf(theta | con_theta);
}
generated quantities {
}

