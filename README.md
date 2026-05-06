# Convolutionally Low-Rank Models with Modified Quantile Regression for Interval Time Series Forecasting

## Data

The `./data` folder consists of the M4 training and test sets, along with the M4-small series indices for analyzing the impact of $\lambda$.

## Main Programs

- `testM4_PIs.m`: main program for the M4 dataset.
- `test_datasets.m`: main program for the Electricity or Traffic dataset.

## Ablation Studies

- `inexact_alm_LbCNNM_1D_quantile.m`: can be used to switch between LbCNNM-QR and LbCNNM-MQR.
- `LbCNNM_CP.m`: LbCNNM-CP.
