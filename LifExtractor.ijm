/*

#  BIOIMAGING - INEB/i3S
Eduardo Conde-Sousa (econdesousa@gmail.com)

## Lif extraction
	1. Open lif file
	2. Select series that match name pattern
	3. extract one channel
	4. save it in output folder
 
### code version
1.0

### last modification
07/12/2021

### Requirements


### Attribution:
If you use this macro please add in the acknowledgements of your papers and/or thesis (MSc and PhD) the reference to Bioimaging and the project PPBI-POCI-01-0145-FEDER-022122.
As a suggestion you may use the following sentence:
 * The authors acknowledge the support of the i3S Scientific Platform Bioimaging, member of the national infrastructure PPBI - Portuguese Platform of Bioimaging (PPBI-POCI-01-0145-FEDER-022122).

*/


#@ File (style="directory",label="Select input directory") directory
#@ String(label="Series pattern", value = "quantification", description="filter series inside lif by pattern") pattern
#@ String(label="output format", choices={".png",".jpeg",".tif"}, style="list") outFormat

directory = directory + File.separator ;
filelist = getFileList(directory) ;
outDir= directory + "signalChannel"+File.separator ;
if (! File.exists(outDir)){
	File.makeDirectory(outDir);
}

close("*");
print("\\Clear");
selectWindow("Log");
for (i = 0; i < lengthOf(filelist); i++) {
    if (endsWith(filelist[i], ".lif")) {
    	print(filelist[i]);
    	seriesList = getLifSeriesNames(directory + filelist[i]);
    	namePatternSubArray = arrayFilterUpdate(seriesList,pattern);
    	patternIndexes = getSeriesIndex(seriesList,namePatternSubArray);
    	for (j = 0; j < lengthOf(patternIndexes); j++) {
    		print(" ***************** ",patternIndexes[j],seriesList[patternIndexes[j]-1]);
    		setBatchMode(true);
    		run("Bio-Formats Importer", "open=["+directory + filelist[i]+"] autoscale color_mode=Default rois_import=[ROI manager] view=Hyperstack stack_order=XYCZT series_"+patternIndexes[j]);
    		Stack.getDimensions(width, height, channels, slices, frames);
    		if (slices >1){
    			close();
    		}else {
    			id=getImageID();
    			run("Duplicate...", "  channels=1");	
    			selectImage(id);close();
    			saveAs(outFormat,outDir + filelist[i]+"_"+seriesList[patternIndexes[j]-1]);
    			close("*");   			
    		}
    	}

    } 
}




function getLifSeriesNames(inputfile) { 
	
	run("Bio-Formats Macro Extensions");
	Ext.setId(inputfile);
	Ext.getSeriesCount(seriesCount);
	
	seriesList = newArray;
	
	for (s = 0; s < seriesCount; s++){
		Ext.setSeries(s);
		Ext.getSeriesName(seriesName);
		seriesList = Array.concat(seriesList, seriesName);
	}
	
	return seriesList;
}
function getSeriesIndex(inputArray,smallArray){
	a=newArray(lengthOf(inputArray));
	for (i = 0; i < lengthOf(smallArray); i++) {
		for (j=0; j < lengthOf(inputArray); j++){
			if (indexOf(inputArray[j], smallArray[i])>-1){
				a[j]=1;
			}
		}
	}
	b=newArray;
	for (i = 0; i < lengthOf(inputArray); i++) {
		if (a[i]==1){
			b=Array.concat(b,i+1);
		}
	}

	return b;
}

function arrayFilterUpdate(inputArray,keyword) { 
	keywords=split(keyword, "*");
	outArray = Array.copy(inputArray);
	for (i = 0; i < lengthOf(keywords); i++) {
		outArray = Array.filter(outArray, keywords[i]);
	}
	return outArray;
}