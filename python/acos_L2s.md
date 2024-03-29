

Copyright (C) 2017 The HDF Group  
All rights reserved

This example code illustrates how to access a GES DISC ACOS Swath HDF5 file 
with Python via OPeNDAP and visualize it with Panoply and IDV.

If you have any questions, suggestions, or comments on this example, please use
the HDF-EOS Forum (http://hdfeos.org/forums).  If you would like to see an
example of any other NASA HDF/HDF-EOS data product that is not listed in the
HDF-EOS Comprehensive Examples page (http://hdfeos.org/zoo), feel free to
contact us at eoshelp@hdfgroup.org or post it at the HDF-EOS Forum
(http://hdfeos.org/forums).

# Access ACOS data from GES DISC via OPeNDAP

 If you try to access ACOS OPeNDAP data with Panoply or IDV, you will get an error message *URI Too Large* like below. 
 
 ![png](acos_L2s_panoply_error.png)
 
 This example will illustrate how to subset and download data from ACOS OPeNDAP data and save it as netCDF4. Then, we will augment the subsetted and downloaded data so that visualization tool like Panoply and IDV can understand the CF conventions and visualize data as shown below.
 
 ![gif](acos_L2s_idv_animation.gif)
 
 The first step is to make sure that your NASA Earthdata Login username and password works with OPeNDAP server.




```python
from netCDF4 import Dataset # for writing data in netCDF-4/HDF5
from pydap.client import open_url, open_dods
from pydap.cas.urs import setup_session
url = 'https://oco2.gesdisc.eosdis.nasa.gov/opendap/ACOS_L2S.7.3/2016/001/acos_L2s_160101_01_Production_v201201_L2Sub7309_r01_PolB_161028201935.h5'

# Replace username and passowrd to match yours.
session = setup_session('eoshelp', '********', check_url=url)
dataset = open_url(url, session=session)
print dataset
```

    <DatasetType with children 'ABandCloudScreen_albedo_o2_cld', 'ABandCloudScreen_dispersion_multiplier_cld', 'ABandCloudScreen_noise_o2_cld', 'ABandCloudScreen_reduced_chi_squared_o2_cld', 'ABandCloudScreen_reduced_chi_squared_o2_threshold_cld', 'ABandCloudScreen_signal_o2_cld', 'ABandCloudScreen_snr_o2_cld', 'ABandCloudScreen_surface_pressure_apriori_cld', 'ABandCloudScreen_surface_pressure_cld', 'ABandCloudScreen_surface_pressure_delta_cld', 'ABandCloudScreen_surface_pressure_offset_cld', 'ABandCloudScreen_temperature_offset_cld', 'IMAPDOASPreprocessing_ch4_column_apriori_idp', 'IMAPDOASPreprocessing_ch4_column_idp', 'IMAPDOASPreprocessing_ch4_column_uncert_idp', 'IMAPDOASPreprocessing_ch4_weak_band_processing_flag_idp', 'IMAPDOASPreprocessing_cloud_flag_idp', 'IMAPDOASPreprocessing_co2_column_apriori_idp', 'IMAPDOASPreprocessing_co2_column_ch4_window_idp', 'IMAPDOASPreprocessing_co2_column_strong_band_idp', 'IMAPDOASPreprocessing_co2_column_strong_band_uncert_idp', 'IMAPDOASPreprocessing_co2_column_weak_band_idp', 'IMAPDOASPreprocessing_co2_column_weak_band_uncert_idp', 'IMAPDOASPreprocessing_co2_ratio_idp', 'IMAPDOASPreprocessing_co2_strong_band_processing_flag_idp', 'IMAPDOASPreprocessing_co2_weak_band_processing_flag_idp', 'IMAPDOASPreprocessing_delta_d_idp', 'IMAPDOASPreprocessing_delta_d_uncert_idp', 'IMAPDOASPreprocessing_dry_air_column_apriori_idp', 'IMAPDOASPreprocessing_h2o_column_apriori_idp', 'IMAPDOASPreprocessing_h2o_column_idp', 'IMAPDOASPreprocessing_h2o_column_uncert_idp', 'IMAPDOASPreprocessing_h2o_ratio_idp', 'IMAPDOASPreprocessing_h2o_ratio_uncert_idp', 'IMAPDOASPreprocessing_hdo_column_apriori_idp', 'IMAPDOASPreprocessing_hdo_column_idp', 'IMAPDOASPreprocessing_hdo_column_uncert_idp', 'IMAPDOASPreprocessing_hdo_h2o_processing_flag_idp', 'IMAPDOASPreprocessing_o2_ratio_p_idp', 'IMAPDOASPreprocessing_o2_ratio_s_idp', 'IMAPDOASPreprocessing_out_of_band_transmission_p_idp', 'IMAPDOASPreprocessing_out_of_band_transmission_s_idp', 'IMAPDOASPreprocessing_total_offset_fit_relative_755nm_p_idp', 'IMAPDOASPreprocessing_total_offset_fit_relative_755nm_s_idp', 'IMAPDOASPreprocessing_total_offset_fit_relative_771nm_p_idp', 'IMAPDOASPreprocessing_total_offset_fit_relative_771nm_s_idp', 'Metadata_AbscoCO2Scale', 'Metadata_AbscoH2OScale', 'Metadata_AbscoO2Scale', 'Metadata_AncillaryDataDescriptors', 'Metadata_AscendingNodeCrossingDate', 'Metadata_AscendingNodeCrossingTime', 'Metadata_AutomaticQualityFlag', 'Metadata_BuildId', 'Metadata_CollectionLabel', 'Metadata_DataFormatType', 'Metadata_GranulePointer', 'Metadata_HDFVersionId', 'Metadata_InputPointer', 'Metadata_InstrumentShortName', 'Metadata_L2FullPhysicsAlgorithmDescriptor', 'Metadata_L2FullPhysicsDataVersion', 'Metadata_L2FullPhysicsExeVersion', 'Metadata_L2FullPhysicsInputPointer', 'Metadata_L2FullPhysicsProductionLocation', 'Metadata_LongName', 'Metadata_MissingExposures', 'Metadata_NominalDay', 'Metadata_NumberOfExposures', 'Metadata_NumberOfGoodRetrievals', 'Metadata_OrbitOfDay', 'Metadata_PlatformLongName', 'Metadata_PlatformShortName', 'Metadata_PlatformType', 'Metadata_ProcessingLevel', 'Metadata_ProducerAgency', 'Metadata_ProducerInstitution', 'Metadata_ProductionDateTime', 'Metadata_ProductionLocation', 'Metadata_ProductionLocationCode', 'Metadata_ProjectId', 'Metadata_QAGranulePointer', 'Metadata_RangeBeginningDate', 'Metadata_RangeBeginningTime', 'Metadata_RangeEndingDate', 'Metadata_RangeEndingTime', 'Metadata_RetrievalIterationLimit', 'Metadata_RetrievalPolarization', 'Metadata_SISName', 'Metadata_SISVersion', 'Metadata_ShortName', 'Metadata_SizeMBECSDataGranule', 'Metadata_SpectralChannel', 'Metadata_StartPathNumber', 'Metadata_StopPathNumber', 'Metadata_TFTSVersion', 'Metadata_VMRO2', 'RetrievalHeader_acquisition_mode', 'RetrievalHeader_ct_observation_points', 'RetrievalHeader_dispersion_offset_shift', 'RetrievalHeader_exposure_duration', 'RetrievalHeader_exposure_index', 'RetrievalHeader_gain_swir', 'RetrievalHeader_glint_flag', 'RetrievalHeader_sounding_qual_flag', 'RetrievalHeader_sounding_time_string', 'RetrievalHeader_sounding_time_tai93', 'RetrievalHeader_spike_noise_flag', 'RetrievalHeader_zpd_saturation_flag', 'RetrievalResults_aerosol_1_aod', 'RetrievalResults_aerosol_1_aod_high', 'RetrievalResults_aerosol_1_aod_low', 'RetrievalResults_aerosol_1_aod_mid', 'RetrievalResults_aerosol_1_gaussian_log_param', 'RetrievalResults_aerosol_1_gaussian_log_param_apriori', 'RetrievalResults_aerosol_1_gaussian_log_param_uncert', 'RetrievalResults_aerosol_2_aod', 'RetrievalResults_aerosol_2_aod_high', 'RetrievalResults_aerosol_2_aod_low', 'RetrievalResults_aerosol_2_aod_mid', 'RetrievalResults_aerosol_2_gaussian_log_param', 'RetrievalResults_aerosol_2_gaussian_log_param_apriori', 'RetrievalResults_aerosol_2_gaussian_log_param_uncert', 'RetrievalResults_aerosol_3_aod', 'RetrievalResults_aerosol_3_aod_high', 'RetrievalResults_aerosol_3_aod_low', 'RetrievalResults_aerosol_3_aod_mid', 'RetrievalResults_aerosol_3_gaussian_log_param', 'RetrievalResults_aerosol_3_gaussian_log_param_apriori', 'RetrievalResults_aerosol_3_gaussian_log_param_uncert', 'RetrievalResults_aerosol_4_aod', 'RetrievalResults_aerosol_4_aod_high', 'RetrievalResults_aerosol_4_aod_low', 'RetrievalResults_aerosol_4_aod_mid', 'RetrievalResults_aerosol_4_gaussian_log_param', 'RetrievalResults_aerosol_4_gaussian_log_param_apriori', 'RetrievalResults_aerosol_4_gaussian_log_param_uncert', 'RetrievalResults_aerosol_total_aod', 'RetrievalResults_aerosol_total_aod_high', 'RetrievalResults_aerosol_total_aod_low', 'RetrievalResults_aerosol_total_aod_mid', 'RetrievalResults_aerosol_types', 'RetrievalResults_albedo_apriori_o2_fph', 'RetrievalResults_albedo_apriori_strong_co2_fph', 'RetrievalResults_albedo_apriori_weak_co2_fph', 'RetrievalResults_albedo_o2_fph', 'RetrievalResults_albedo_slope_apriori_o2', 'RetrievalResults_albedo_slope_apriori_strong_co2', 'RetrievalResults_albedo_slope_apriori_weak_co2', 'RetrievalResults_albedo_slope_o2', 'RetrievalResults_albedo_slope_strong_co2', 'RetrievalResults_albedo_slope_uncert_o2', 'RetrievalResults_albedo_slope_uncert_strong_co2', 'RetrievalResults_albedo_slope_uncert_weak_co2', 'RetrievalResults_albedo_slope_weak_co2', 'RetrievalResults_albedo_strong_co2_fph', 'RetrievalResults_albedo_uncert_o2_fph', 'RetrievalResults_albedo_uncert_strong_co2_fph', 'RetrievalResults_albedo_uncert_weak_co2_fph', 'RetrievalResults_albedo_weak_co2_fph', 'RetrievalResults_apriori_o2_column', 'RetrievalResults_co2_profile', 'RetrievalResults_co2_profile_apriori', 'RetrievalResults_co2_profile_averaging_kernel_matrix', 'RetrievalResults_co2_profile_covariance_matrix', 'RetrievalResults_co2_profile_uncert', 'RetrievalResults_co2_vertical_gradient_delta', 'RetrievalResults_dispersion_offset_apriori_o2', 'RetrievalResults_dispersion_offset_apriori_strong_co2', 'RetrievalResults_dispersion_offset_apriori_weak_co2', 'RetrievalResults_dispersion_offset_o2', 'RetrievalResults_dispersion_offset_strong_co2', 'RetrievalResults_dispersion_offset_uncert_o2', 'RetrievalResults_dispersion_offset_uncert_strong_co2', 'RetrievalResults_dispersion_offset_uncert_weak_co2', 'RetrievalResults_dispersion_offset_weak_co2', 'RetrievalResults_diverging_steps', 'RetrievalResults_dof_co2_profile', 'RetrievalResults_dof_full_vector', 'RetrievalResults_eof_1_scale_apriori_o2', 'RetrievalResults_eof_1_scale_apriori_strong_co2', 'RetrievalResults_eof_1_scale_apriori_weak_co2', 'RetrievalResults_eof_1_scale_o2', 'RetrievalResults_eof_1_scale_strong_co2', 'RetrievalResults_eof_1_scale_uncert_o2', 'RetrievalResults_eof_1_scale_uncert_strong_co2', 'RetrievalResults_eof_1_scale_uncert_weak_co2', 'RetrievalResults_eof_1_scale_weak_co2', 'RetrievalResults_eof_2_scale_apriori_o2', 'RetrievalResults_eof_2_scale_apriori_strong_co2', 'RetrievalResults_eof_2_scale_apriori_weak_co2', 'RetrievalResults_eof_2_scale_o2', 'RetrievalResults_eof_2_scale_strong_co2', 'RetrievalResults_eof_2_scale_uncert_o2', 'RetrievalResults_eof_2_scale_uncert_strong_co2', 'RetrievalResults_eof_2_scale_uncert_weak_co2', 'RetrievalResults_eof_2_scale_weak_co2', 'RetrievalResults_eof_3_scale_apriori_o2', 'RetrievalResults_eof_3_scale_apriori_strong_co2', 'RetrievalResults_eof_3_scale_apriori_weak_co2', 'RetrievalResults_eof_3_scale_o2', 'RetrievalResults_eof_3_scale_strong_co2', 'RetrievalResults_eof_3_scale_uncert_o2', 'RetrievalResults_eof_3_scale_uncert_strong_co2', 'RetrievalResults_eof_3_scale_uncert_weak_co2', 'RetrievalResults_eof_3_scale_weak_co2', 'RetrievalResults_fluorescence_at_reference', 'RetrievalResults_fluorescence_at_reference_apriori', 'RetrievalResults_fluorescence_at_reference_uncert', 'RetrievalResults_fluorescence_slope', 'RetrievalResults_fluorescence_slope_apriori', 'RetrievalResults_fluorescence_slope_uncert', 'RetrievalResults_h2o_scale_factor', 'RetrievalResults_h2o_scale_factor_apriori', 'RetrievalResults_h2o_scale_factor_uncert', 'RetrievalResults_iterations', 'RetrievalResults_last_step_levenberg_marquardt_parameter', 'RetrievalResults_num_active_levels', 'RetrievalResults_outcome_flag', 'RetrievalResults_retrieved_co2_column', 'RetrievalResults_retrieved_dry_air_column_layer_thickness', 'RetrievalResults_retrieved_h2o_column', 'RetrievalResults_retrieved_h2o_column_layer_thickness', 'RetrievalResults_retrieved_o2_column', 'RetrievalResults_retrieved_wet_air_column_layer_thickness', 'RetrievalResults_specific_humidity_profile_ecmwf', 'RetrievalResults_surface_pressure_apriori_fph', 'RetrievalResults_surface_pressure_fph', 'RetrievalResults_surface_pressure_uncert_fph', 'RetrievalResults_surface_type', 'RetrievalResults_temperature_offset_apriori_fph', 'RetrievalResults_temperature_offset_fph', 'RetrievalResults_temperature_offset_uncert_fph', 'RetrievalResults_temperature_profile_ecmwf', 'RetrievalResults_vector_pressure_levels', 'RetrievalResults_vector_pressure_levels_apriori', 'RetrievalResults_vector_pressure_levels_ecmwf', 'RetrievalResults_wind_speed', 'RetrievalResults_wind_speed_apriori', 'RetrievalResults_wind_speed_uncert', 'RetrievalResults_xco2', 'RetrievalResults_xco2_apriori', 'RetrievalResults_xco2_avg_kernel', 'RetrievalResults_xco2_avg_kernel_norm', 'RetrievalResults_xco2_pressure_weighting_function', 'RetrievalResults_xco2_uncert', 'RetrievalResults_xco2_uncert_interf', 'RetrievalResults_xco2_uncert_noise', 'RetrievalResults_xco2_uncert_smooth', 'RetrievalResults_zero_level_offset_apriori_o2', 'RetrievalResults_zero_level_offset_o2', 'RetrievalResults_zero_level_offset_uncert_o2', 'SoundingGeometry_sounding_altitude', 'SoundingGeometry_sounding_altitude_max', 'SoundingGeometry_sounding_altitude_min', 'SoundingGeometry_sounding_altitude_stddev', 'SoundingGeometry_sounding_altitude_uncert', 'SoundingGeometry_sounding_aspect', 'SoundingGeometry_sounding_at_angle', 'SoundingGeometry_sounding_at_angle_error', 'SoundingGeometry_sounding_azimuth', 'SoundingGeometry_sounding_ct_angle', 'SoundingGeometry_sounding_ct_angle_error', 'SoundingGeometry_sounding_glint_angle', 'SoundingGeometry_sounding_land_fraction', 'SoundingGeometry_sounding_latitude', 'SoundingGeometry_sounding_latitude_geoid', 'SoundingGeometry_sounding_longitude', 'SoundingGeometry_sounding_longitude_geoid', 'SoundingGeometry_sounding_plane_fit_quality', 'SoundingGeometry_sounding_slope', 'SoundingGeometry_sounding_solar_azimuth', 'SoundingGeometry_sounding_solar_zenith', 'SoundingGeometry_sounding_zenith', 'SoundingHeader_cloud_flag', 'SoundingHeader_l2_packaging_qual_flag', 'SoundingHeader_retrieval_index', 'SpacecraftGeometry_ground_track', 'SpacecraftGeometry_relative_velocity', 'SpacecraftGeometry_spacecraft_alt', 'SpacecraftGeometry_spacecraft_lat', 'SpacecraftGeometry_spacecraft_lon', 'SpacecraftGeometry_x_pos', 'SpacecraftGeometry_x_vel', 'SpacecraftGeometry_y_pos', 'SpacecraftGeometry_y_vel', 'SpacecraftGeometry_z_pos', 'SpacecraftGeometry_z_vel', 'SpectralParameters_noise_o2_fph', 'SpectralParameters_noise_strong_co2_fph', 'SpectralParameters_noise_weak_co2_fph', 'SpectralParameters_reduced_chi_squared_o2_fph', 'SpectralParameters_reduced_chi_squared_strong_co2_fph', 'SpectralParameters_reduced_chi_squared_weak_co2_fph', 'SpectralParameters_relative_residual_mean_square_o2', 'SpectralParameters_relative_residual_mean_square_strong_co2', 'SpectralParameters_relative_residual_mean_square_weak_co2', 'SpectralParameters_residual_mean_square_o2', 'SpectralParameters_residual_mean_square_strong_co2', 'SpectralParameters_residual_mean_square_weak_co2', 'SpectralParameters_signal_o2_fph', 'SpectralParameters_signal_strong_co2_fph', 'SpectralParameters_signal_weak_co2_fph', 'SpectralParameters_snr_o2_l1b', 'SpectralParameters_snr_strong_co2_l1b', 'SpectralParameters_snr_weak_co2_l1b', 'Metadata_FirstSoundingId_Time', 'Metadata_FirstSoundingId_Date', 'Metadata_LastSoundingId_Time', 'Metadata_LastSoundingId_Date', 'RetrievalHeader_sounding_id_reference_Time', 'RetrievalHeader_sounding_id_reference_Date', 'SoundingHeader_sounding_id_Time', 'SoundingHeader_sounding_id_Date'>


We are interested in time, altitude, lat, lon data along with co2. Subset them only. 


```python
latitude = dataset['SoundingGeometry_sounding_latitude'][:]
longitude = dataset['SoundingGeometry_sounding_longitude'][:]
time = dataset['RetrievalHeader_sounding_time_tai93'][:]
altitude = dataset['SoundingGeometry_sounding_altitude'][:]
data =  dataset['RetrievalResults_xco2'][:]
print latitude
```

    <BaseType with data array([ -9.45687485,  -9.45323086,  -9.44804382, -24.55160713,
           -24.5477829 , -24.54277611, -65.99790192, -65.99738312,
           -65.9967804 , -79.46168518, -79.45751953, -79.44987488,
           -77.84957886, -79.60216522, -79.59919739, -79.59563446,
           -81.44069672, -81.43222046, -81.42183685, -83.17164612,
           -83.16862488, -83.1651535 , -80.97970581, -80.97569275,
           -79.38381195, -79.385849  , -79.38697052, -84.23915863,
           -84.23584747, -84.23146057, -84.34416199, -84.34805298,
           -84.35147095, -81.90871429, -81.91001892, -81.91080475,
           -79.43899536, -79.43900299, -79.43818665, -83.45439148,
           -83.45941925, -81.81082153, -81.81719971, -81.82600403,
           -76.42046356, -76.42217255, -76.42575836, -78.35108185,
           -78.35652161, -78.36101532, -79.88899231, -79.89847565,
           -79.90653992, -77.67523956, -77.68431854, -77.69304657,
           -76.4284668 , -76.4347229 , -76.43946075, -74.72257233,
           -74.72516632, -74.72809601, -72.79450226, -72.79701996,
           -72.80060577, -74.34109497, -74.34650421, -74.35192871,
           -72.14447021, -72.15122986, -72.15628052], dtype=float32)>


Let's rewrite subsetted data as CF trajectory netCDF-4/HDF5 file (test.nc) that Panoply can visualize. netcDF tools are picky about dimension names. Define *obs* and *trajectory* dimensions. The size of *obs* dimension should match the size of lat/lon/time/altitude dimension of ACOS data.


```python
rootgrp = Dataset("test.nc", "w")
trajectory = rootgrp.createDimension("trajectory", 1)
obs = rootgrp.createDimension("obs", latitude.shape[0])
```

Create 2D variables using the above dimensions.


```python
time_nc = rootgrp.createVariable("time","f4",("trajectory","obs",))
lon_nc = rootgrp.createVariable("lon","f4",("trajectory","obs",))
lat_nc = rootgrp.createVariable("lat","f4",("trajectory","obs",))
z_nc = rootgrp.createVariable("z","f4",("trajectory","obs",))
data_nc = rootgrp.createVariable("RetrievalResults_xco2","f4",("trajectory","obs",))
```

netCDF-Java based visualization tools like IDV and Panoply heavily rely on attributes that follow the CF conventions. Add them.


```python
lon_nc.units = "degrees_east"
lon_nc.axis = "X"
lat_nc.units = "degrees_north"
lat_nc.axis = "Y"
time_nc.units = "seconds since 1993-1-1 0:0:0"
time_nc.axis = "T"
z_nc.units = "m"
z_nc.axis = "Z"
data_nc.coordinates = "time lat lon z"

```

All dimension and variables are defined. Let's add data from OPeNDAP server. 


```python
time_nc[:] = time.data
lon_nc[:] = longitude.data
lat_nc[:] = latitude.data
z_nc[:] = altitude.data
data_nc[:] = data.data

```

For Panoply, you can stop here by closing the netCDF4 file. 


```python
# Don't close if you want to visualize it with IDV properly.
# rootgrp.close() 
```

Then, you can open *test.nc* file with Panoply. You can visualize trajectory as shown below.

![png](acos_L2s_panoply_trajectory.png)



IDV requires more conventions than Panoply requires to make trajectory visualization work. You need to add extra variable and CF global attributes as follows. For example, IDV doesn't accept the *units* attribute value **Mole Mole^{-1}**.


```python
rootgrp.Conventions = "CF-1.6"
rootgrp.featureType = "trajectory"
rootgrp.cdm_data_type = "Trajectory"
trajectory_nc = rootgrp.createVariable("trajectory","i",("trajectory",))
trajectory_nc[:] = [1]
data_nc.units = "mole mole-1"
rootgrp.close()
```

You can open the *test.nc* file as **Trajectory Sounding files** in IDV Data Chooser. Then, you can visualize the data easily as shown below. 

![png](acos_L2s_idv_trajectory.png)


NOTE: Since both IDV and Panoply are based on netCDF-Java library, you can get  the same visualization by [selecting datasets and downloading them as netCDF](https://disc.sci.gsfc.nasa.gov/information/howto/5761bc6a5ad5a18811681bc3/how-to-obtain-data-in-net-cdf-format-via-o-pe-ndap?page=1) first and writing NcML file to augment (rename dimension, add CF attributes, and add variable) the downloaded netCDF file. The complete working sample NcML file is available [here](acos_L2s.ncml). Please make sure that the downloaded netCDF file name matches the *location* attribute value of *netcdf* tag in NcML.
