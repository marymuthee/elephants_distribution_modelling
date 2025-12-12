#set working directory
setwd("D:/R DATA")

#getwd and items in there
getwd()
dir()

#activate libraries
library(terra)
library(raster)
library(predicts)
library(predicts)
library(sp)
library(sf)
library(ggplot2)
library(rasterVis)
library(rgdal)
library(stars)
library(tidyverse)
library(predicts)
library(dismo)
library(rJava)

#import data
machakos<-st_read("machakos.shp")
plot(st_geometry(machakos))
FAW<-st_read("machakos_faw.csv")


#import historical bio/Current bio
B1<-raster("Bio1.tif"  )
B2<-raster("Bio2.tif"  )
B3<-raster("Bio3.tif"  )
B4<-raster("Bio4.tif"  )
B5<-raster("Bio5.tif"  )
B6<-raster("Bio6.tif"  )
B7<-raster("Bio7.tif"  )
B8<-raster("Bio8.tif"  )
B9<-raster("Bio9.tif"  )
B10<-raster("Bio10.tif"  )
B11<-raster("Bio11.tif"  )
B12<-raster("Bio12.tif"  )
B13<-raster("Bio13.tif"  )
B14<-raster("Bio14.tif"  )
B15<-raster("Bio15.tif"  )
B16<-raster("Bio16.tif"  )
B17<-raster("Bio17.tif"  )
B18<-raster("Bio18.tif"  )
B19<-raster("Bio19.tif"  )

#stack the historical/current bios
bioCurrent<-stack(B1,B2,B3,B4,B5,B6,B7,B8,B9,B10,B11,B12,B13,B14,B15,B16,B17,B18,B19)
plot(bioCurrent)


#convert lat and long columns from character  to numeric
FAW$lat<-as.numeric(FAW$lat)
FAW$lon<-as.numeric(FAW$lon)
#convert FAW data to spatial points datavframe
coordinates<-cbind(FAW$lon,FAW$lat)
#make the FAW a spatial point data frame
FAW_sp<-SpatialPointsDataFrame(coordinates,data=data.frame(FAW),
                                 proj4string = CRS("+proj=longlat +datum=WGS84"))
proj4string(FAW_sp)
#convert to sf feature
FAW_sf<-st_as_sf(FAW_sp)

#Extract bio variables for each point
biovalues<-raster::extract(bioCurrent,
                           FAW_sf)%>%
  bind_cols(FAW_sf) %>%
  as.data.frame()

#select random points( background points) from our study area
set.seed(1)
bg<-sampleRandom(x=bioCurrent,
                 size = 200,
                 na.rm=TRUE,
                 sp=TRUE)


#plotting the study area,occurences and bg
plot(bioCurrent[[1]])
plot(bg,add=TRUE,col="blue",cex=0.1,pch=21)
plot(FAW_sf,add=TRUE, col="red")

set.seed(1)

#randomly select 70% for training
selected<-sample(1:nrow(biovalues),
                 nrow(biovalues) *0.7)

#get the training and testing sets
occ_train<-biovalues[selected,]
occ_test<-biovalues[-selected,]
occ_train_final<-na.omit(occ_train)
occ_train_final<-subset(occ_train_final,select=-c(Country,lat,lon,Region,County,
                                                  Plants.with.FAW,Hectares.Checked))
occ_test_final<-na.omit(occ_test)
occ_test_final<-subset(occ_test_final,
                       select=-c(Country,lat,lon,Region,County,
                                                  Plants.with.FAW,Hectares.Checked,geometry))

#converting bg to sf object
bg_values<-st_as_sf(bg,
                    coords = c("x","y"))
# set the coordinate reference system (CRS)
st_crs(bg_values) <- "+proj=longlat +datum=WGS84"

# repeat the number 1 as many numbers as the number of rows
# in p, and repeat 0 as the rows of background points
pa <- c(rep(1, nrow(occ_train_final)), 
        rep(0, nrow(bg_values)))


#creating a data frame
padf<-as.data.frame(rbind(occ_train_final,bg_values))

#removing the geometry column since maxent does not require it
padf<-subset(padf, select=-c(geometry))

#checking if there are Na values
which(is.na(padf))

if (!file.exists(paste0(system.file("java",
                                    package = "dismo"),"/maxent.jar"))){
  utils::download.file(url = "https://raw.githubusercontent.com/mrmaxent/Maxent/master/ArchivedReleases/3.3.3k/maxent.jar", 
                       destfile = paste0(system.file("java", package = "dismo"), 
                                         "/maxent.jar"), mode = "wb")
  
}

