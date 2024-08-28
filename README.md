# ISU_McNay Repro Performance 

This is a repository containing the ISU McNay herd's yearly reproductive performance data. In this repository there is a folder titled "year_sheets" that conatins csv files with yearly/seasonal reproductive data. These files are used in the R script to generate reproductive performance summaries. The R script contains code to run summary statistics for reproductive performance. The follow percentages are generated: artificial insemination (AI), natural service (NS), open, pregnancy loss, and calf death loss. Total numbers for exposed cows in each year/season and calves born in each year/season are also generated. Graphical bar displays of year/season percentages are plotted and saved individually. 


## Year_Sheets Formatting 

The year sheets are split between year and season and named accordily. For example, all the spring calves born in 2023 will be included in the file "calving_spring_2023.csv" and all fall 2023 calves will be in the "calving_fall_2023.csv". 

Each csv sheet contains the following header: calfID	cowID	DOB	calf_died	AI	Preg_loss	Twin	No_breed	Group
* calfID: the tag number of the calf born. _Note: this may be blank if no calf was born from the exposed cow._
* cowID: the tag number of the female. All females that are listed are exposed. Each row should contain a cowID 
* DOB: the calf's date of birth
* calf_died: if the calf died during or after birth there will be a "1" in this column
* AI: describes if and how each female was bred. AI bred females recieve a "1", NS females recieve a "2", open females (who did not get bred) recieve a "0" in this column. Any NA's in this column will be from females who lost thier pregnancy. 
* preg_loss: if the female was confirmed bred at the time of pregnancy determination but did not have a calf, she is thought to have lost her pregnancy and will recieve a 1 in this column. 
* Twin: If a calf was a twin, **ONE** of the calves will recieve a "1" in this column to represent the pair. 
* No_Breed: if the female was not AI exposed, she will reiceive a "1" in this column. 
* Group: refers to the breeding group of the female. The spring breeding groups are: heifers, threes, youngs, and olds. Fall bred females will all recieve "fall" in this column. 

### Formatting Year_sheets from farm sheets





