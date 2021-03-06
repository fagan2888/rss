function [alpha, mu, SiRiSr] = rss_varbvsr_update(SiRiS, sigma_beta, logodds, betahat, se, alpha0, mu0, SiRiSr0, I)
% USAGE: run a single full iteration of mean-field variational approximation to fit RSS-BVSR model
% INPUT:
%	SiRiS: inv(S)*R*inv(S), double precision sparse matrix (CCS format), p by p
%	sigma_beta: prior SDs of regression coefficients (if included), p by 1 or scalar
%	logodds: log(prior PIP/(1-prior PIP)) of inclusion for each SNP, p by 1 or scalar
%	betahat: effect size estimates under single-SNP model, p by 1
%	se: standard errors of betahat, p by 1
%	alpha0 and mu0: current values of variational parameters, both p by 1
%	SiRiSr0: inv(S)*R*inv(S)*r0, r0 = alpha0 .* mu0, p by 1
%	I: the order in which coordinates (SNPs) are updated in this iteration, p by 1 
% OUTPUT:
%	alpha and mu: updated values of variational parameters, both p by 1
%	SiRiSr: inv(S)*R*inv(S)*r, r0 = alpha .* mu, p by 1

  % Get the number of SNPs (p).
  p = length(betahat);

  % Check input SiRiS.
  % SiRiS := inv(S)*R*inv(S) must be a sparse matrix.
  if ~all(size(SiRiS) == [p p])
    error('Input SiRiS must be a squared matrix of size p.');
  end
  if ~issparse(SiRiS)
    error('Input SiRiS must be a sparse matrix.')
  end

  % Check inputs sigma_beta.
  if length(sigma_beta) ~= p
    error('Input sigma_beta must be scalar or a vector of length p.');
  end

  % Check input logodds.
  if length(logodds) ~= p
    error('Input logodds must be scalar or a vector of length p.');
  end

  % Check inputs alpha0 and mu0.
  if length(alpha0) ~= p || length(mu0) ~= p
    error('Inputs alpha0 and mu0 must be vectors of length p.');  
  end

  % Check input SiRiSr0.
  if length(SiRiSr0) ~= p
    error('Input SiRiSr0 must be a vector of length p.');
  end

  % Check input se.
  if length(se) ~= p
    error('Input se must be a vector of length p.');
  end

  % Check input I.
  if length(I) ~= p
    error('Input I must be a vector of length p.');
  end
  if sum(I < 1 | I > p)
    error('Input I contains invalid variable indices');
  end

  % Execute the C routine. We need to subtract 1 from the indices I
  % because MATLAB arrays start at one, but C arrays start at zero.
  [alpha, mu, SiRiSr] = rss_varbvsr_update_matlab(SiRiS, double(sigma_beta), double(logodds),...
			double(betahat), double(se), double(alpha0),double(mu0),double(SiRiSr0),double(I-1));

end