#generating the model
mod<-maxent(x=padf,
            p=pa,
            path=getwd(),
            args=c("responsecurves"),
            species="FAW")


#performing prediction
pred1<-predict(mod,bioCurrent)
plot(pred1)

#converting the prediction to dataframe
df<-as.data.frame(pred1,xy=TRUE)

# Generate a custom color palette
library(RColorBrewer)
colors <- brewer.pal(9, "YlOrRd")  # You can choose a different palette if needed

# Plotting
ggplot(data = df) +
  geom_raster(aes(x = x, y = y, fill = layer)) +
  scale_fill_gradientn(name = "FAW's", 
                       colours = colors,
                       na.value = "transparent") +  # Set NA value to transparent
  geom_sf(data = machakos,
          fill = NA) +
  labs(title = "Distribution of Fall Armyworms in Machakos County")


#evaluating the model using training set
mod_eval_train <- dismo::evaluate(p = occ_train_final, a = bg_values, model = mod)
print(mod_eval_train)

#evaluating the model using testing set
mod_eval_test <- dismo::evaluate(p = occ_test_final,a = bg_values,model = mod)
print(mod_eval_test)



#FUTURE FAW OCCURRENCES
#Import future climatic data
F1<-raster("ip45bi701_Machakos.tif" )
F2<-raster("ip45bi702_Machakos.tif")
F3<-raster("ip45bi703_Machakos.tif")
F4<-raster("ip45bi704_Machakos.tif")
F5<-raster("ip45bi705_Machakos.tif")
F6<-raster("ip45bi706_Machakos.tif")
F7<-raster("ip45bi707_Machakos.tif")
F8<-raster("ip45bi708_Machakos.tif")
F9<-raster("ip45bi709_Machakos.tif")
F10<-raster("p45bi7010_Machakos.tif")
F11<-raster("p45bi7011_Machakos.tif")
F12<-raster("p45bi7012_Machakos.tif")
F13<-raster("p45bi7013_Machakos.tif")
F14<-raster("p45bi7014_Machakos.tif")
F15<-raster("p45bi7015_Machakos.tif")
F16<-raster("p45bi7016_Machakos.tif")
F17<-raster("p45bi7017_Machakos.tif")
F18<-raster("p45bi7018_Machakos.tif")
F19<-raster("p45bi7019_Machakos.tif")

#stack the future bios
bioFuture<-stack(F1,F2,F3,F4,F5,F6,F7,F8,F9,F10,F11,F12,F13,F14,F15,F16,F17,F18,F19)
names(bioFuture)<-c("bio01","bio02","bio03","bio04","bio05","bio06","bio07","bio08",
                    "bio09","bio10","bio11","bio12","bio13","bio14","bio15",
                    "bio16","bio17","bio18","bio19")
plot(bioFuture)

#crop and mask
machakos_bioFuturecrop<-crop(bioFuture,machakos)
machakos_bioFuture<-mask(machakos_bioFuturecrop,machakos)
plot(machakos_bioFuture)

#We now predict the distribution of FWA in realted to the projected climate data. In 50 years time.
FAW_proj<-predict(mod,machakos_bioFuture)
plot(FAW_proj)

#converting the prediction to dataframe
fdf<-as.data.frame(FAW_proj,xy=TRUE)

#plotting
ggplot(data = fdf) +
  geom_raster(aes(x = x, y = y, fill = layer)) +
  scale_fill_gradientn(name = "FAW's", 
                       colours = colors,
                       na.value = "transparent") +  # Set NA value to transparent
  geom_sf(data = machakos,
          fill = NA) +
  labs(title = "Future Distribution of Fall Armyworms in Machakos County")

#the current and future distribution of elephants
library(patchwork)

p1 <- ggplot(data = df) +
  geom_raster(aes(x = x, y = y, fill = layer)) +
  scale_fill_gradientn(name = "FAW's", 
                       colours = colors,
                       na.value = "transparent") +  # Set NA value to transparent
  geom_sf(data = machakos,
          fill = NA) +
  labs(title = "Current Distribution of Fall Armyworms in Machakos County")

p2 <- ggplot(data = fdf) +
  geom_raster(aes(x = x, y = y, fill = layer)) +
  scale_fill_gradientn(name = "FAW's", 
                       colours = colors,
                       na.value = "transparent") +  # Set NA value to transparent
  geom_sf(data = machakos,
          fill = NA) +
  labs(title = "Future Distribution of Fall Armyworms in Machakos County")

# Combine plots side by side
combined_plot <- wrap_plots(p1, p2, ncol = 2)
combined_plot

