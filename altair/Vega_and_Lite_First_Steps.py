
# coding: utf-8

# In[3]:


import pandas as pd

df = pd.read_json('cars.json')


# In[5]:


df.head()


# In[7]:


from vega import VegaLite


# In[8]:


VegaLite({
  "mark": "point",
  "encoding": {
    "y": {"type": "quantitative","field": "Acceleration"},
    "x": {"type": "quantitative","field": "Horsepower"}
  }
}, df)


# In[18]:


geo_df = pd.read_csv('unemployment.tsv', sep='\t')


# In[20]:


geo_df.head()


# In[24]:


map_spec = {
  "mark": "geoshape",
  "width": 600,
  "height": 400,
  "projection": {
    "type": "albersUsa"
  },
  "data": {
        "url": "data/us-10m.json",
        "format": {
              "type": "topojson",
              "feature": "states"
                }
          }
}

VegaLite(vega_spec)

