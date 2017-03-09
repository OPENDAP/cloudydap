#!/bin/sh
#
#
#  Float32 Temperature_A[StdPressureLev=24][Latitude=180][Longitude=360];
#
#  <Dimension name="Latitude" size="180"/>
#  <Dimension name="Longitude" size="360"/>
#  <Dimension name="StdPressureLev" size="24"/>
#  <Float32 name="Temperature_A">
#    <Dim name="/StdPressureLev"/>
#    <Dim name="/Latitude"/>
#    <Dim name="/Longitude"/>
#    <h4:chunks deflate_level="2" compressionType="deflate shuffle">
#      <h4:chunkDimensionSizes>12 90 180</h4:chunkDimensionSizes>
#      <h4:byteStream uuid="ed9c46e0-2dcd-4fa3-adf1-9054bb9cd95c" nBytes="196362" offset="0" md5="3f2a0ced0cb338d728de6770868b6dfa" chunkPositionInArray="[0,0,0]" href="https://s3.amazonaws.com/cloudydap/bytestream/3f2a0ced0cb338d728de6770868b6dfa" />
#      <h4:byteStream uuid="c8b28570-09b2-4236-a6b4-78cd53d935d5" nBytes="194181" offset="0" md5="2acc025f5bb53e01be55a61c24feddc3" chunkPositionInArray="[0,0,180]" href="https://s3.amazonaws.com/cloudydap/bytestream/2acc025f5bb53e01be55a61c24feddc3" />
#      <h4:byteStream uuid="61cec860-cc36-454a-a54c-cb8296f59cf1" nBytes="186295" offset="0" md5="ca67411a172ee6349daf224cec99745f" chunkPositionInArray="[0,90,0]" href="https://s3.amazonaws.com/cloudydap/bytestream/ca67411a172ee6349daf224cec99745f" />
#      <h4:byteStream uuid="cf7f0eb2-373c-478d-90ed-355fb136d089" nBytes="176783" offset="0" md5="772e7615e9138973bbbc3af6ddf2da1c" chunkPositionInArray="[0,90,180]" href="https://s3.amazonaws.com/cloudydap/bytestream/772e7615e9138973bbbc3af6ddf2da1c" />
#      <h4:byteStream uuid="183a4aa1-3f0f-4ffe-9e4c-234846480e3b" nBytes="202616" offset="0" md5="cecf6cfd6570492b56086764d9ff03bf" chunkPositionInArray="[12,0,0]" href="https://s3.amazonaws.com/cloudydap/bytestream/cecf6cfd6570492b56086764d9ff03bf" />
#      <h4:byteStream uuid="33359e71-a8d8-4b25-95b8-481a089f1c72" nBytes="198563" offset="0" md5="e31f5fd2f268e61810bb841254c471da" chunkPositionInArray="[12,0,180]" href="https://s3.amazonaws.com/cloudydap/bytestream/e31f5fd2f268e61810bb841254c471da" />
#      <h4:byteStream uuid="d53be683-9331-4fe7-a505-845f958ee585" nBytes="173465" offset="0" md5="3fc0188a18fd615d93fc2e8197155e11" chunkPositionInArray="[12,90,0]" href="https://s3.amazonaws.com/cloudydap/bytestream/3fc0188a18fd615d93fc2e8197155e11" />
#      <h4:byteStream uuid="db4dd637-9fa3-478b-9715-054f463b2169" nBytes="170995" offset="0" md5="dffa920e4f0b9d56ab934965e5a13a22" chunkPositionInArray="[12,90,180]" href="https://s3.amazonaws.com/cloudydap/bytestream/dffa920e4f0b9d56ab934965e5a13a22" />
#    </h4:chunks>
#
#    Float32 Temperature_A[24][180][360];
#    chunk_shape[12][90][180]  # 8 chunks
#
#export DAP4_CE="Temperature_A[0:8:23][0:15:179][0:15:359];SurfSkinTemp_A[0:15:179][0:15:359];EmisIR_A[0:1:3][0:15:179][0:15:359];SurfPres_Forecast_A[0:15:179][0:15:359];ClrOLR_A[0:15:179][0:15:359];O3_VMR_D[0:8:23][0:15:179][0:15:359];Temperature_D[0:8:23][0:15:179][0:15:359];O3_VMR_TqJ_A[0:8:23][0:15:179][0:15:359];O3_VMR_TqJ_D[0:8:23][0:15:179][0:15:359];Temperature_TqJ_D[0:8:23][0:15:179][0:15:359];GPHeight_TqJ_D[0:8:23][0:15:179][0:15:359];CH4_VMR_TqJ_D[0:8:23][0:15:179][0:15:359];Temperature_MW_A[0:8:23][0:15:179][0:15:359];CH4_VMR_A[0:8:23][0:15:179][0:15:359]"


