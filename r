---
title: "Predictive Analytics"
subtitle: "Linear Model"  
author: "Zhiyu (Frank) Quan"
institute: "University of Illinois Urbana-Champaign"
#date: "2022/04/01 (updated: `r Sys.Date()`)"
output:
  xaringan::moon_reader:
    css: xaringan-themer.css
    nature:
      slideNumberFormat: "%current%"
      highlightStyle: github
      highlightLines: trueå
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




### Linear Model in Machine Learning

- Traditional notation
$$\underline{Y}=\mathbf{X}\underline{\beta}+\underline{\epsilon}$$

$$\hat{y}_i=\hat\beta_0+\hat\beta_1x_{i1}+\hat\beta_2x_{i2}+\ldots + \hat\beta_px_{ip}$$

- New notation
$$\hat{y}_i=\hat{b}+\hat{w_1}x_{i1}+\hat{w_2}x_{i2}+\ldots + \hat{w_p}x_{ip}$$
$$\underline{\hat{Y}}=\mathbf{X}\underline{w}+\underline{b}$$


---

#### Loss Function

- Squared error

$$l_i(\underline{w}, \underline{b})=\frac{1}{2}(\hat{y}_i-y_i)^2$$
  - $\frac{1}{2}$ makes no real difference but will prove notationally convenient, i.e., canceling out when we take the derivative of the loss.
  
- Model loss 

$$L(\underline{w}, \underline{b})=\frac{1}{n}\sum_{i=1}^nl_i(\underline{w}, \underline{b})=\frac{1}{n}\sum_{i=1}^n\frac{1}{2}(\underline{w}^T\underline{x_i}+b-y_i)^2$$

---

#### Optimization

$$\hat{\underline{w}}, \hat{\underline{b}}=\arg\min_{\underline{w}, \underline{b}} L(\underline{w}, \underline{b})$$

---

#### Minibatch Stochastic Gradient Descent

- Gradient descent: the technique is iteratively reducing the error by updating the parameters in the direction that incrementally lowers the loss function.
  - The naive gradient descent consists of taking the derivative of the loss function.
  - This can be extremely slow when we have a large dataset since we must pass over the entire dataset before making a single update.
- Minibatch stochastic gradient descent
  - Each iteration, sampling a random minibatch of the dataset.
  - Compute and update parameters using this small random sample.

---

#### Formulation

$$(\underline{w}, \underline{b})_k \leftarrow (\underline{w}, \underline{b})_{k-1} - \frac{\eta}{|\mathcal{B}|} \sum_{i \in \mathcal{B}} \frac{\partial l_i(\underline{w}, \underline{b})}{\partial{(\underline{w}, \underline{b})}}.$$
where a minibatch $\mathcal{B}$ sample with size $|\mathcal{B}|$. Here $\eta$ is a fixed positive value called the **learning rate**.

- Initialize the values of the model parameters, typically at random, cold start.
- Iteratively sample random minibatches from the training dataset, updating the model parameters in the direction of the negative gradient. 

---

$$\begin{aligned} \underline{w}_k &\leftarrow \underline{w}_{k-1} -   \frac{\eta}{|\mathcal{B}|} \sum_{i \in \mathcal{B}} \frac{\partial l_i(\underline{w}, \underline{b})}{\partial{(\underline{w})}} = \underline{w}_{k-1} - \frac{\eta}{|\mathcal{B}|} \sum_{i \in \mathcal{B}} \underline{x_i} \left(\underline{w}^T\underline{x_i}+b-y_i\right),\\ 
b_k &\leftarrow b_{k-1} - \frac{\eta}{|\mathcal{B}|} \sum_{i \in \mathcal{B}} \frac{\partial l_i(\underline{w}, \underline{b})}{\partial{(\underline{b})}}  = b_{k-1} - \frac{\eta}{|\mathcal{B}|} \sum_{i \in \mathcal{B}} \left(\underline{w}^T\underline{x_i}+b-y_i\right). \end{aligned}$$

- Model training for some predetermined number of iterations or until other stopping criteria is met.
- The algorithm converges slowly towards the minimizers.
- Even if the relationship between the response variable and explanatory variables is truly linear and noiseless, these parameters will not be the exact minimizers of the loss since they cannot achieve it precisely in a finite number of steps. 
- Linear regression happens to be, luckily, a learning problem with only one minimum over the entire domain.

---

#### Maximum Likelihood Estimation

- Assume the noise is normally distributed as follows
$$y_i = \underline{w}^T\underline{x_i}+b + \epsilon \text{ where } \epsilon \sim \mathcal{N}(0, \sigma^2).$$
- Then likelihood function

$$p(y_{i}|\underline{x_i})= \frac{1}{\sqrt{2 \pi \sigma^2}} \exp\left(-\frac{1}{2 \sigma^2} (y_i - \underline{w}^T\underline{x_i}-b)^2\right)$$

---

- Maximize the likelihood of the entire dataset:
$$P(\underline{Y} \mid \mathbf{X}) = \prod_{i=1}^{n} p(y_{i}|\underline{x_i})$$
- Same as minimize the negative log-likelihood:

$$-\log P(\underline{Y} \mid \mathbf{X}) = \sum_{i=1}^n \frac{1}{2} \log(2 \pi \sigma^2) + \frac{1}{2 \sigma^2} \left(y_i - \underline{w}^T\underline{x_i}-b\right)^2.$$
- $\sigma$ is some fixed constant, then the first term is constant.
- the second term is identical to the squared error loss.

---

Minimizing the mean squared error is equivalent to the maximum likelihood estimation of a linear model under the assumption of additive Gaussian noise.









