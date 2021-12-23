The workflow was mainly developed in ImageJ macro language (implemented in the Fiji distribution v1.53n)  [1] with the cell segmentation performed with cellpose [2]. For each image, the signal channel was extracted and saved to a png file format. Then, each png file was uploaded to https://www.cellpose.org/ to get the corresponding segmentation by asking cellpose to segment cytoplasms of diameter 60 pixels by considering grayscale images without nuclei channel.

After this manual step, an ImageJ macro script was developed to open the original image, extract the signal channel, and subtract the background (rolling ball algorithm [3] with radius 50 pixels). Then the cellpose corresponding mask was open, converted to a 16-bit grayscale image, and relabelled with command closeIndexGapsInLabelMap of CLIJ2 plugin [4]. Finally, the resulting labeled image and the background-subtracted signal channel were used to quantify the fluorescence intensity with the command Intensity Measurements 2D/3D of MorpholibJ plugin [5].


1.	Schindelin J., Arganda-Carreras I., Frise E., Kaynig V., Longair M., Pietzsch T., Preibisch S., Rueden C., Saalfeld S., Schmid B., Tinevez J.Y., White D.J., Hartenstein V., Eliceiri K., Tomancak P., and Cardona A., Fiji: an open-source platform for biological-image analysis. Nature Methods, 2012. 9(7): p. 676-682.
2.	Stringer C., Wang T., Michaelos M., and Pachitariu M., Cellpose: a generalist algorithm for cellular segmentation. Nat Methods, 2021. 18(1): p. 100-106.
3.	Sternberg, Biomedical Image Processing. Computer, 1983. 16(1): p. 22-34.
4.	Haase R., Royer L.A., Steinbach P., Schmidt D., Dibrov A., Schmidt U., Weigert M., Maghelli N., Tomancak P., Jug F., and Myers E.W., CLIJ: GPU-accelerated image processing for everyone. Nat Methods, 2020. 17(1): p. 5-6.
5.	Legland D., Arganda-Carreras I., and Andrey P., MorphoLibJ: integrated library and plugins for mathematical morphology with ImageJ. Bioinformatics, 2016. 32(22): p. 3532-3534.