export DAP4_CE="GPHeight_MW_A_sdev[0:8:23][0:15:179][0:15:359];Temperature_A_err[0:8:23][0:15:179][0:15:359];O3_VMR_TqJ_D[0:8:23][0:15:179][0:15:359];O3_VMR_TqJ_A_max[0:8:23][0:15:179][0:15:359];CO_VMR_TqJ_D_sdev[0:8:23][0:15:179][0:15:359];Temperature_TqJ_D[0:8:23][0:15:179][0:15:359];O3_VMR_D[0:8:23][0:15:179][0:15:359];GPHeight_TqJ_D[0:8:23][0:15:179][0:15:359];Temperature_TqJ_A_min[0:8:23][0:15:179][0:15:359];Temperature_TqJ_D_err[0:8:23][0:15:179][0:15:359];Temperature_TqJ_A[0:8:23][0:15:179][0:15:359];GPHeight_MW_D_min[0:8:23][0:15:179][0:15:359];CO_VMR_D_sdev[0:8:23][0:15:179][0:15:359];CH4_VMR_TqJ_D_sdev[0:8:23][0:15:179][0:15:359];O3_VMR_D_err[0:8:23][0:15:179][0:15:359];CO_VMR_TqJ_A_sdev[0:8:23][0:15:179][0:15:359];GPHeight_TqJ_D_min[0:8:23][0:15:179][0:15:359];CO_VMR_D[0:8:23][0:15:179][0:15:359];Temperature_D_err[0:8:23][0:15:179][0:15:359];Temperature_MW_D_min[0:8:23][0:15:179][0:15:359];GPHeight_A_sdev[0:8:23][0:15:179][0:15:359];GPHeight_MW_A[0:8:23][0:15:179][0:15:359];O3_VMR_TqJ_D_min[0:8:23][0:15:179][0:15:359];CH4_VMR_D_err[0:8:23][0:15:179][0:15:359];CO_VMR_TqJ_D[0:8:23][0:15:179][0:15:359];GPHeight_D_sdev[0:8:23][0:15:179][0:15:359];O3_VMR_TqJ_D_sdev[0:8:23][0:15:179][0:15:359];CO_VMR_TqJ_A_min[0:8:23][0:15:179][0:15:359];O3_VMR_TqJ_A[0:8:23][0:15:179][0:15:359];O3_VMR_TqJ_A_sdev[0:8:23][0:15:179][0:15:359]"


