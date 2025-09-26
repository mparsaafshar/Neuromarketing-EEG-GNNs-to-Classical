# 🧠 Neuromarketing with EEG: Graph Neural Networks to Classical Models

## 🌟 Overview
This project explores how **EEG signals** can be used in a **neuromarketing** context to analyze and predict consumer behavior.  
We construct **brain connectivity graphs** from EEG data and apply **Graph Neural Networks (GNNs)** to classify whether a participant is likely to purchase a product.

---

## 🎯 Objectives
- Investigate the relationship between **EEG activity** and **consumer decisions**.
- Exploring a wide range of Machine Learning Models, such as Classical, Ensemble and GNN models.
- Extract **Brain Connectivity features**.
- Represent EEG data as **graphs** where nodes = electrodes and edges = connectivity strength.  
- Train and evaluate different **GNN architectures**.  

---

## 📊 Dataset
- NeuMa dataset have been used [1].(https://doi.org/10.1038/s41597-023-02392-9)

---

## 🧪 Methodology

1. **EEG Feature Extraction**  
   - Extracting the EEG FFT and PSD statistical and spectral features.
     
1. **EEG Preprocessing**  
   - Correlation Matrix, Standardization, Dimension Reduction.  

3. **Graph Construction**
   - Brain connectivity measures: Pearson Correlation
   -  Nodes = EEG electrodes  
   - Edges = connectivity measures (threshold-based or fully connected)  

5. **Modeling**  
   - Implemented models:  
     - Classical Models
     - Stacking Ensemble Model
     - Graph Neural Network Models

6. **Evaluation**  
   - Metrics: Accuracy, Recall, Precision and F1-score  


## 📚 References
- [1] Georgiadis, K., Kalaganis, F.P., Riskos, K. et al. NeuMa - the absolute Neuromarketing dataset en route to an holistic understanding of consumer behaviour. Sci Data 10, 508 (2023). https://doi.org/10.1038/s41597-023-02392-9



## 

### Installation
```bash
git clone https://github.com/username/neuromarketing-eeg-gnn.git
cd neuromarketing-eeg-gnn
pip install -r requirements.txt
