# Elephant Distribution Modelling Using the MaxEnt Model Under Climate Change

## Overview

This project applies a species distribution modelling (SDM) approach to analyse the current and future spatial distribution of elephants under changing climatic conditions. The analysis is implemented in R using the Maximum Entropy (MaxEnt) algorithm and bioclimatic variables derived from climate datasets.

The workflow integrates species occurrence data, background sampling, environmental predictors, and climate change projections to estimate habitat suitability under present conditions and future climate scenarios.

## Species Distribution Modelling Framework

Species distribution modelling aims to characterise the relationship between species occurrence and environmental conditions in order to predict suitable habitats across space and time. In this study, the MaxEnt algorithm is used due to its effectiveness with presence-only data and its widespread application in ecological modelling.

MaxEnt estimates the probability distribution of a species by finding the distribution of maximum entropy subject to environmental constraints derived from known occurrence locations.

## Occurrence and Background Data

Species occurrence data are provided as geographic point locations within Machakos County, Kenya. These points represent observed presence locations used to train and evaluate the model.

To contrast environmental conditions at presence locations, background points are randomly sampled from the study area. These points represent available environmental space and allow the model to distinguish suitable from unsuitable conditions.

Occurrence data are split into training (70%) and testing (30%) subsets to enable model evaluation.

## Environmental Predictors

The model uses a suite of 19 bioclimatic variables representing temperature and precipitation patterns. These variables capture biologically meaningful aspects of climate such as seasonality, extremes, and variability.

Two sets of predictors are used:

- **Current climate variables**, representing present-day conditions.
- **Future climate projections**, representing climatic conditions under a projected climate change scenario.

All predictor layers are stacked and spatially aligned to ensure consistency during model fitting and prediction.

## Model Training and Prediction

The MaxEnt model is trained using the occurrence points and background samples, with bioclimatic variables as predictors. Response curves are generated to examine the relationship between environmental variables and habitat suitability.

Once trained, the model is used to:

1. Predict current habitat suitability across Machakos County.
2. Project habitat suitability under future climate conditions.

Predictions are produced as continuous raster surfaces representing relative suitability values.

## Model Evaluation

Model performance is evaluated using both training and testing datasets. Evaluation metrics are derived using independent presence and background samples to assess the model’s ability to discriminate between suitable and unsuitable conditions.

This evaluation step helps identify potential overfitting and provides confidence in the robustness of the predictions.

## Climate Change Projection

Future species distribution is modelled by applying the trained MaxEnt model to projected bioclimatic variables. This approach assumes that the species–environment relationship remains stable while climate conditions change.

The resulting maps illustrate potential shifts in suitable habitat under future climatic conditions, highlighting areas of increased or decreased suitability.

## Visualisation

Habitat suitability outputs are visualised as continuous maps using a graded colour scale. County boundaries are overlaid to provide geographic context. Current and future suitability maps are displayed side by side to facilitate direct comparison and interpretation of climate-driven changes.

## Interpretation

Areas with higher predicted suitability values represent locations with environmental conditions more closely matching those observed at known occurrence sites. Differences between current and future maps indicate potential range shifts or changes in habitat suitability driven by climate change.

These outputs should be interpreted as relative suitability patterns rather than exact predictions of species presence.

## Applications

This workflow supports:

- Wildlife habitat suitability analysis  
- Climate change impact assessment  
- Conservation planning and prioritisation  
- Ecological risk and vulnerability studies  

The approach is transferable to other species and regions with appropriate occurrence data and environmental predictors.

## Author

Mary Muthee  
Geospatial Data Scientist  
