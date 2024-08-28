# ISU_McNay Repro Performance 

This is a repository containing the ISU McNay herd's yearly reproductive performance data. In this repository there is a folder titled "year_sheets" that conatins csv files with yearly/seasonal reproductive data. These files are used in the R script to generate reproductive performance summaries. The R script contains code to run summary statistics for reproductive performance. The follow percentages are generated: artificial insemination (AI), natural service (NS), open, pregnancy loss, and calf death loss. Total numbers for exposed cows in each year/season and calves born in each year/season are also generated. Graphical bar displays of year/season percentages are plotted and saved individually. 


## Year_Sheets Formatting 

The year sheets are split between year and season and named accordily. For example, all the spring calves born in 2023 will be included in the file "calving_spring_2023.csv" and all fall 2023 calves will be in the "calving_fall_2023.csv". 

Each csv sheet contains the following header: calfID	cowID	DOB	calf_died	AI	Preg_loss	Twin	No_breed	Group
* calfID: the tag number of the calf born. _Note: this may be blank if no calf was born from the exposed cow._
* cowID: the tag number of the female. All females that are listed are exposed. Each row should contain a cowID 
* DOB: the calf's date of birth
* calf_died: if the calf died during or after birth there will be a "1" in this column
* AI: describes if and how each female was bred. AI bred females recieve a "1", NS females recieve a "2", open females (who did not get bred) recieve a "0" in this column. Any NA's in this column will be from females who lost thier pregnancy or if the calf is a twin. Only 1 calf in the twin pair will recieve a AI status. 
* preg_loss: if the female was confirmed bred at the time of pregnancy determination but did not have a calf, she is thought to have lost her pregnancy and will recieve a 1 in this column. 
* Twin: If a calf was a twin, **ONE** of the calves will recieve a "1" in this column to represent the pair. 
* No_Breed: if the female was not AI exposed, she will reiceive a "1" in this column. 
* Group: refers to the breeding group of the female. The spring breeding groups are: heifers, threes, youngs, and olds. Fall bred females will all recieve "fall" in this column. 

### Formatting Year_sheets from farm sheets

_Please update this section as the formatting of the farm sheets change._

In the "McNay Cattle Info" foler in Cybox there are breeding and calving sheets. The csv files used in this repository are based on the calving year. Therefore, new sheets will get made after each calving season. The breeding sheet will be labeled 1 year prior to the calving sheet. For example, if you are generating a csv file for calves born in 2024, you will use the 2024 calving records and the 2023 breeding records. 

Calving sheets: Are based on year and have 5 tabs across the bottom: heifers, threes, youngs, olds, and falls. In the csv file you are generating, heifers, threes, youngs, and olds will be on a file labeled "spring" and the falls will be on a seperate csv file. 

Breeding sheets: Will have the following tabs: yearlings, twos, threes, youngs, olds, and fall. The yearlings are the heifers. Twos are first calf heifers and will match up to the threes tab on the calving sheet. Threes on the breeding sheet will be rolled over to the young cow group on the calving sheet and the oldest year in the young cow group will be rolled over to the olds. When you are copy and pasting information over, pay close attention to these changes, especially of you are seperating each breeding group by tab when first generating the excel file. You can avoid this by working all on one tab on an excel sheet, but that gets to be around 300-400 rows on an excel sheet. The following steps involve a lot of copy and pasting so I found it easier to work one calving season at a time. **The final assignment of Group will be based on the calving season group** If the female is in the threes at breeding and the youngs at calving then she should be assigned the young group.

1) Begin by pulling the female information from the breeding sheets. It may be easier to create 5 tabs on an excel sheet for each breeding group and then combine them onto 1 sheet at the end. You will need the CowID, Bred to, and Days bred columns.
2) Remove any females that were culled or sold prior to the pregnancy determination date.  
3) From the calving records sheet, pull the CalfID, CowID, Birth Date, and Twin information. The calves that died are usually highlighted but you will need to make notes of any calf deaths.
4) Log into Simmental's Herdbook and dump all the calf ID's into the Animal Serch. Select "Search only my animals". Click the toggle for Generate Report and select "Parentage Report". Download this report and an excel file.
5) Copy over the calf and sire information from the parentage report generated. Your excel sheet will be very messy now but we will clean it up. Leaving spaces the columns copied from each sheet will make sorting the columns easier. the headers of you excel sheet should look like this:
  CowID, Bred to, Days bred     _(space)_     CalfID, CowID, Birth Date, Twin    _(space)_    CalfID, Sire
6) Sort all three column groups (the column groups copied and pasted from the three sheets) based on calf ID.
7) Match up the Sire and CalfID columns pulled from Herdbook to the columns pulled from the calving sheets based on calfID. Once you complete this, the extra calf ID can be removed and your excel sheet should look like this:
  CowID, Bred to, Days bred     _(space)_     CalfID, CowID, Birth Date, Twin, Sire
8) Next, match up the newly combined columns to the columns from the calving sheets. _Note: if there are any twins then the breeding sheet would not have accounted for that. An additional row will need to be added to the breeding columns for each twin pair. Copy the birth date and dam information into your newly created row. Once all columns are matched up your sheet should look like this:
  CowID, Bred to, Days bred, CalfID, CowID, Birth Date, Twin, Sire
9) Make sure all dam's from twins have been added to the CowID in column 1. This column will include all females who calves and who did not calve so it is easiest to keep this row. Once you have done this, the middle CowID column can be removed.
10) Now you will compare the Sires to the Bred to columns. As of now, most AI sires are external bulls and not used as clean up bulls. Previously this farm used the same AI bulls as clean up bulls which made for differentiating AI vs NS a pain. Create an AI column - I like to use the Days Bred column as my AI column. Add a "1" to each row where both columns have the same sire, add a "2" if the sire differs from who they were bred to, and add a 0 to the columns where no calf was born **except** for the females who were confirmed pregnant at pregnancy determination - leave these cells blank. Keep the Bred to column for now since it may have no breed information. 
11) You can edit the Twin column now to only have a 1 for each twin pair. It doesn't matter which twin you assign the 1 to.
12) Either generate a No_breed column or just use the Bred to column as a no breed column. For each "No Breed" comment either in the Bred to column or in any cell along the Cow's row, add a 1 in this column. Leave all other cells that do not meet this criteria blank. _Note: most, if not all cells will be blank in this column. As the female group gets older, more cows will be no breeds. This just means that the cow was not AI exposed but she was still exposed to NS aka a bull. 
13) Remove the sire column and add a preg_loss and calf_died column. For each cow that was confirmed bred at the time of pregnancy determination, but did not have a calf, assign a "1" in the preg loss column. If the calf died (usually highlighed red on the spreadsheet or in the comments of the original calving sheet) assign a "1" in this column. If both twins died, both should recieve a "1" in this column.
14) Now order the columns in the following order: calfID	cowID	DOB	calf_died	AI	Preg_loss	Twin	No_breed	Group
15) Add what group each female is in **at calving time** to the Group column.

Congrats you did it! 

Note: if you are a Unix/Linus wizard, this data formating could be done using the terminal. Please add a code script to this repository if you are up for the challange. 




