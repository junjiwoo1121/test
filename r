---
title: "Predictive Analytics"
subtitle: "Data Preprocessing"  
author: "Zhiyu (Frank) Quan"
institute: "University of Illinois Urbana-Champaign"
#date: "2022/04/01 (updated: `r Sys.Date()`)"
output:
  xaringan::moon_reader:
    css: xaringan-themer.css
    nature:
      slideNumberFormat: "%current%"
      highlightStyle: github
      highlightLines: true
      ratio: 16:9
      countIncrementalSlides: true
---

```{r setup, include=FALSE}
options(htmltools.dir.version = FALSE)
knitr::opts_chunk$set(
  fig.width=9, fig.height=3.5, fig.retina=3,
  out.width = "100%",
  cache = FALSE,
  echo = TRUE,
  message = FALSE, 
  warning = FALSE,
  hiline = TRUE
)
```

```{r xaringan-themer, include=FALSE, warning=FALSE}
library(xaringanthemer)
style_duo_accent(
  primary_color = "#13294B",
  secondary_color = "#DD3403",
  inverse_header_color = "#00000",
  text_font_size = "27px",
)

```


### Standardization and Normalization for Numerical Data

<img align="right" src="image/University-Wordmark-Full-Color-CMYK.jpg" alt="fig1" width="200" height="500" /> 

Feature scaling
- Algorithms that compute the distance between the features are biased towards numerically larger values if the data is not scaled.
- Some algorithms are fairly insensitive to the scale of the features, e.g., tree-based algorithms.
- Feature scaling helps algorithms train and converge faster, e.g., deep learning.

---

<img align="right" src="image/University-Wordmark-Full-Color-CMYK.jpg" alt="fig1" width="200" height="500" /> 

Min-max normalization: linearly map to a new minimum $a$ and maximum $b$


$$X_{new} = \frac{X-X_{min}}{X_{max}-X_{min}}(b-a)+a$$
- Not ideal when we have outliers

---

<img align="right" src="image/University-Wordmark-Full-Color-CMYK.jpg" alt="fig1" width="200" height="500" /> 

Standardization or Z-Score Normalization:

$$X_{new} = \frac{X-X_{mean}}{X_{Std}}$$

- Changing mean and standard deviation to a standard normal distribution which is still normal thus the shape of the distribution is not affected.
- Not get affected by outliers because there is no predefined range of transformed features.

---

<img align="right" src="image/University-Wordmark-Full-Color-CMYK.jpg" alt="fig1" width="200" height="500" /> 

Decimal scaling

$$X_{new} = \frac{X}{{10}^k}$$
where $k$ is smallest integer such that $max(|X_{new}|) \le 1$

---

<img align="right" src="image/University-Wordmark-Full-Color-CMYK.jpg" alt="fig1" width="200" height="500" /> 

$L^k$ Norm Normalization

$$
X_{new} = \frac{X}{||X||_k}
$$
where $||X||_k=\sqrt{X_1^k+X_2^k+...+X_n^k}$.

---

<img align="right" src="image/University-Wordmark-Full-Color-CMYK.jpg" alt="fig1" width="200" height="500" /> 

Power transformations

$$
X^{(\lambda)}_{new} =
\begin{cases}
 \dfrac{X^\lambda - 1}{\lambda} & \text{if } \lambda \neq 0, \\
 \ln X & \text{if } \lambda = 0,
\end{cases}
$$

---

### Bining for Numerical Data

<img align="right" src="image/University-Wordmark-Full-Color-CMYK.jpg" alt="fig1" width="200" height="500" /> 

- Combine specific ranges to reduce level/numerical range.
- Losing information.
- May speed up the training process.

---

### Encoding for Categorical Data

<img align="right" src="image/University-Wordmark-Full-Color-CMYK.jpg" alt="fig1" width="200" height="500" /> 

- One-hot encoding
- Deep learning
- Cartesian product of two or more features

---

### Other

<img align="right" src="image/University-Wordmark-Full-Color-CMYK.jpg" alt="fig1" width="200" height="500" /> 

- Date and Time
- Currency
- Special symbols




