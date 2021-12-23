/*

#  BIOIMAGING - INEB/i3S
Eduardo Conde-Sousa (econdesousa@gmail.com)

## Intensity Quantification after CellPose
	1. Open tif or png file (intensity channel)
	2. Open corresponding CELLPOSE match (final part of the filename equal to original filename + _masks.png)
	3. subtract background on original intensity image
	4. calculate intensity measurments per cell
	5. Save Results table to input directory
 
### code version
1.1

### last modification
09/12/2021

### Requirements
	CLIJ2 (and dependencies)
	IJPB-plugins


### Attribution:
If you use this macro please add in the acknowledgements of your papers and/or thesis (MSc and PhD) the reference to Bioimaging and the project PPBI-POCI-01-0145-FEDER-022122.
As a suggestion you may use the following sentence:
 * The authors acknowledge the support of the i3S Scientific Platform Bioimaging, member of the national infrastructure PPBI - Portuguese Platform of Bioimaging (PPBI-POCI-01-0145-FEDER-022122).

*/


#@ String (value="Define Signal Images & masks inDir", visibility="MESSAGE") hint1
#@ String (value="Expected contents:pairs of images named FILENAME.png and FILENAME_masks.png", visibility="MESSAGE") hint2
#@ File (label="Signal Images & masks inDir" ,style="directory") inDir
#@ String (label="input file format", choices={".png",".tif"}, style="list") inputFormat


inDir = inDir+ File.separator ;
filelist = getFileList(inDir) ;


for (i = 0; i < lengthOf(filelist); i++) {
	if (endsWith(filelist[i], inputFormat)) {
		ind = lastIndexOf(filelist[i], ".lif");
		targetName = filelist[i];
		targetName = targetName.substring(ind, lastIndexOf(targetName, inputFormat))+ "_masks.png";
	
		for (j = 0; j < lengthOf(filelist); j++){
			if (indexOf(filelist[j], targetName)>-1) {
				signalImage=inDir+filelist[i];  
				maskImage=inDir+filelist[j];

	    		run("Clear Results");
	    		open(signalImage);
	   			signalName = "Signal";
	   			rename(signalName);
	   			run("Subtract Background...", "rolling=50");
	   			getVoxelSize(width, height, depth, unit);

	   			
	   			open(maskImage);
	   			run("16-bit");	 
	   			maskName = "Mask";
	   			rename(maskName);
	   			run("CLIJ2 Macro Extensions", "cl_device=[]");
	   			Ext.CLIJ2_clear();
				Ext.CLIJ2_push(maskName);
				selectWindow(maskName);
				close();
				image2 = "relabeled";
				Ext.CLIJ2_closeIndexGapsInLabelMap(maskName, image2);
				Ext.CLIJ2_pull(image2);
				setVoxelSize(width, height, depth, unit);
				run("Intensity Measurements 2D/3D", "input=Signal labels=relabeled mean stddev max min median mode volume");
				Table.rename("Signal-intensity-measurements", "Results");
				selectWindow("Results");
				saveAs("Results", inDir + replace(filelist[i], inputFormat, "_results.tsv") );
				close("*");
				selectWindow("Results");
				run("Close");
				Ext.CLIJ2_clear();
    		}
		}
	}
}




