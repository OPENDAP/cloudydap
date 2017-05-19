
Copyright (C) 2017 The HDF Group

This example code illustrates how to access and visualize LP DAAC MCD15A2H Sinusoidal Grid via OPeNDAP in Python.

If you have any questions, suggestions, or comments on this example, please use the HDF-EOS Forum (http://hdfeos.org/forums).

If you would like to see an example of any other NASA HDF/HDF-EOS data product that is not listed in the HDF-EOS Comprehensive Examples page (http://hdfeos.org/zoo), feel free to contact us at eoshelp@hdfgroup.org or post it at the HDF-EOS Forum (http://hdfeos.org/forums).

Tested under: Python 3.6.0 :: Anaconda custom (x86_64)

Last updated: 2017-5-18

This example demonstrates ArcGIS Online Python interface. Since we don't have a full ArcGIS license and subscription, we demonstrate the very basic capability that ArcGIS provides for free trial account. 


```python
from arcgis.gis import GIS
import pandas
import getpass
# Use pip to install pydap for Anaconda3.
from pydap.client import open_url, open_dods
from pydap.cas.urs import setup_session
import numpy as np
import csv
```


```python
server = 'https://eosdap.hdfgroup.org:8080/opendap/hyrax/data/NASAFILES/hdf4/'
file = 'MCD15A2H.A2017121.h31v11.006.2017135142112.hdf'
url = server + file
dataset = open_url(url)
latitude = dataset['Latitude'][:]
longitude = dataset['Longitude'][:]
data = dataset['Lai_500m'][:]
lat = np.ravel(latitude)
lon = np.ravel(longitude)
d = np.ravel(data)
```


```python
# ArcGIS Online allows only 250 address locations.
a = np.column_stack((lat[0:250], lon[0:250], d[0:250]))
# print(a)
np.savetxt("MCD15A2H.csv", a, delimiter=",", header="Latitude,Longitude,Lai500m", comments='')
```


```python
# Enter your username and password if you subscribe ArcGIS Online.
# gis = GIS("https://www.argis.com", "arcgis_python", "P@ssword123")

# Let's use anonymous. 
gis = GIS()
```


```python
# ArcGIS Online supports CSV upload. Upload this file to create map using web interface.
csv_file = 'MCD15A2H.csv'
# Ideally, you should be able to upload the CSV file to ArcGIS Online with Python interface. 
# However, free trial account that we have does not work.
# csv_item = gis.content.add({}, csv_file)
mcd_df = pandas.read_csv('MCD15A2H.csv')
mcd_df
```




<div>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>Latitude</th>
      <th>Longitude</th>
      <th>Lai500m</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>-20.002083</td>
      <td>138.347158</td>
      <td>5.0</td>
    </tr>
    <tr>
      <th>1</th>
      <td>-20.002083</td>
      <td>138.351593</td>
      <td>5.0</td>
    </tr>
    <tr>
      <th>2</th>
      <td>-20.002083</td>
      <td>138.356027</td>
      <td>4.0</td>
    </tr>
    <tr>
      <th>3</th>
      <td>-20.002083</td>
      <td>138.360461</td>
      <td>4.0</td>
    </tr>
    <tr>
      <th>4</th>
      <td>-20.002083</td>
      <td>138.364895</td>
      <td>5.0</td>
    </tr>
    <tr>
      <th>5</th>
      <td>-20.002083</td>
      <td>138.369329</td>
      <td>5.0</td>
    </tr>
    <tr>
      <th>6</th>
      <td>-20.002083</td>
      <td>138.373763</td>
      <td>4.0</td>
    </tr>
    <tr>
      <th>7</th>
      <td>-20.002083</td>
      <td>138.378197</td>
      <td>5.0</td>
    </tr>
    <tr>
      <th>8</th>
      <td>-20.002083</td>
      <td>138.382632</td>
      <td>5.0</td>
    </tr>
    <tr>
      <th>9</th>
      <td>-20.002083</td>
      <td>138.387066</td>
      <td>4.0</td>
    </tr>
    <tr>
      <th>10</th>
      <td>-20.002083</td>
      <td>138.391500</td>
      <td>5.0</td>
    </tr>
    <tr>
      <th>11</th>
      <td>-20.002083</td>
      <td>138.395934</td>
      <td>5.0</td>
    </tr>
    <tr>
      <th>12</th>
      <td>-20.002083</td>
      <td>138.400368</td>
      <td>5.0</td>
    </tr>
    <tr>
      <th>13</th>
      <td>-20.002083</td>
      <td>138.404802</td>
      <td>6.0</td>
    </tr>
    <tr>
      <th>14</th>
      <td>-20.002083</td>
      <td>138.409236</td>
      <td>6.0</td>
    </tr>
    <tr>
      <th>15</th>
      <td>-20.002083</td>
      <td>138.413670</td>
      <td>7.0</td>
    </tr>
    <tr>
      <th>16</th>
      <td>-20.002083</td>
      <td>138.418105</td>
      <td>6.0</td>
    </tr>
    <tr>
      <th>17</th>
      <td>-20.002083</td>
      <td>138.422539</td>
      <td>6.0</td>
    </tr>
    <tr>
      <th>18</th>
      <td>-20.002083</td>
      <td>138.426973</td>
      <td>5.0</td>
    </tr>
    <tr>
      <th>19</th>
      <td>-20.002083</td>
      <td>138.431407</td>
      <td>4.0</td>
    </tr>
    <tr>
      <th>20</th>
      <td>-20.002083</td>
      <td>138.435841</td>
      <td>5.0</td>
    </tr>
    <tr>
      <th>21</th>
      <td>-20.002083</td>
      <td>138.440275</td>
      <td>4.0</td>
    </tr>
    <tr>
      <th>22</th>
      <td>-20.002083</td>
      <td>138.444709</td>
      <td>3.0</td>
    </tr>
    <tr>
      <th>23</th>
      <td>-20.002083</td>
      <td>138.449144</td>
      <td>4.0</td>
    </tr>
    <tr>
      <th>24</th>
      <td>-20.002083</td>
      <td>138.453578</td>
      <td>4.0</td>
    </tr>
    <tr>
      <th>25</th>
      <td>-20.002083</td>
      <td>138.458012</td>
      <td>4.0</td>
    </tr>
    <tr>
      <th>26</th>
      <td>-20.002083</td>
      <td>138.462446</td>
      <td>4.0</td>
    </tr>
    <tr>
      <th>27</th>
      <td>-20.002083</td>
      <td>138.466880</td>
      <td>5.0</td>
    </tr>
    <tr>
      <th>28</th>
      <td>-20.002083</td>
      <td>138.471314</td>
      <td>5.0</td>
    </tr>
    <tr>
      <th>29</th>
      <td>-20.002083</td>
      <td>138.475748</td>
      <td>5.0</td>
    </tr>
    <tr>
      <th>...</th>
      <td>...</td>
      <td>...</td>
      <td>...</td>
    </tr>
    <tr>
      <th>220</th>
      <td>-20.002083</td>
      <td>139.322668</td>
      <td>5.0</td>
    </tr>
    <tr>
      <th>221</th>
      <td>-20.002083</td>
      <td>139.327102</td>
      <td>5.0</td>
    </tr>
    <tr>
      <th>222</th>
      <td>-20.002083</td>
      <td>139.331536</td>
      <td>5.0</td>
    </tr>
    <tr>
      <th>223</th>
      <td>-20.002083</td>
      <td>139.335970</td>
      <td>5.0</td>
    </tr>
    <tr>
      <th>224</th>
      <td>-20.002083</td>
      <td>139.340404</td>
      <td>5.0</td>
    </tr>
    <tr>
      <th>225</th>
      <td>-20.002083</td>
      <td>139.344838</td>
      <td>5.0</td>
    </tr>
    <tr>
      <th>226</th>
      <td>-20.002083</td>
      <td>139.349272</td>
      <td>7.0</td>
    </tr>
    <tr>
      <th>227</th>
      <td>-20.002083</td>
      <td>139.353707</td>
      <td>7.0</td>
    </tr>
    <tr>
      <th>228</th>
      <td>-20.002083</td>
      <td>139.358141</td>
      <td>5.0</td>
    </tr>
    <tr>
      <th>229</th>
      <td>-20.002083</td>
      <td>139.362575</td>
      <td>5.0</td>
    </tr>
    <tr>
      <th>230</th>
      <td>-20.002083</td>
      <td>139.367009</td>
      <td>4.0</td>
    </tr>
    <tr>
      <th>231</th>
      <td>-20.002083</td>
      <td>139.371443</td>
      <td>4.0</td>
    </tr>
    <tr>
      <th>232</th>
      <td>-20.002083</td>
      <td>139.375877</td>
      <td>4.0</td>
    </tr>
    <tr>
      <th>233</th>
      <td>-20.002083</td>
      <td>139.380311</td>
      <td>4.0</td>
    </tr>
    <tr>
      <th>234</th>
      <td>-20.002083</td>
      <td>139.384746</td>
      <td>5.0</td>
    </tr>
    <tr>
      <th>235</th>
      <td>-20.002083</td>
      <td>139.389180</td>
      <td>4.0</td>
    </tr>
    <tr>
      <th>236</th>
      <td>-20.002083</td>
      <td>139.393614</td>
      <td>4.0</td>
    </tr>
    <tr>
      <th>237</th>
      <td>-20.002083</td>
      <td>139.398048</td>
      <td>5.0</td>
    </tr>
    <tr>
      <th>238</th>
      <td>-20.002083</td>
      <td>139.402482</td>
      <td>5.0</td>
    </tr>
    <tr>
      <th>239</th>
      <td>-20.002083</td>
      <td>139.406916</td>
      <td>6.0</td>
    </tr>
    <tr>
      <th>240</th>
      <td>-20.002083</td>
      <td>139.411350</td>
      <td>6.0</td>
    </tr>
    <tr>
      <th>241</th>
      <td>-20.002083</td>
      <td>139.415784</td>
      <td>7.0</td>
    </tr>
    <tr>
      <th>242</th>
      <td>-20.002083</td>
      <td>139.420219</td>
      <td>5.0</td>
    </tr>
    <tr>
      <th>243</th>
      <td>-20.002083</td>
      <td>139.424653</td>
      <td>5.0</td>
    </tr>
    <tr>
      <th>244</th>
      <td>-20.002083</td>
      <td>139.429087</td>
      <td>5.0</td>
    </tr>
    <tr>
      <th>245</th>
      <td>-20.002083</td>
      <td>139.433521</td>
      <td>7.0</td>
    </tr>
    <tr>
      <th>246</th>
      <td>-20.002083</td>
      <td>139.437955</td>
      <td>7.0</td>
    </tr>
    <tr>
      <th>247</th>
      <td>-20.002083</td>
      <td>139.442389</td>
      <td>7.0</td>
    </tr>
    <tr>
      <th>248</th>
      <td>-20.002083</td>
      <td>139.446823</td>
      <td>8.0</td>
    </tr>
    <tr>
      <th>249</th>
      <td>-20.002083</td>
      <td>139.451258</td>
      <td>8.0</td>
    </tr>
  </tbody>
</table>
<p>250 rows × 3 columns</p>
</div>




```python
# Create feature collection.
mcd_fc = gis.content.import_data(mcd_df)
m = gis.map()
m.add_layer(mcd_fc, {"renderer":"ClassedSizeRenderer", "field_name": "Lai500m"})
m
```