#**# GPHeight_MW_A_sdev[0:8:23][0:15:179][0:15:359];
#**# Temperature_A_err[0:8:23][0:15:179][0:15:359];
#**# O3_VMR_TqJ_D[0:8:23][0:15:179][0:15:359];
#**# O3_VMR_TqJ_A_max[0:8:23][0:15:179][0:15:359];
#**# CO_VMR_TqJ_D_sdev[0:8:23][0:15:179][0:15:359];
#**# Temperature_TqJ_D[0:8:23][0:15:179][0:15:359];
#**# O3_VMR_D[0:8:23][0:15:179][0:15:359];
#**# GPHeight_TqJ_D[0:8:23][0:15:179][0:15:359];
#**# Temperature_TqJ_A_min[0:8:23][0:15:179][0:15:359];
#**# Temperature_TqJ_D_err[0:8:23][0:15:179][0:15:359];
# CH4_VMR_TqJ_D_min[0:8:23][0:15:179][0:15:359];
# GPHeight_MW_A_max[0:8:23][0:15:179][0:15:359];
# CO_VMR_TqJ_A_max[0:8:23][0:15:179][0:15:359];
# O3_VMR_A_sdev[0:8:23][0:15:179][0:15:359];
# GPHeight_TqJ_D_max[0:8:23][0:15:179][0:15:359];
# O3_VMR_D_sdev[0:8:23][0:15:179][0:15:359];
# CH4_VMR_TqJ_D_max[0:8:23][0:15:179][0:15:359];
# O3_VMR_A_min[0:8:23][0:15:179][0:15:359];
# CO_VMR_A_min[0:8:23][0:15:179][0:15:359];
# Temperature_TqJ_D_sdev[0:8:23][0:15:179][0:15:359];
# O3_VMR_D_min[0:8:23][0:15:179][0:15:359];
# CO_VMR_D_max[0:8:23][0:15:179][0:15:359];
# CH4_VMR_TqJ_D[0:8:23][0:15:179][0:15:359];
# GPHeight_A_max[0:8:23][0:15:179][0:15:359];
# O3_VMR_D_max[0:8:23][0:15:179][0:15:359];
# O3_VMR_TqJ_A_err[0:8:23][0:15:179][0:15:359];
# Temperature_A_max[0:8:23][0:15:179][0:15:359];
# Temperature_MW_A[0:8:23][0:15:179][0:15:359];
# CH4_VMR_A_max[0:8:23][0:15:179][0:15:359];
# CH4_VMR_A[0:8:23][0:15:179][0:15:359];
# CO_VMR_A_err[0:8:23][0:15:179][0:15:359];
#**# Temperature_TqJ_A[0:8:23][0:15:179][0:15:359];
#**# GPHeight_MW_D_min[0:8:23][0:15:179][0:15:359];
#**# CO_VMR_D_sdev[0:8:23][0:15:179][0:15:359];
#**# CH4_VMR_TqJ_D_sdev[0:8:23][0:15:179][0:15:359];
#**# O3_VMR_D_err[0:8:23][0:15:179][0:15:359];
#**# CO_VMR_TqJ_A_sdev[0:8:23][0:15:179][0:15:359];
#**# GPHeight_TqJ_D_min[0:8:23][0:15:179][0:15:359];
#**# CO_VMR_D[0:8:23][0:15:179][0:15:359];
#**# Temperature_D_err[0:8:23][0:15:179][0:15:359];
#**# Temperature_MW_D_min[0:8:23][0:15:179][0:15:359];
# CH4_VMR_TqJ_A[0:8:23][0:15:179][0:15:359];
# CO_VMR_D_min[0:8:23][0:15:179][0:15:359];
# Temperature_TqJ_A_err[0:8:23][0:15:179][0:15:359];
# O3_VMR_A_err[0:8:23][0:15:179][0:15:359];
# CH4_VMR_A_err[0:8:23][0:15:179][0:15:359];
# CO_VMR_TqJ_D_min[0:8:23][0:15:179][0:15:359];
# Temperature_TqJ_A_sdev[0:8:23][0:15:179][0:15:359];
# Temperature_D_max[0:8:23][0:15:179][0:15:359];
# Temperature_TqJ_D_max[0:8:23][0:15:179][0:15:359];
# O3_VMR_TqJ_D_err[0:8:23][0:15:179][0:15:359];
# CH4_VMR_D[0:8:23][0:15:179][0:15:359];
# Temperature_TqJ_D_min[0:8:23][0:15:179][0:15:359];
# O3_VMR_TqJ_D_max[0:8:23][0:15:179][0:15:359];
# GPHeight_MW_D_sdev[0:8:23][0:15:179][0:15:359];
# GPHeight_TqJ_A_max[0:8:23][0:15:179][0:15:359];
# O3_VMR_A[0:8:23][0:15:179][0:15:359];
# GPHeight_A_min[0:8:23][0:15:179][0:15:359];
# CO_VMR_A_max[0:8:23][0:15:179][0:15:359];
# GPHeight_MW_D[0:8:23][0:15:179][0:15:359];
# GPHeight_D[0:8:23][0:15:179][0:15:359];
# Temperature_MW_D_max[0:8:23][0:15:179][0:15:359];
# Temperature_D[0:8:23][0:15:179][0:15:359];
# GPHeight_D_min[0:8:23][0:15:179][0:15:359];
# GPHeight_TqJ_D_sdev[0:8:23][0:15:179][0:15:359];
# CH4_VMR_TqJ_A_max[0:8:23][0:15:179][0:15:359];
# Temperature_MW_D[0:8:23][0:15:179][0:15:359];
# CH4_VMR_TqJ_A_min[0:8:23][0:15:179][0:15:359];
# Temperature_MW_A_sdev[0:8:23][0:15:179][0:15:359];
# O3_VMR_TqJ_A_min[0:8:23][0:15:179][0:15:359];
# CO_VMR_A_sdev[0:8:23][0:15:179][0:15:359];
# GPHeight_TqJ_A[0:8:23][0:15:179][0:15:359];
# CO_VMR_D_err[0:8:23][0:15:179][0:15:359];
# GPHeight_TqJ_A_sdev[0:8:23][0:15:179][0:15:359];
# CH4_VMR_TqJ_A_err[0:8:23][0:15:179][0:15:359];
# StdPressureLev[0:8:23][0:15:179][0:15:359];
# Temperature_MW_A_min[0:8:23][0:15:179][0:15:359];
# Temperature_MW_D_sdev[0:8:23][0:15:179][0:15:359];
# CH4_VMR_A_min[0:8:23][0:15:179][0:15:359];
# GPHeight_MW_A_min[0:8:23][0:15:179][0:15:359];
# CO_VMR_TqJ_A[0:8:23][0:15:179][0:15:359];
# Temperature_A[0:8:23][0:15:179][0:15:359];
# GPHeight_MW_D_max[0:8:23][0:15:179][0:15:359];
# Temperature_D_sdev[0:8:23][0:15:179][0:15:359];
# Temperature_A_sdev[0:8:23][0:15:179][0:15:359];
# Temperature_A_min[0:8:23][0:15:179][0:15:359];
# GPHeight_D_max[0:8:23][0:15:179][0:15:359];
# CO_VMR_TqJ_D_err[0:8:23][0:15:179][0:15:359];
# CH4_VMR_D_min[0:8:23][0:15:179][0:15:359];
# Temperature_D_min[0:8:23][0:15:179][0:15:359];
# CH4_VMR_D_max[0:8:23][0:15:179][0:15:359];
# CH4_VMR_A_sdev[0:8:23][0:15:179][0:15:359];
# Temperature_TqJ_A_max[0:8:23][0:15:179][0:15:359];
# CO_VMR_A[0:8:23][0:15:179][0:15:359];
# CH4_VMR_D_sdev[0:8:23][0:15:179][0:15:359];
# CO_VMR_TqJ_A_err[0:8:23][0:15:179][0:15:359];
# CH4_VMR_TqJ_D_err[0:8:23][0:15:179][0:15:359];
# GPHeight_A[0:8:23][0:15:179][0:15:359];
# O3_VMR_A_max[0:8:23][0:15:179][0:15:359];
# CH4_VMR_TqJ_A_sdev[0:8:23][0:15:179][0:15:359];
# CO_VMR_TqJ_D_max[0:8:23][0:15:179][0:15:359];
# GPHeight_TqJ_A_min[0:8:23][0:15:179][0:15:359];
# Temperature_MW_A_max[0:8:23][0:15:179][0:15:359];
#**# GPHeight_A_sdev[0:8:23][0:15:179][0:15:359];
#**# GPHeight_MW_A[0:8:23][0:15:179][0:15:359];
#**# O3_VMR_TqJ_D_min[0:8:23][0:15:179][0:15:359];
#**# CH4_VMR_D_err[0:8:23][0:15:179][0:15:359];
#**# CO_VMR_TqJ_D[0:8:23][0:15:179][0:15:359];
#**# GPHeight_D_sdev[0:8:23][0:15:179][0:15:359];
#**# O3_VMR_TqJ_D_sdev[0:8:23][0:15:179][0:15:359];
#**# CO_VMR_TqJ_A_min[0:8:23][0:15:179][0:15:359];
#**# O3_VMR_TqJ_A[0:8:23][0:15:179][0:15:359];
#**# O3_VMR_TqJ_A_sdev[0:8:23][0:15:179][0:15:359];













