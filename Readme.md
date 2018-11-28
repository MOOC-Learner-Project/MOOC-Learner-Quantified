# MOOC-Learner-Quantified

Quantifies the MOOC learner behavior with MOOC-Learner-Quantified (MLQ)

# Requirements 

<a href="https://www.python.org/" ><img src="https://img.shields.io/badge/Python-blue.svg"></a> <a href="https://www.mysql.com/" ><img src="https://img.shields.io/badge/MySQL-blue.svg"></a> 

<a href="https://www.docker.com/" ><img src="https://img.shields.io/badge/Docker-blue.svg"></a> 

(see [MOOC-Learner-Docker/quantified_base_img](https://github.com/MOOC-Learner-Project/MOOC-Learner-Docker/tree/master/quantified_base_img) )

## Technologies

<a href="https://www.pandas.pydata.org/" ><img src="https://img.shields.io/badge/Pandas-blue.svg"></a>
<a href="https://www.matplotlib.org/" ><img src="https://img.shields.io/badge/Matplotlib-blue.svg"></a>
<a href="https://www.numpy.org/" ><img src="https://img.shields.io/badge/Numpy-blue.svg"></a>
<a href="https://www.scipy.org/" ><img src="https://img.shields.io/badge/Scipy-blue.svg"></a>
<a href="https://scikit-learn.org/stable/index.html" ><img src="https://img.shields.io/badge/Scikitlearn-blue.svg"></a>

# Installation

See [MOOC-Learner-Docker](https://github.com/MOOC-Learner-Project/MOOC-Learner-Docker/tree/master/README.md)

# Tutorial

Entry point is `autorun.py`. Configuration is done with `config/*yml`, see e.g. `config/sample_config.yml`.

Two steps of adding a new feature extraction script to MLQ 
- Add an entry to the
- Add a MySQL script to

# Feature Tables

Each feature table is describing one or multiple objects, where objects include but are not limited to user, video, 
problem, forum threads. There are two types of feature tables, longitudinal and non-longitudinal ones. If we split a 
feature by the number of week it belongs to in a course, we get longitudinal features. Only user longitudinal feature 
table is useful for dropout prediction. But visualization can work on all feature tables and non-longitudinal features 
may provide more meaningful plots than longitudinal ones.

## Existing features

Scripts for extracting features are in `feature_populate/scripts`. Features are described in [docs/README.md](docs/README.md)


