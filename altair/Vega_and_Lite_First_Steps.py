
# coding: utf-8

# In[1]:


import pandas as pd

df = pd.read_json('cars.json')


# In[2]:


df.head()


# In[3]:


from vega import VegaLite


# In[4]:


VegaLite({
  "mark": "point",
  "encoding": {
    "y": {"type": "quantitative","field": "Acceleration"},
    "x": {"type": "quantitative","field": "Horsepower"}
  }
}, df)


# In[5]:


geo_df = pd.read_csv('unemployment.tsv', sep='\t')


# In[6]:


geo_df.head()


# In[7]:


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

VegaLite(map_spec)

